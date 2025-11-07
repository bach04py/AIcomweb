# 🌿 AICOM GROUP Web Platform

> **AICOM Group Web** là nền tảng website đa dịch vụ được phát triển bằng **Flutter Web** (frontend) và **Flask (Python)** (backend).
>  
> Mục tiêu của dự án là mang đến giao diện hiện đại, mượt mà, tối ưu cho doanh nghiệp chuyển đổi số — với các chuyên mục **Dịch vụ, Dự án, Tin tức, Tuyển dụng** và hệ thống **quản trị nội dung (CMS)** thân thiện.

---

## 🧭 Tổng quan dự án

### 🔹 Công nghệ sử dụng:
| Thành phần | Công nghệ chính |
|-------------|----------------|
| **Frontend (UI)** | Flutter Web, Dart |
| **Backend (API)** | Flask, Python |
| **Database** | SQLite |
| **Giao tiếp** | RESTful API (CORS enabled) |
| **Triển khai** | GitHub Pages (frontend) / Render hoặc Vercel (backend) |

---

## 📁 Cấu trúc thư mục

AIcomweb/
├── lib/ # Mã nguồn Flutter
│ ├── pages/ # Các trang giao diện chính
│ │ ├── home_page.dart
│ │ ├── about_page.dart
│ │ ├── services_page.dart
│ │ ├── services/ # Các dịch vụ con
│ │ │ ├── dao_tao_page.dart
│ │ │ ├── logistics_page.dart
│ │ │ └── son_page.dart
│ ├── widgets/ # Header, Footer, Layout
│ ├── config.dart # URL cấu hình backend API
│ └── main.dart # Entry point Flutter
│
├── assets/ # Logo, ảnh, video
│ └── images/aicom.png
│
├── server/ # Flask backend
│ ├── app.py # API chính
│ ├── database.db # SQLite DB
│ ├── uploads/ # Thư mục chứa ảnh/video upload
│ ├── requirements.txt # Gói Python cần cài
│ └── init_db.py # Script tạo database mặc định
│
├── pubspec.yaml # Thư viện Flutter
├── README.md # File hướng dẫn này
└── .gitignore

yaml
Sao chép mã

---

## ⚙️ Cài đặt môi trường

### 1️⃣ Cài **Backend (Flask)**

Yêu cầu:
- Python 3.10+
- pip

Cài đặt:
```bash
cd server
pip install -r requirements.txt
python app.py
Server Flask chạy tại:

cpp
Sao chép mã
http://127.0.0.1:5000
Khi chạy lần đầu, file database.db và thư mục uploads/ sẽ được tự động tạo.

2️⃣ Cài Frontend (Flutter Web)
Yêu cầu:

Flutter SDK ≥ 3.19

Dart ≥ 3.3

Chrome hoặc Edge

Cài đặt:

bash
Sao chép mã
flutter pub get
flutter run -d chrome
Build bản web:

bash
Sao chép mã
flutter build web --release
Output:
build/web/ — có thể deploy lên GitHub Pages hoặc Netlify.

🌐 Cấu hình kết nối Frontend ↔ Backend
Mở file lib/config.dart:

dart
Sao chép mã
class AppConfig {
  static const String apiBaseUrl = "http://127.0.0.1:5000/api";
}
Khi deploy Flask lên server khác (Render, Vercel, ...), chỉ cần đổi thành:

dart
Sao chép mã
static const String apiBaseUrl = "https://aicom-api.onrender.com/api";
🚀 Deploy hướng dẫn nhanh
🌍 Deploy Flutter Web lên GitHub Pages
bash
Sao chép mã
flutter build web --release
git subtree push --prefix build/web origin gh-pages
Sau đó website có thể truy cập tại:
https://bach04py.github.io/AIcomweb/

☁️ Deploy Flask Backend lên Render
Truy cập https://render.com

Kết nối repo GitHub của bạn

Chọn thư mục server/

Cấu hình build:

yaml
Sao chép mã
Build Command: pip install -r requirements.txt
Start Command: python app.py
Bấm Deploy

🧠 Tính năng nổi bật
Tính năng	Mô tả
🌈 Giao diện động (Flutter Web)	Hiệu ứng hover, animation, gradient động
🧩 Header dropdown thông minh	Menu "Dịch vụ" có submenu trượt mượt mà
📰 Quản lý bài viết (CMS)	CRUD bài viết, upload ảnh/video
📂 Flask REST API	/api/posts, /api/upload, /api/login, ...
🔐 Hệ thống Admin	Đăng nhập, tạo bài viết, quản lý user
🌿 Responsive & hiện đại	Thiết kế phù hợp web và desktop
🧱 SQLite database	Dễ triển khai, không cần cài đặt thêm server

🔌 Các API chính (Flask)
Phương thức	Endpoint	Mô tả
POST	/api/login	Đăng nhập admin
GET	/api/posts	Lấy danh sách bài viết
POST	/api/posts/add	Tạo bài viết mới
PUT	/api/posts/update/<id>	Cập nhật bài viết
DELETE	/api/posts/delete/<id>	Xóa bài viết
POST	/api/upload	Upload ảnh/video

🛠️ Phát triển & Đóng góp
Fork repository

Tạo branch mới:

bash
Sao chép mã
git checkout -b feature/new-feature
Commit và push:

bash
Sao chép mã
git commit -m "Add new feature"
git push origin feature/new-feature
Tạo Pull Request trên GitHub 🎉

🧑‍💻 Tác giả
👨‍💻 Nguyễn Xuân Bách
📧 bach04py@github.com
🌐 https://github.com/bach04py
🧠 AI & Web Developer @ AICOM Group

📄 Giấy phép
MIT License © 2025 — AICOM Group
Bạn được phép sử dụng, sửa đổi, và phân phối dự án này với điều kiện giữ lại phần bản quyền gốc.

🪴 Gợi ý mở rộng
🔹 Triển khai Flask API lên Vercel hoặc Render

🔹 Thêm authentication JWT (đăng nhập bảo mật)

🔹 Chuyển database sang PostgreSQL nếu deploy production

🔹 Tối ưu SEO cho Flutter Web (dùng meta tags trong index.html)

yaml
Sao chép mã

---

## ✅ Tóm tắt
Bạn chỉ cần tạo 2 file sau trong repo:

### `server/requirements.txt`
```txt
Flask==3.0.3
Flask-Cors==4.0.1
Werkzeug==3.0.4
Jinja2==3.1.4
click==8.1.7
sqlite-utils==3.36
python-dotenv==1.0.1
