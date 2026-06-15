import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

/// ============================================================
///  DataStore — now backed by a real SQLite database (sqflite)
///  with SHA-256 password hashing. Same method names as before,
///  but every method is async (returns a Future) because SQLite
///  is asynchronous.
///
///  Tables:  users(... role, online)   rides(...)   notifications(...)
/// ============================================================
class DataStore {
  static Database? _db;

  static Future<Database> get _database async {
    _db ??= await _open();
    return _db!;
  }

  static Future<Database> _open() async {
    final path = p.join(await getDatabasesPath(), 'ridenow.db');
    return openDatabase(
      path,
      version: 2, // bump this number any time the tables change
      onCreate: _create,
      onUpgrade: (db, oldV, newV) async {
        // If the schema changed, drop the old tables and rebuild fresh.
        await db.execute('DROP TABLE IF EXISTS users');
        await db.execute('DROP TABLE IF EXISTS rides');
        await db.execute('DROP TABLE IF EXISTS notifications');
        await _create(db, newV);
      },
    );
  }

  static Future<void> _create(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        phone TEXT,
        password TEXT,
        role TEXT,
        vehicle TEXT,
        online INTEGER DEFAULT 1
      )
    ''');
    await db.execute('''
      CREATE TABLE rides(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        pickup TEXT,
        dropoff TEXT,
        vehicle TEXT,
        fare REAL,
        status TEXT,
        createdAt TEXT,
        driverId INTEGER,
        driverName TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE notifications(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        driverId INTEGER,
        rideId INTEGER,
        text TEXT,
        time TEXT,
        read INTEGER DEFAULT 0
      )
    ''');
    // Seed accounts + demo data (passwords hashed).
    await db.insert('users', {
      'name': 'Admin',
      'email': 'admin@ridenow.com',
      'phone': '0000000000',
      'password': _hash('admin123'),
      'role': 'admin',
    });
    await db.insert('users', {
      'name': 'Ayesha Khan',
      'email': 'ayesha@gmail.com',
      'phone': '03001234567',
      'password': _hash('123456'),
      'role': 'user',
    });
    await db.insert('users', {
      'name': 'Imran Driver',
      'email': 'driver@ridenow.com',
      'phone': '03111222333',
      'password': _hash('driver123'),
      'role': 'driver',
      'vehicle': 'Suzuki Cultus — LEB 4521',
      'online': 1,
    });
    await db.insert('rides', {
      'userId': 2,
      'pickup': 'Saddar, Rawalpindi',
      'dropoff': 'F-7 Markaz, Islamabad',
      'vehicle': 'RideNow Go',
      'fare': 540.0,
      'status': 'Pending',
      'createdAt': '2026-06-12 09:05',
      'driverId': null,
      'driverName': null,
    });
  }

  // ---------- PASSWORD HASHING ----------
  static String _hash(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  // ---------- kept for compatibility (seeding is automatic) ----------
  static void seed() {}

  // ---------- AUTH ----------
  static Future<String?> registerUser(Map<String, dynamic> user) async {
    final db = await _database;
    final exists =
        await db.query('users', where: 'email = ?', whereArgs: [user['email']]);
    if (exists.isNotEmpty) return 'Email already registered';
    await db.insert('users', {
      'name': user['name'],
      'email': user['email'],
      'phone': user['phone'],
      'password': _hash(user['password']),
      'role': 'user',
    });
    return null; // success
  }

  static Future<Map<String, dynamic>?> login(
      String email, String pass) async {
    final db = await _database;
    final rows = await db.query('users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, _hash(pass)]);
    return rows.isNotEmpty ? Map<String, dynamic>.from(rows.first) : null;
  }

  // ---------- RIDERS ----------
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await _database;
    final _r = await db.query('users', where: "role = 'user'", orderBy: 'id DESC');
    return _r.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<void> updateUser(int id, Map<String, dynamic> data) async {
    final db = await _database;
    await db.update('users', data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteUser(int id) async {
    final db = await _database;
    await db.delete('rides', where: 'userId = ?', whereArgs: [id]);
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- DRIVERS ----------
  static Future<String?> addDriver(Map<String, dynamic> driver) async {
    final db = await _database;
    final exists = await db
        .query('users', where: 'email = ?', whereArgs: [driver['email']]);
    if (exists.isNotEmpty) return 'Email already registered';
    await db.insert('users', {
      'name': driver['name'],
      'email': driver['email'],
      'phone': driver['phone'],
      'vehicle': driver['vehicle'],
      'password': _hash(driver['password']),
      'role': 'driver',
      'online': 1,
    });
    return null;
  }

  static Future<List<Map<String, dynamic>>> getAllDrivers() async {
    final db = await _database;
    final _r = await db.query('users', where: "role = 'driver'", orderBy: 'id DESC');
    return _r.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<void> deleteDriver(int id) async {
    final db = await _database;
    // Return this driver's rides to the pool.
    await db.update('rides', {'driverId': null, 'driverName': null},
        where: 'driverId = ?', whereArgs: [id]);
    await db.update('rides', {'status': 'Pending'},
        where: 'driverId IS NULL AND status = ?', whereArgs: ['Accepted']);
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> setDriverOnline(int id, bool online) async {
    final db = await _database;
    await db.update('users', {'online': online ? 1 : 0},
        where: 'id = ?', whereArgs: [id]);
  }

  // ---------- RIDES ----------
  static Future<void> bookRide(Map<String, dynamic> ride) async {
    final db = await _database;
    final id = await db.insert('rides', {
      'userId': ride['userId'],
      'pickup': ride['pickup'],
      'dropoff': ride['dropoff'],
      'vehicle': ride['vehicle'],
      'fare': ride['fare'],
      'status': 'Pending',
      'createdAt': ride['createdAt'],
      'driverId': null,
      'driverName': null,
    });
    // Notify every driver about the new request.
    final drivers =
        await db.query('users', where: "role = 'driver'");
    for (final d in drivers) {
      await db.insert('notifications', {
        'driverId': d['id'],
        'rideId': id,
        'text': 'New ride: ${ride['pickup']} → ${ride['dropoff']}',
        'time': DateTime.now().toString().substring(11, 16),
        'read': 0,
      });
    }
  }

  static Future<List<Map<String, dynamic>>> userRides(int userId) async {
    final db = await _database;
    final _r = await db.query('rides',
        where: 'userId = ?', whereArgs: [userId], orderBy: 'id DESC');
    return _r.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// All rides, each joined with the rider's name (as userName).
  static Future<List<Map<String, dynamic>>> allRides() async {
    final db = await _database;
    final r = await db.rawQuery('''
      SELECT rides.*, users.name AS userName
      FROM rides LEFT JOIN users ON rides.userId = users.id
      ORDER BY rides.id DESC
    ''');
    return r.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<void> updateRideStatus(int id, String status) async {
    final db = await _database;
    await db.update('rides', {'status': status},
        where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteRide(int id) async {
    final db = await _database;
    await db.delete('rides', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- DRIVER RIDE FLOW ----------
  static Future<List<Map<String, dynamic>>> availableRequests() async {
    final db = await _database;
    final r = await db.rawQuery('''
      SELECT rides.*, users.name AS userName
      FROM rides LEFT JOIN users ON rides.userId = users.id
      WHERE rides.status = 'Pending' AND rides.driverId IS NULL
      ORDER BY rides.id DESC
    ''');
    return r.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<List<Map<String, dynamic>>> driverRides(int driverId) async {
    final db = await _database;
    final r = await db.rawQuery('''
      SELECT rides.*, users.name AS userName
      FROM rides LEFT JOIN users ON rides.userId = users.id
      WHERE rides.driverId = ?
      ORDER BY rides.id DESC
    ''', [driverId]);
    return r.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<void> acceptRide(
      int rideId, int driverId, String driverName) async {
    final db = await _database;
    await db.update(
        'rides',
        {'status': 'Accepted', 'driverId': driverId, 'driverName': driverName},
        where: 'id = ?',
        whereArgs: [rideId]);
  }

  // ---------- NOTIFICATIONS ----------
  static Future<List<Map<String, dynamic>>> driverNotifications(
      int driverId) async {
    final db = await _database;
    final _r = await db.query('notifications',
        where: 'driverId = ?', whereArgs: [driverId], orderBy: 'id DESC');
    return _r.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<int> unreadCount(int driverId) async {
    final db = await _database;
    final rows = await db.query('notifications',
        where: 'driverId = ? AND read = 0', whereArgs: [driverId]);
    return rows.length;
  }

  static Future<void> markNotificationsRead(int driverId) async {
    final db = await _database;
    await db.update('notifications', {'read': 1},
        where: 'driverId = ?', whereArgs: [driverId]);
  }

  // ---------- STATS ----------
  static Future<Map<String, dynamic>> driverStats(int driverId) async {
    final db = await _database;
    final mine =
        await db.query('rides', where: 'driverId = ?', whereArgs: [driverId]);
    final completed =
        mine.where((r) => r['status'] == 'Completed').toList();
    final earnings = completed.fold<double>(
        0, (sum, r) => sum + (r['fare'] as num).toDouble());
    return {
      'trips': mine.length,
      'completed': completed.length,
      'earnings': earnings,
    };
  }

  static Future<Map<String, int>> adminStats() async {
    final db = await _database;
    int n(List rows) => rows.length;
    final users = await db.query('users', where: "role = 'user'");
    final drivers = await db.query('users', where: "role = 'driver'");
    final rides = await db.query('rides');
    final pending =
        await db.query('rides', where: "status = 'Pending'");
    final done = await db.query('rides', where: "status = 'Completed'");
    return {
      'users': n(users),
      'drivers': n(drivers),
      'rides': n(rides),
      'pending': n(pending),
      'done': n(done),
    };
  }
}
