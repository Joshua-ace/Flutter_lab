import 'package:flutter/foundation.dart';
import '../models/member.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Member _currentMember = Member(
    id: 'mem_1',
    name: 'Srekar Fan #0042',
    phone: '+91 98765 43210',
    city: 'Hyderabad',
    membershipId: 'SKR-2026-0842',
    joinedDate: DateTime(2025, 4, 15),
    role: 'VIP Fan',
    tier: 'Platinum VIP',
    bloodGroup: 'O+',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
  );

  bool _isAdminLoggedIn = false;

  Member get currentMember => _currentMember;
  bool get isAdminLoggedIn => _isAdminLoggedIn;

  void updateMember(Member updated) {
    _currentMember = updated;
    notifyListeners();
  }

  bool loginAdmin(String username, String password) {
    // Hidden admin credentials
    if (username.trim() == 'admin' && password.trim() == 'admin123') {
      _isAdminLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logoutAdmin() {
    _isAdminLoggedIn = false;
    notifyListeners();
  }
}
