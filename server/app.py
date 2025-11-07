from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import sqlite3, os, uuid
from datetime import datetime
from werkzeug.utils import secure_filename

# ===================== CẤU HÌNH =====================
BASE_DIR = os.path.dirname(__file__)
DB_PATH = os.path.join(BASE_DIR, "database.db")
UPLOAD_DIR = os.path.join(BASE_DIR, "uploads")
WEB_BUILD_DIR = os.path.abspath(os.path.join(BASE_DIR, "../build/web"))

os.makedirs(UPLOAD_DIR, exist_ok=True)

app = Flask(__name__, static_folder=WEB_BUILD_DIR, static_url_path="")
CORS(app, supports_credentials=True)

# ===================== DATABASE =====================
def get_db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    conn = get_db()
    cur = conn.cursor()

    cur.execute("""
    CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        role TEXT DEFAULT 'admin',
        created_at TEXT
    )
    """)

    cur.execute("""
    CREATE TABLE IF NOT EXISTS posts (
        id TEXT PRIMARY KEY,
        title TEXT,
        content TEXT,
        image TEXT,
        video TEXT,
        category TEXT DEFAULT 'Tin tức',
        created_at TEXT,
        updated_at TEXT
    )
    """)

    conn.commit()
    conn.close()

init_db()

# ===================== AUTH =====================
@app.route("/api/login", methods=["POST"])
def login():
    data = request.json or {}
    email, password = data.get("email"), data.get("password")

    conn = get_db()
    cur = conn.cursor()
    cur.execute("SELECT * FROM users WHERE email=? AND password=?", (email, password))
    user = cur.fetchone()
    conn.close()

    if not user:
        return jsonify({"success": False, "message": "Sai thông tin đăng nhập"}), 401

    user_dict = dict(user)
    user_dict.pop("password", None)
    print(f"✅ Đăng nhập: {user_dict['email']}")
    return jsonify({"success": True, "user": user_dict}), 200

# ===================== POSTS =====================
@app.route("/api/posts", methods=["GET", "POST"])
def handle_posts():
    if request.method == "GET":
        try:
            conn = get_db()
            cur = conn.cursor()
            cur.execute("SELECT * FROM posts ORDER BY created_at DESC")
            posts = [dict(row) for row in cur.fetchall()]
            conn.close()
            print(f"📚 Lấy danh sách {len(posts)} bài viết")
            return jsonify(posts), 200
        except Exception as e:
            print(f"❌ Lỗi khi lấy danh sách bài viết: {e}")
            return jsonify({"success": False, "message": str(e)}), 500

    elif request.method == "POST":
        try:
            data = request.get_json(force=True, silent=True)
            if not data:
                print("⚠️ Không nhận được JSON hợp lệ từ client.")
                return jsonify({"success": False, "message": "Dữ liệu không hợp lệ"}), 400

            title = data.get("title")
            content = data.get("content")
            if not title or not content:
                print("⚠️ Thiếu tiêu đề hoặc nội dung.")
                return jsonify({"success": False, "message": "Thiếu tiêu đề hoặc nội dung"}), 400

            conn = get_db()
            cur = conn.cursor()
            post_id = str(uuid.uuid4())
            now = datetime.now().isoformat()

            cur.execute("""
                INSERT INTO posts (id, title, content, image, video, category, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                post_id,
                title,
                content,
                data.get("image"),
                data.get("video"),
                data.get("category", "Tin tức"),
                now,
                now
            ))
            conn.commit()
            conn.close()

            print(f"🆕 [POST /api/posts] Đã thêm bài viết: {title}")
            return jsonify({"success": True, "id": post_id}), 200

        except Exception as e:
            print(f"❌ Lỗi khi thêm bài viết: {e}")
            return jsonify({"success": False, "message": str(e)}), 500

@app.route("/api/posts/update/<post_id>", methods=["PUT"])
def update_post(post_id):
    try:
        data = request.json or {}
        now = datetime.now().isoformat()
        conn = get_db()
        cur = conn.cursor()
        cur.execute("""
            UPDATE posts
            SET title=?, content=?, image=?, video=?, category=?, updated_at=?
            WHERE id=?
        """, (
            data.get("title"),
            data.get("content"),
            data.get("image"),
            data.get("video"),
            data.get("category"),
            now,
            post_id
        ))
        conn.commit()
        conn.close()
        print(f"✏️ Đã cập nhật bài viết: {post_id}")
        return jsonify({"success": True}), 200
    except Exception as e:
        print(f"❌ Lỗi khi cập nhật bài viết: {e}")
        return jsonify({"success": False, "message": str(e)}), 500

@app.route("/api/posts/delete/<post_id>", methods=["DELETE"])
def delete_post(post_id):
    try:
        conn = get_db()
        cur = conn.cursor()
        cur.execute("DELETE FROM posts WHERE id=?", (post_id,))
        conn.commit()
        conn.close()
        print(f"🗑️ Đã xóa bài viết {post_id}")
        return jsonify({"success": True}), 200
    except Exception as e:
        print(f"❌ Lỗi khi xóa bài viết: {e}")
        return jsonify({"success": False, "message": str(e)}), 500

# ===================== UPLOAD =====================
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'mp4', 'mov', 'avi'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route("/api/upload", methods=["POST"])
def upload_file():
    try:
        if 'file' not in request.files:
            return jsonify({"success": False, "message": "Không có file"}), 400

        file = request.files['file']
        if file.filename == '':
            return jsonify({"success": False, "message": "Tên file rỗng"}), 400

        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            unique_name = f"{uuid.uuid4()}_{filename}"
            path = os.path.join(UPLOAD_DIR, unique_name)
            file.save(path)
            file_url = f"/uploads/{unique_name}"
            print(f"📤 Uploaded: {file_url}")
            return jsonify({"success": True, "url": file_url}), 200

        return jsonify({"success": False, "message": "Định dạng file không hợp lệ"}), 400
    except Exception as e:
        print(f"❌ Lỗi upload file: {e}")
        return jsonify({"success": False, "message": str(e)}), 500

@app.route("/uploads/<path:filename>")
def serve_upload(filename):
    return send_from_directory(UPLOAD_DIR, filename)

# ===================== FRONTEND =====================
@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def serve_flutter(path):
    index_file = os.path.join(WEB_BUILD_DIR, "index.html")
    if not os.path.exists(index_file):
        return "❌ Không tìm thấy Flutter build", 404
    full_path = os.path.join(WEB_BUILD_DIR, path)
    if os.path.isfile(full_path):
        return send_from_directory(WEB_BUILD_DIR, path)
    return send_from_directory(WEB_BUILD_DIR, "index.html")

# ===================== MAIN =====================
if __name__ == "__main__":
    print("🚀 Flask backend running at http://127.0.0.1:5000")
    app.run(host="0.0.0.0", port=5000, debug=True)

