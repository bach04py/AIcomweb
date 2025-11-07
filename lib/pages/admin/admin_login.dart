import 'package:flutter/material.dart';
import 'admin_session.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  String? errorMessage;

  Future<void> _login() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      setState(() {
        loading = false;
        errorMessage = "Vui lòng nhập đầy đủ Email và Mật khẩu.";
      });
      return;
    }

    final success = await AdminSession.login(email, pass);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🎉 Đăng nhập thành công!")),
      );
      Navigator.pushReplacementNamed(context, '/admin/dashboard');
    } else {
      setState(() => errorMessage = "Sai thông tin đăng nhập.");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("AICOM ADMIN LOGIN",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Mật khẩu"),
              ),
              const SizedBox(height: 20),
              if (errorMessage != null)
                Text(errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: loading ? null : _login,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Đăng nhập"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

