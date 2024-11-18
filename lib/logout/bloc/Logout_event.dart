import 'package:equatable/equatable.dart';

abstract class LogoutEvent extends Equatable {
  const LogoutEvent();

  @override
  List<Object?> get props => [];
}

class LogoutRequested extends LogoutEvent {
  final String userId;

  const LogoutRequested({
    required this.userId,
  });

  @override
  List<Object?> get props => [
        userId,
      ];
}
