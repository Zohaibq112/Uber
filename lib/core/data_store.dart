/// ============================================================
///  In-memory data store (pure Dart — no plugins, runs anywhere).
///  Method names mirror a real database layer. Swap this class
///  for SQLite/Firebase later without touching screen code.
///
///  Roles:  'admin'  'user' (rider)  'driver'
/// ============================================================
class DataStore {
  static final List<Map<String, dynamic>> _users = [];
  static final List<Map<String, dynamic>> _rides = [];
  static final List<Map<String, dynamic>> _notifications = [];
  static int _userId = 1;
  static int _rideId = 1;
  static int _notifId = 1;

  /// Seed default accounts + demo data (runs once).
  static void seed() {
    if (_users.isNotEmpty) return;
    _users.addAll([
      {
        'id': _userId++,
        'name': 'Admin',
        'email': 'admin@ridenow.com',
        'phone': '0000000000',
        'password': 'admin123',
        'role': 'admin',
      },
      {
        'id': _userId++,
        'name': 'Ayesha Khan',
        'email': 'ayesha@gmail.com',
        'phone': '03001234567',
        'password': '123456',
        'role': 'user',
      },
      {
        'id': _userId++,
        'name': 'Bilal Ahmed',
        'email': 'bilal@gmail.com',
        'phone': '03007654321',
        'password': '123456',
        'role': 'user',
      },
      {
        'id': _userId++,
        'name': 'Imran Driver',
        'email': 'driver@ridenow.com',
        'phone': '03111222333',
        'password': 'driver123',
        'role': 'driver',
        'vehicle': 'Suzuki Cultus — LEB 4521',
        'online': true,
      },
    ]);
    _rides.addAll([
      {
        'id': _rideId++,
        'userId': 2,
        'pickup': 'Saddar, Rawalpindi',
        'dropoff': 'F-7 Markaz, Islamabad',
        'vehicle': 'RideNow Go',
        'fare': 540.0,
        'status': 'Completed',
        'createdAt': '2026-06-10 14:20',
        'driverId': 4,
        'driverName': 'Imran Driver',
      },
      {
        'id': _rideId++,
        'userId': 3,
        'pickup': 'Wah Cantt',
        'dropoff': 'Taxila',
        'vehicle': 'RideNow Bike',
        'fare': 180.0,
        'status': 'Pending',
        'createdAt': '2026-06-12 09:05',
      },
    ]);
  }

  // ---------- AUTH ----------
  static String? registerUser(Map<String, dynamic> user) {
    if (_users.any((u) => u['email'] == user['email'])) {
      return 'Email already registered';
    }
    _users.add({'id': _userId++, 'role': 'user', ...user});
    return null;
  }

  static Map<String, dynamic>? login(String email, String pass) {
    for (final u in _users) {
      if (u['email'] == email && u['password'] == pass) return u;
    }
    return null;
  }

  // ---------- RIDERS (users) ----------
  static List<Map<String, dynamic>> getAllUsers() =>
      _users.where((u) => u['role'] == 'user').toList().reversed.toList();

  static void updateUser(int id, Map<String, dynamic> data) {
    _users.firstWhere((e) => e['id'] == id).addAll(data);
  }

  static void deleteUser(int id) {
    _users.removeWhere((u) => u['id'] == id);
    _rides.removeWhere((r) => r['userId'] == id);
  }

  // ---------- DRIVERS ----------
  static String? addDriver(Map<String, dynamic> driver) {
    if (_users.any((u) => u['email'] == driver['email'])) {
      return 'Email already registered';
    }
    _users.add({
      'id': _userId++,
      'role': 'driver',
      'online': true,
      ...driver,
    });
    return null;
  }

  static List<Map<String, dynamic>> getAllDrivers() =>
      _users.where((u) => u['role'] == 'driver').toList().reversed.toList();

  static void deleteDriver(int id) {
    _users.removeWhere((u) => u['id'] == id);
    // Unassign any rides this driver had taken.
    for (final r in _rides) {
      if (r['driverId'] == id) {
        r['driverId'] = null;
        r['driverName'] = null;
        if (r['status'] == 'Accepted') r['status'] = 'Pending';
      }
    }
  }

