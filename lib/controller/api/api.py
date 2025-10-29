from flask import Flask, request, jsonify
import sqlite3
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime

DB_NAME = "gym.db"

app = Flask(__name__)

def get_db():
    conn = sqlite3.connect(DB_NAME)
    conn.row_factory = sqlite3.Row
    return conn

# --- USER REGISTRATION ---
@app.route("/register", methods=["POST"])
def register():
    data = request.json
    username = data.get("username")
    email = data.get("email")
    password = data.get("password")

    if not all([username, email, password]):
        return jsonify({"error": "Missing fields"}), 400

    conn = get_db()
    cursor = conn.cursor()

    try:
        cursor.execute("""
            INSERT INTO users (username, email, password_hash)
            VALUES (?, ?, ?)
        """, (username, email, generate_password_hash(password)))
        conn.commit()
        return jsonify({"message": "User registered successfully"}), 201
    except sqlite3.IntegrityError:
        return jsonify({"error": "Username or email already exists"}), 409
    finally:
        conn.close()


# --- USER LOGIN ---
@app.route("/login", methods=["POST"])
def login():
    data = request.json
    username = data.get("username")
    password = data.get("password")

    conn = get_db()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE username = ?", (username,))
    user = cursor.fetchone()
    conn.close()

    if user and check_password_hash(user["password_hash"], password):
        return jsonify({"message": "Login successful", "user_id": user["id"]})
    return jsonify({"error": "Invalid credentials"}), 401


# --- GET EQUIPMENT BY QR CODE ---
@app.route("/equipment/<qr_code>", methods=["GET"])
def get_equipment(qr_code):
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT * FROM equipment WHERE qr_code = ?
    """, (qr_code,))
    equipment = cursor.fetchone()
    if not equipment:
        return jsonify({"error": "Equipment not found"}), 404

    cursor.execute("""
        SELECT * FROM exercises WHERE equipment_id = ?
    """, (equipment["id"],))
    exercises = [dict(row) for row in cursor.fetchall()]

    conn.close()
    return jsonify({
        "equipment": dict(equipment),
        "exercises": exercises
    })


# --- LOG A WORKOUT SESSION ---
@app.route("/sessions", methods=["POST"])
def log_session():
    data = request.json
    user_id = data.get("user_id")
    exercise_id = data.get("exercise_id")
    weight = data.get("weight")
    reps = data.get("reps")
    notes = data.get("notes")

    if not all([user_id, exercise_id]):
        return jsonify({"error": "Missing fields"}), 400

    conn = get_db()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO sessions (user_id, exercise_id, weight, reps, notes)
        VALUES (?, ?, ?, ?, ?)
    """, (user_id, exercise_id, weight, reps, notes))
    conn.commit()
    conn.close()

    return jsonify({"message": "Session recorded"}), 201


# --- GET USER SESSIONS ---
@app.route("/sessions/<int:user_id>", methods=["GET"])
def get_sessions(user_id):
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT s.id, s.weight, s.reps, s.notes, s.created_at,
               e.name AS exercise_name, e.primary_muscle, e.category
        FROM sessions s
        JOIN exercises e ON s.exercise_id = e.id
        WHERE s.user_id = ?
        ORDER BY s.created_at DESC
    """, (user_id,))
    sessions = [dict(row) for row in cursor.fetchall()]
    conn.close()

    return jsonify({"sessions": sessions})


# --- CALCULATE USER STATS ON THE FLY ---
@app.route("/stats/<int:user_id>", methods=["GET"])
def user_stats(user_id):
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT e.primary_muscle,
               SUM(s.reps) AS total_reps,
               SUM(s.weight * s.reps) AS total_volume
        FROM sessions s
        JOIN exercises e ON s.exercise_id = e.id
        WHERE s.user_id = ?
        GROUP BY e.primary_muscle
    """, (user_id,))
    stats = [dict(row) for row in cursor.fetchall()]
    conn.close()

    return jsonify({"stats": stats})


if __name__ == "__main__":
    app.run(debug=True)
