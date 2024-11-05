abstract class UserEvent {}

class CreateUser extends UserEvent {
  final String email;
  final String password;

  CreateUser({required this.email, required this.password});
}

class SignInUser extends UserEvent {
  final String email;
  final String password;

  SignInUser({required this.email, required this.password});
}

class SignOutUser extends UserEvent {}

class CheckTokenExpiry extends UserEvent {}
