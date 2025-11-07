import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config.dart';

class UserManagerPage extends StatefulWidget {
  const UserManagerPage({super.key});

  @override
  State<UserManagerPage> createState() => _UserManagerPageState();
}

class _UserManagerPageState extends State<UserManagerPage> {
  List users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final res = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/users'));
      if (res.statusCode == 200) {
        setState(() {
          users = jsonDecode(res.body);
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("⚠️ Lỗi khi tải danh sách user: $e");
      setState(() => loading = false);
    }
  }

  Future<void> _deleteUser(String id) async {
    try {
      final res =
          await http.delete(Uri.parse('${AppConfig.apiBaseUrl}/users?id=$id'));
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("🗑️ Đã xóa người dùng")),
        );
        _loadUsers();
      }
    } catch (e) {
      debugPrint("❌ Lỗi khi xóa user: $e");
    }
  }

  Future<void> _addUserDialog() async {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    String role = "user";

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thêm người dùng mới"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Tên")),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: passCtrl, decoration: const InputDecoration(labelText: "Mật khẩu")),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: role,
                items: const [
                  DropdownMenuItem(value: "user", child: Text("Người dùng")),
                  DropdownMenuItem(value: "admin", child: Text("Quản trị viên")),
                ],
                onChanged: (v) => role = v ?? "user",
                decoration: const InputDecoration(labelText: "Vai trò"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _addUser(nameCtrl.text, emailCtrl.text, passCtrl.text, role);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text("Thêm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addUser(String name, String email, String password, String role) async {
    try {
      final res = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/users'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "role": role,
        }),
      );
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Thêm người dùng thành công")),
        );
        _loadUsers();
      } else {
        final data = jsonDecode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ ${data["error"] ?? "Thêm thất bại"}")),
        );
      }
    } catch (e) {
      debugPrint("❌ Lỗi khi thêm user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("👥 Quản lý người dùng"),
        backgroundColor: const Color(0xFF004AAD),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF004AAD),
        icon: const Icon(Icons.person_add),
        label: const Text("Thêm người dùng"),
        onPressed: _addUserDialog,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text("Chưa có người dùng nào."))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, i) {
                    final u = users[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: u["role"] == "admin"
                              ? Colors.redAccent.withOpacity(0.2)
                              : Colors.blueAccent.withOpacity(0.2),
                          child: Icon(
                            u["role"] == "admin"
                                ? Icons.admin_panel_settings
                                : Icons.person_outline,
                            color: u["role"] == "admin"
                                ? Colors.redAccent
                                : Colors.blueAccent,
                          ),
                        ),
                        title: Text(u["name"] ?? "Không rõ"),
                        subtitle: Text("${u["email"] ?? ""}\nQuyền: ${u["role"]}"),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: "Xóa người dùng",
                          onPressed: () => _confirmDelete(context, u),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _confirmDelete(BuildContext context, Map user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa người dùng"),
        content: Text("Bạn có chắc muốn xóa '${user["name"]}' không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(user["id"]);
            },
            child: const Text("Xóa"),
          ),
        ],
      ),
    );
  }
}

