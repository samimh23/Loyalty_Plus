import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  List<String> _defaultScopes = ['email', 'profile'];

  GoogleSignInService({
    String? clientId,
    String? serverClientId,
    List<String>? scopes,
  }) {
    _defaultScopes = scopes ?? ['email', 'profile'];
    _googleSignIn.initialize(
      clientId: clientId,
      serverClientId: serverClientId,
    );
  }

  /// Attempts to sign in and prints the result including profile picture.
  Future<void> signInAndPrintResult({List<String>? scopes}) async {
    try {
      final user = await _googleSignIn.authenticate(
        scopeHint: scopes ?? _defaultScopes,
      );
      if (user != null) {
        print('Sign in successful!');
        print('Name: ${user.displayName}');
        print('Email: ${user.email}');
        print('ID: ${user.id}');
        print('Profile picture: ${user.photoUrl}');
      } else {
        print('Sign in cancelled by user.');
      }
    } catch (e) {
      print('Sign in failed: $e');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    print('Signed out.');
  }
}