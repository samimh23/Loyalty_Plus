import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/sign_in_with_google_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle signInWithGoogle;

  AuthBloc({required this.signInWithGoogle}) : super(AuthInitial()) {
    on<GoogleSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signInWithGoogle();
        if (user != null) {
          emit(AuthAuthenticated(user: user)); // <-- named argument
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthError(message: e.toString())); // <-- named argument
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      // Add sign out usecase logic here
      emit(AuthUnauthenticated());
    });
  }
}