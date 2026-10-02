import 'package:flutter/foundation.dart';

import '../data/auth_local_repository.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository);

  final AuthLocalRepository _repository;
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    _user = await _repository.login(email, password);
    _isLoading = false;
    if (_user == null) _error = 'Correo o contraseña incorrectos.';
    notifyListeners();
    return _user != null;
  }

  void logout() {
    _user = null;
    _error = null;
    notifyListeners();
  }
}
