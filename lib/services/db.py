import sqlite3
import csv
import os
import json
import time

DB_FILE = "gym.db"

print("Current working directory:", os.getcwd())

CSV_FILES = {
    "equipment": "equipment.csv",
    "exercises": "exercises.csv",
    "areas": "exercise_areas.csv"
}

import sqlite3

DB_NAME = "gym.db"

def init_db():
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()

    cursor.execute("PRAGMA foreign_keys = ON;")

    # --- USERS ---
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    """)

    # --- EQUIPMENT ---
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS equipment (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        qr_code TEXT UNIQUE NOT NULL,
        description TEXT,
        location TEXT
    );
    """)

    # --- EXERCISES ---
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        equipment_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        video_url TEXT,
        description TEXT,
        category TEXT CHECK(category IN ('push','pull','legs_core')),
        primary_muscle TEXT CHECK(primary_muscle IN ('arms','back','chest','legs','core','shoulders')),
        FOREIGN KEY (equipment_id) REFERENCES equipment (id) ON DELETE CASCADE
    );
    """)

    # --- SESSIONS ---
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        weight REAL,
        reps INTEGER,
        notes TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (exercise_id) REFERENCES exercises (id) ON DELETE CASCADE
    );
    """)

    # --- USER_STATS ---
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS user_stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        muscle_group TEXT CHECK(muscle_group IN ('arms','back','chest','legs','core','shoulders')),
        total_reps INTEGER DEFAULT 0,
        total_weight REAL DEFAULT 0,
        last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
    );
    """)

    conn.commit()
    conn.close()
    print(f"Database '{DB_NAME}' initialized successfully with schema.")

if __name__ == "__main__":
    init_db()


# --- Step 2: Seed from CSV ---
def seed_from_csv(table):
    table_map = {
        "users": "users",
        "exercises": "exercises",
        "equipment": "equipment",
        "sessions": "sessions"
    }

    if table not in table_map:
        print(f"No CSV defined for table '{table}'")
        return

    csv_file = CSV_FILES[table]
    if not os.path.exists(csv_file):
        print(f"CSV file '{csv_file}' not found!")
        return
    
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()
    rows_inserted = 0
    
    with open(csv_file, newline='', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            if table in ["equipment", "exercises"]:
                cursor.execute(f'''
                    INSERT OR IGNORE INTO {table_map[table]} (id, name, force, muscle)
                    VALUES (?, ?, ?, ?)
                ''', (row['id'], row['name'], row['force'], row['muscle']))
            elif table == "equipment":
                # expect exercise_ids as comma-separated string in CSV
                ids_list = json.dumps([int(x) for x in row['exercise_ids'].split(',') if x.strip()])
                cursor.execute(f'''
                    INSERT OR IGNORE INTO {table_map[table]} (id, name, exercise_ids)
                    VALUES (?, ?, ?)
                ''', (row['id'], row['name'], ids_list))
            rows_inserted += 1
    
    conn.commit()
    conn.close()
    print(f"Seeded {rows_inserted} rows into '{table_map[table]}' from '{csv_file}'.")

# --- Step 3: Manual Seeding ---
def seed_manually(table, data):
    """
    table: 'equipment', or 'exercises'
    data: list of dicts
    """
    table_map = {
        "users": "users",
        "equipment": "equipment",
        "exercises": "exercises",
        "sessions": "sessions"
    }

    if table not in table_map:
        print(f"Unknown table: {table}")
        return

    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()
    rows_inserted = 0
    
    for row in data:
        if table in ["users"]:
            cursor.execute(f'''
                INSERT OR IGNORE INTO {table_map[table]} (id, username, email, password_hash, created_at)
                VALUES (?, ?, ?, ?, ?)
            ''', (row['id'], row['username'], row['email'], row['password_hash'], row['created_at']))
        elif table == "equipment":
            cursor.execute(f'''
                INSERT OR IGNORE INTO {table_map[table]} (id, name, qr_code, description, location)
                VALUES (?, ?, ?, ?, ?)
            ''', (row['id'], row['name'], row['qr_code'], row['description'], row['location']))
        elif table == "exercises":
            cursor.execute(f'''
                INSERT OR IGNORE INTO {table_map[table]} (id, equipment_id, name, video_url, description, category, primary_muscle)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            ''', (row['id'],row['equipment_id'], row['name'], row['video_url'], row['description'], row['category'], row['primary_muscle']))
        elif table == "sessions":
            cursor.execute(f'''
                INSERT OR IGNORE INTO {table_map[table]} (id, user_id, exercise_id, weight, reps, notes, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            ''', (row['id'],row['user_id'], row['exercise_id'], row['weight'], row['reps'], row['notes'], row['created_at']))
        rows_inserted += 1
    
    conn.commit()
    conn.close()
    print(f"Manually seeded {rows_inserted} rows into '{table_map[table]}'.")

# --- Example Usage ---
if __name__ == "__main__":
    init_db()
    
    # Manual seeding example 
    seed_manually("users", [
        {"id":1,"username":"Miley Cyrus","email":"imhot@billy.com","password_hash":"password123", "created_at":time.time()},
        {"id":2,"username":"Hilary Duff","email":"duff@beer.com","password_hash":"123password", "created_at":time.time()},
    ])

    seed_manually("equipment", [
        {"id":1,"name":"Dumbbell Rack","qr_code": "qr987654321", "description":"You're not dumb", "location":"Second Floor"},
        {"id":2,"name":"Ab Lounge","qr_code": "123456789qr", "description":"Shred your Abs here", "location":"First Floor"},
    ])

    seed_manually("exercises", [
        {"id":1,"equipment_id":1,"name":"Bicep Curl","video_url":"youtube.com/1234","description":"target your guns","category":"pull","primary_muscle":"arms"},
        {"id":2,"equipment_id":1,"name":"Russian Twists","video_url":"youtube.com/4321","description":"shred your core","category":"legs_core","primary_muscle":"core"},
    ])
    
    seed_manually("sessions", [
        {"id":1,"user_id":1,"exercise_id":1,"weight":"69","reps":12,"notes":"settings were 1 for the leg adjuster and 7 for the seat rpe-5","created_at":time.time()},
        {"id":2,"user_id":2,"exercise_id":2,"weight":"420","reps":1,"notes":"settings were 1 for the leg adjuster and 7 for the seat rpe-5","created_at":time.time()}
    ])
    
    # Or seed from CSV
    # seed_from_csv("machines")
    # seed_from_csv("exercises")
    # seed_from_csv("areas")
