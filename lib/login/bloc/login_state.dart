
import '../model/models.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserCreated extends UserState {
 final User user; // Pass the created user to the state

  UserCreated(this.user);
}

class UserAuthenticated extends UserState {
  final String token;

  UserAuthenticated(this.token);
}

class UserSignOut extends UserState {}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}
class UserAlreadyExists extends UserState{
  final String message;
  UserAlreadyExists(this.message);
}

class TokenExpired extends UserState {}
