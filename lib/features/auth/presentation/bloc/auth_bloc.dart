import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/use_cases/sign_in_with_google_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle signInWithGoogle;

  AuthBloc({
    required this.signInWithGoogle,
  }) : super(AuthInitial()) {
    on<GoogleSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signInWithGoogle();
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthError(message: 'Sign-in failed. Please try again.'));
        }
      } on NoConnectionException {
        emit(AuthError(message: 'No internet connection.'));
      } on ServerException catch (e) {
        emit(AuthError(message: e.message ?? 'Server error.'));
      } catch (e) {
        emit(AuthError(message: 'An unexpected error occurred.'));
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(message: 'Sign-out failed. Please try again.'));
      }
    });
  }
}