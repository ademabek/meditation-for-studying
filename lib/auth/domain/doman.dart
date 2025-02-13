typedef User = Map<String, dynamic>;
typedef MeditationSession = Map<String, bool>;

// Repository Interface
abstract class AuthRepository {
  Future<User?> loginUser(String email, String password);
  Future<void> registerUser(User user);
}

// Use Cases
class LoginUser {
  final AuthRepository repository;
  LoginUser(this.repository);

  Future<User?> call(String email, String password) {
    return repository.loginUser(email, password);
  }
}
