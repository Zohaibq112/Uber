/// ============================================================
///  In-memory data store (pure Dart — no plugins, runs anywhere).
///  Method names mirror a real database layer so the app reads
///  like it talks to a DB. Swap this class for SQLite/Firebase
///  later without touching any screen code.
/// ============================================================
class DataStore {
  // "Tables"
  static final List<Map<String, dynamic>> _users = [];
  static final List<Map<String, dynamic>> _rides = [];
  static int _userId = 1;
  static int _rideId = 1;

  /// Seed default admin + a couple of demo users/rides.
  static void seed() {
    if (_users.isNotEmpty) return; // only once
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

  // ---------- USERS ----------
  static String? registerUser(Map<String, dynamic> user) {
    final exists =
        _users.any((u) => u['email'] == user['email']); // unique email
    if (exists) return 'Email already registered';
    _users.add({'id': _userId++, 'role': 'user', ...user});
    return null; // success
  }

  static Map<String, dynamic>? login(String email, String pass) {
    for (final u in _users) {
      if (u['email'] == email && u['password'] == pass) return u;
    }
    return null;
  }

  static List<Map<String, dynamic>> getAllUsers() =>
      _users.where((u) => u['role'] == 'user').toList().reversed.toList();

  static void updateUser(int id, Map<String, dynamic> data) {
    final u = _users.firstWhere((e) => e['id'] == id);
    u.addAll(data);
  }

  static void deleteUser(int id) {
    _users.removeWhere((u) => u['id'] == id);
    _rides.removeWhere((r) => r['userId'] == id); // cascade
  }

  // ---------- RIDES ----------
  static void bookRide(Map<String, dynamic> ride) {
    _rides.add({'id': _rideId++, ...ride});
  }

  static List<Map<String, dynamic>> userRides(int userId) => _rides
      .where((r) => r['userId'] == userId)
      .toList()
      .reversed
      .toList();

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

  // ---------- STATS ----------
  static Map<String, int> adminStats() {
    return {
      'users': _users.where((u) => u['role'] == 'user').length,
      'rides': _rides.length,
      'pending': _rides.where((r) => r['status'] == 'Pending').length,
      'done': _rides.where((r) => r['status'] == 'Completed').length,
    };
  }
}
