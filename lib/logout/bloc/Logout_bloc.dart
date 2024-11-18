import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing/logout/repository/Logout_repository.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutRepository logoutRepository;

  LogoutBloc({required this.logoutRepository}) : super(LogoutInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LogoutState> emit,
  ) async {
    emit(LogoutLoading());

    try {
      await logoutRepository.deleteUser( event.userId, );
      emit(LogoutSuccess());
    } catch (error) {
      emit(LogoutFailure(error: error.toString()));
    }
  }
}