  static void setDriverOnline(int id, bool online) {
    _users.firstWhere((u) => u['id'] == id)['online'] = online;
  }

  // ---------- RIDES ----------
  static void bookRide(Map<String, dynamic> ride) {
    final newRide = {'id': _rideId++, 'driverId': null, ...ride};
    _rides.add(newRide);
    // Notify every driver about the new request.
    _notifyAllDrivers(
      'New ride request: ${ride['pickup']} → ${ride['dropoff']}',
      newRide['id'] as int,
    );
  }

  static List<Map<String, dynamic>> userRides(int userId) =>
      _rides.where((r) => r['userId'] == userId).toList().reversed.toList();

  static List<Map<String, dynamic>> allRides() {
    return _rides.reversed.map((r) {
      final user = _users.firstWhere((u) => u['id'] == r['userId'],
          orElse: () => {'name': 'Unknown'});
      return {...r, 'userName': user['name']};
    }).toList();
  }

  static void updateRideStatus(int id, String status) {
    _rides.firstWhere((r) => r['id'] == id)['status'] = status;
  }

  static void deleteRide(int id) => _rides.removeWhere((r) => r['id'] == id);

  // ---------- DRIVER RIDE FLOW ----------
  /// Pending rides not yet taken by any driver (the "requests" feed).
  static List<Map<String, dynamic>> availableRequests() {
    return _rides.reversed
        .where((r) => r['status'] == 'Pending' && r['driverId'] == null)
        .map((r) {
      final user = _users.firstWhere((u) => u['id'] == r['userId'],
          orElse: () => {'name': 'Unknown'});
      return {...r, 'userName': user['name']};
    }).toList();
  }

  /// Rides assigned to a specific driver.
  static List<Map<String, dynamic>> driverRides(int driverId) {
    return _rides.reversed.where((r) => r['driverId'] == driverId).map((r) {
      final user = _users.firstWhere((u) => u['id'] == r['userId'],
          orElse: () => {'name': 'Unknown'});
      return {...r, 'userName': user['name']};
    }).toList();
  }

  static void acceptRide(int rideId, int driverId, String driverName) {
    final r = _rides.firstWhere((e) => e['id'] == rideId);
    r['driverId'] = driverId;
    r['driverName'] = driverName;
    r['status'] = 'Accepted';
  }

  // ---------- NOTIFICATIONS ----------
  static void _notifyAllDrivers(String text, int rideId) {
    for (final d in _users.where((u) => u['role'] == 'driver')) {
      _notifications.add({
        'id': _notifId++,
        'driverId': d['id'],
        'rideId': rideId,
        'text': text,
        'time': DateTime.now().toString().substring(11, 16),
        'read': false,
      });
    }
  }

  static List<Map<String, dynamic>> driverNotifications(int driverId) =>
      _notifications
          .where((n) => n['driverId'] == driverId)
          .toList()
          .reversed
          .toList();

  static int unreadCount(int driverId) => _notifications
      .where((n) => n['driverId'] == driverId && n['read'] == false)
      .length;

  static void markNotificationsRead(int driverId) {
    for (final n in _notifications.where((n) => n['driverId'] == driverId)) {
      n['read'] = true;
    }
  }

  // ---------- STATS ----------
  static Map<String, dynamic> driverStats(int driverId) {
    final mine = _rides.where((r) => r['driverId'] == driverId);
    final completed = mine.where((r) => r['status'] == 'Completed');
    final earnings = completed.fold<double>(
        0, (sum, r) => sum + (r['fare'] as num).toDouble());
    return {
      'trips': mine.length,
      'completed': completed.length,
      'earnings': earnings,
    };
  }

  static Map<String, int> adminStats() {
    return {
      'users': _users.where((u) => u['role'] == 'user').length,
      'drivers': _users.where((u) => u['role'] == 'driver').length,
      'rides': _rides.length,
      'pending': _rides.where((r) => r['status'] == 'Pending').length,
      'done': _rides.where((r) => r['status'] == 'Completed').length,
    };
  }
}
