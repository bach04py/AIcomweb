import sqlite3, os
from datetime import datetime

BASE_DIR = os.path.dirname(__file__)
DB_PATH = os.path.join(BASE_DIR, "database.db")

print(f"📦 Đang kiểm tra hoặc tạo database tại: {DB_PATH}")

conn = sqlite3.connect(DB_PATH)
cur = conn.cursor()

# =========================
# 1️⃣ Tạo bảng USERS
# =========================
cur.execute("""
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    email TEXT UNIQUE,
    password TEXT,
    name TEXT,
    role TEXT CHECK(role IN ('admin', 'writer', 'user')) DEFAULT 'user',
    created_at TEXT
)
""")

# =========================
# 2️⃣ Tạo bảng POSTS (thêm cột category)
# =========================
cur.execute("""
CREATE TABLE IF NOT EXISTS posts (
    id TEXT PRIMARY KEY,
    title TEXT,
    content TEXT,
    image TEXT,
    video TEXT,
    category TEXT DEFAULT 'Tin tức',
    author_id TEXT,
    created_at TEXT,
    updated_at TEXT,
    FOREIGN KEY (author_id) REFERENCES users(id)
)
""")

# =========================
# 🧩 Đảm bảo bảng POSTS có cột 'category'
# =========================
cur.execute("PRAGMA table_info(posts)")
columns = [row[1] for row in cur.fetchall()]

if "category" not in columns:
    print("⚙️ Bảng 'posts' thiếu cột 'category' → đang thêm...")
    cur.execute("ALTER TABLE posts ADD COLUMN category TEXT DEFAULT 'Tin tức';")
    conn.commit()
    print("✅ Đã thêm cột 'category' thành công.")
else:
    print("ℹ️ Bảng 'posts' đã có cột 'category'.")

# =========================
# 3️⃣ Tạo bảng COMMENTS
# =========================
cur.execute("""
CREATE TABLE IF NOT EXISTS comments (
    id TEXT PRIMARY KEY,
    post_id TEXT,
    user_id TEXT,
    text TEXT,
    created_at TEXT,
    FOREIGN KEY (post_id) REFERENCES posts(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
)
""")

# =========================
# 4️⃣ Thêm tài khoản admin mặc định (nếu chưa có)
# =========================
admin_email = "admin@aicomgroup.vn"
cur.execute("SELECT * FROM users WHERE email=?", (admin_email,))
if not cur.fetchone():
    cur.execute("""
        INSERT INTO users (id, email, password, name, role, created_at)
        VALUES (?, ?, ?, ?, ?, ?)
    """, (
        "admin-001",
        admin_email,
        "123456",  # 🔑 Mật khẩu mặc định
        "Admin",
        "admin",
        datetime.now().isoformat()
    ))
    print(f"✅ Đã tạo tài khoản admin mặc định: {admin_email}")
else:
    print("ℹ️ Tài khoản admin đã tồn tại.")

# =========================
# Hoàn tất
# =========================
conn.commit()
conn.close()

print("🎉 Database đã được khởi tạo hoặc cập nhật thành công!")

