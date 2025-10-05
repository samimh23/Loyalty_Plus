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

  Future<GoogleSignInAccount?> signIn({List<String>? scopes}) async {
    try {
      final user = await _googleSignIn.authenticate(
        scopeHint: scopes ?? _defaultScopes,
      );
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
  }
}