import 'package:flutter/material.dart';

// ======= Các trang chính =======
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/services_page.dart';
import 'pages/projects_page.dart';
import 'pages/news_page.dart';
import 'pages/gallery_page.dart';
import 'pages/careers_page.dart';
import 'pages/contact_page.dart';
import 'pages/post_detail_page.dart';

// ======= Các trang con Dịch vụ =======
import 'pages/services/dao_tao_page.dart';
import 'pages/services/logistics_page.dart';
import 'pages/services/son_page.dart';

// ======= Admin =======
import 'pages/admin/admin_login.dart';
import 'pages/admin/admin_dashboard.dart' show AdminDashboardPage;
import 'pages/admin/admin_session.dart' show AdminSession;
import 'pages/admin/post_editor.dart';
import 'pages/admin/user_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Nếu ApiClient/AdminSession cần init thì gọi ở đây
  await AdminSession.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AICOM Group',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(secondary: const Color(0xFF4CAF50)),
      ),
      initialRoute: '/',

      // routes: mỗi route trả về 1 Widget hoàn chỉnh (đã có Header/Footer bên trong)
      routes: {
        '/': (context) => const HomePage(),
        '/about': (context) => const AboutPage(),
        '/services': (context) => const ServicesPage(),
        '/projects': (context) => const ProjectsPage(),
        '/news': (context) => const NewsPage(),
        '/gallery': (context) => const GalleryPage(),
        '/careers': (context) => const CareersPage(),
        '/contact': (context) => const ContactPage(),
        '/post': (context) => const PostDetailPage(),

        '/services/dao-tao': (context) => const DaoTaoPage(),
        '/services/logistics': (context) => const LogisticsPage(),
        '/services/son': (context) => const SonPage(),

        '/admin': (context) => const AdminLoginPage(),
        '/admin/dashboard': (context) => const AdminDashboardPage(),
        '/admin/post_editor': (context) => const PostEditorPage(),
        '/admin/users': (context) => const UserManagerPage(),
      },
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}

