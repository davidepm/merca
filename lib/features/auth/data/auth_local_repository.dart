import '../models/user.dart';

class AuthLocalRepository {
  Future<User?> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (email.trim().toLowerCase() == 'mercaderista@demo.com' &&
        password == '123456') {
      return const User(
        id: 'user-001',
        name: 'Carlos Mendoza',
        email: 'mercaderista@demo.com',
        role: 'Mercaderista',
        zone: 'Norte - Guayaquil',
        code: 'MER-EC-024',
      );
    }
    return null;
  }
}
