import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ============================================================
///  DataStore — backed by SharedPreferences.
///  We keep three lists (users, rides, notifications) and save
///  each one as a JSON string under its own key. Works on every
///  platform (Android, iOS, Web, Desktop) and persists across
///  restarts. Passwords are SHA-256 hashed.
///
///  Same method names as before; every method is async.
/// ============================================================
class DataStore {
  static SharedPreferences? _prefs;

  // Open SharedPreferences once, and seed demo data the first time.
  static Future<SharedPreferences> get _p async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      await _ensureSeeded();
    }
    return _prefs!;
  }

  // ---------- low-level read / write ----------
  static List<Map<String, dynamic>> _read(String key) {
    final raw = _prefs!.getString(key);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<void> _save(String key, List<Map<String, dynamic>> rows) async {
    await _prefs!.setString(key, jsonEncode(rows));
  }

  // Next id = highest existing id + 1.
  static int _nextId(List<Map<String, dynamic>> rows) {
    var max = 0;
    for (final r in rows) {
      final id = (r['id'] as num).toInt();
      if (id > max) max = id;
    }
    return max + 1;
  }

  // ---------- seeding (runs once) ----------
  static Future<void> _ensureSeeded() async {
    if (_prefs!.getBool('seeded') == true) return;
    await _save('users', [
      {
        'id': 1,
        'name': 'Admin',
        'email': 'admin@ridenow.com',
        'phone': '0000000000',
        'password': _hash('admin123'),
        'role': 'admin',
      },
      {
        'id': 2,
        'name': 'Ayesha Khan',
        'email': 'ayesha@gmail.com',
        'phone': '03001234567',
        'password': _hash('123456'),
        'role': 'user',
      },
      {
        'id': 3,
        'name': 'Imran Driver',
        'email': 'driver@ridenow.com',
        'phone': '03111222333',
        'password': _hash('driver123'),
        'role': 'driver',
        'vehicle': 'Suzuki Cultus — LEB 4521',
        'online': 1,
      },
    ]);
    await _save('rides', [
      {
        'id': 1,
        'userId': 2,
        'pickup': 'Saddar, Rawalpindi',
        'dropoff': 'F-7 Markaz, Islamabad',
        'vehicle': 'RideNow Go',
        'fare': 540.0,
        'status': 'Pending',
        'createdAt': '2026-06-12 09:05',
        'driverId': null,
        'driverName': null,
      },
    ]);
    await _save('notifications', []);
    await _prefs!.setBool('seeded', true);
  }

  // ---------- PASSWORD HASHING ----------
  static String _hash(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  // Kept for compatibility (seeding is automatic).
  static void seed() {}

  // ---------- AUTH ----------
  static Future<String?> registerUser(Map<String, dynamic> user) async {
    await _p;
    final users = _read('users');
    if (users.any((u) => u['email'] == user['email'])) {
      return 'Email already registered';
    }
    users.add({
      'id': _nextId(users),
      'name': user['name'],
      'email': user['email'],
      'phone': user['phone'],
      'password': _hash(user['password']),
      'role': 'user',
    });
    await _save('users', users);
    return null; // success
  }

  static Future<Map<String, dynamic>?> login(
      String email, String pass) async {
    await _p;
    final users = _read('users');
    final hashed = _hash(pass);
    for (final u in users) {
      if (u['email'] == email && u['password'] == hashed) return u;
    }
    return null;
  }

  // ---------- RIDERS ----------
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    await _p;
    return _read('users').where((u) => u['role'] == 'user').toList().reversed.toList();
  }

  static Future<void> updateUser(int id, Map<String, dynamic> data) async {
    await _p;
    final users = _read('users');
    for (final u in users) {
      if (u['id'] == id) u.addAll(data);
    }
    await _save('users', users);
  }

  static Future<void> deleteUser(int id) async {
    await _p;
    final users = _read('users')..removeWhere((u) => u['id'] == id);
    final rides = _read('rides')..removeWhere((r) => r['userId'] == id);
    await _save('users', users);
    await _save('rides', rides);
  }

  // ---------- DRIVERS ----------
  static Future<String?> addDriver(Map<String, dynamic> driver) async {
    await _p;
    final users = _read('users');
    if (users.any((u) => u['email'] == driver['email'])) {
      return 'Email already registered';
    }
    users.add({
      'id': _nextId(users),
      'name': driver['name'],
      'email': driver['email'],
      'phone': driver['phone'],
      'vehicle': driver['vehicle'],
      'password': _hash(driver['password']),
      'role': 'driver',
      'online': 1,
    });
    await _save('users', users);
    return null;
  }

  static Future<List<Map<String, dynamic>>> getAllDrivers() async {
    await _p;
    return _read('users')
        .where((u) => u['role'] == 'driver')
        .toList()
        .reversed
        .toList();
  }

  static Future<void> deleteDriver(int id) async {
    await _p;
    final users = _read('users')..removeWhere((u) => u['id'] == id);
    final rides = _read('rides');
    for (final r in rides) {
      if (r['driverId'] == id) {
        r['driverId'] = null;
        r['driverName'] = null;
        if (r['status'] == 'Accepted') r['status'] = 'Pending';
      }
    }
    await _save('users', users);
    await _save('rides', rides);
  }

  static Future<void> setDriverOnline(int id, bool online) async {
    await _p;
    final users = _read('users');
    for (final u in users) {
      if (u['id'] == id) u['online'] = online ? 1 : 0;
    }
    await _save('users', users);
  }

  // ---------- RIDES ----------
  static Future<void> bookRide(Map<String, dynamic> ride) async {
    await _p;
    final rides = _read('rides');
    final id = _nextId(rides);
    rides.add({
      'id': id,
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
    await _save('rides', rides);
    // Notify every driver about the new request.
    final notifs = _read('notifications');
    final drivers = _read('users').where((u) => u['role'] == 'driver');
    for (final d in drivers) {
      notifs.add({
        'id': _nextId(notifs),
        'driverId': d['id'],
        'rideId': id,
        'text': 'New ride: ${ride['pickup']} → ${ride['dropoff']}',
        'time': DateTime.now().toString().substring(11, 16),
        'read': 0,
      });
    }
    await _save('notifications', notifs);
  }

  static String _nameOf(List<Map<String, dynamic>> users, dynamic userId) {
    for (final u in users) {
      if (u['id'] == userId) return u['name'];
    }
    return 'Unknown';
  }

  static Future<List<Map<String, dynamic>>> userRides(int userId) async {
    await _p;
    return _read('rides')
        .where((r) => r['userId'] == userId)
        .toList()
        .reversed
        .toList();
  }

  static Future<List<Map<String, dynamic>>> allRides() async {
    await _p;
    final users = _read('users');
    return _read('rides')
        .reversed
        .map((r) => {...r, 'userName': _nameOf(users, r['userId'])})
        .toList();
  }

  static Future<void> updateRideStatus(int id, String status) async {
    await _p;
    final rides = _read('rides');
    for (final r in rides) {
      if (r['id'] == id) r['status'] = status;
    }
    await _save('rides', rides);
  }

  static Future<void> deleteRide(int id) async {
    await _p;
    final rides = _read('rides')..removeWhere((r) => r['id'] == id);
    await _save('rides', rides);
  }

  // ---------- DRIVER RIDE FLOW ----------
  static Future<List<Map<String, dynamic>>> availableRequests() async {
    await _p;
    final users = _read('users');
    return _read('rides')
        .reversed
        .where((r) => r['status'] == 'Pending' && r['driverId'] == null)
        .map((r) => {...r, 'userName': _nameOf(users, r['userId'])})
        .toList();
  }

  static Future<List<Map<String, dynamic>>> driverRides(int driverId) async {
    await _p;
    final users = _read('users');
    return _read('rides')
        .reversed
        .where((r) => r['driverId'] == driverId)
        .map((r) => {...r, 'userName': _nameOf(users, r['userId'])})
        .toList();
  }

  static Future<void> acceptRide(
      int rideId, int driverId, String driverName) async {
    await _p;
    final rides = _read('rides');
    for (final r in rides) {
      if (r['id'] == rideId) {
        r['status'] = 'Accepted';
        r['driverId'] = driverId;
        r['driverName'] = driverName;
      }
    }
    await _save('rides', rides);
  }

  // ---------- NOTIFICATIONS ----------
  static Future<List<Map<String, dynamic>>> driverNotifications(
      int driverId) async {
    await _p;
    return _read('notifications')
        .where((n) => n['driverId'] == driverId)
        .toList()
        .reversed
        .toList();
  }

  static Future<int> unreadCount(int driverId) async {
    await _p;
    return _read('notifications')
        .where((n) => n['driverId'] == driverId && n['read'] == 0)
        .length;
  }

  static Future<void> markNotificationsRead(int driverId) async {
    await _p;
    final notifs = _read('notifications');
    for (final n in notifs) {
      if (n['driverId'] == driverId) n['read'] = 1;
    }
    await _save('notifications', notifs);
  }

  // ---------- STATS ----------
  static Future<Map<String, dynamic>> driverStats(int driverId) async {
    await _p;
    final mine =
        _read('rides').where((r) => r['driverId'] == driverId).toList();
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
    await _p;
    final users = _read('users');
    final rides = _read('rides');
    return {
      'users': users.where((u) => u['role'] == 'user').length,
      'drivers': users.where((u) => u['role'] == 'driver').length,
      'rides': rides.length,
      'pending': rides.where((r) => r['status'] == 'Pending').length,
      'done': rides.where((r) => r['status'] == 'Completed').length,
    };
  }
}
