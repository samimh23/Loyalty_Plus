import 'package:equatable/equatable.dart';

/// Base class for all authentication events.
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to trigger Google sign-in flow.
class GoogleSignInRequested extends AuthEvent {}

/// Event to trigger Facebook sign-in flow.
class FacebookSignInRequested extends AuthEvent {}

/// Event to trigger Apple sign-in flow.
class AppleSignInRequested extends AuthEvent {}

/// Event to trigger sign-out flow.
class SignOutRequested extends AuthEvent {}

/// Event to trigger email/password sign-in.
class EmailPasswordSignInRequested extends AuthEvent {
  final String email;
  final String password;

  EmailPasswordSignInRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}