import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/errors/exceptions.dart';

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
    } on GoogleSignInException catch (e, stack) {
      throw ServerException(
        'GoogleSignInException: code=${e.code}, description=${e.description}',
        stack,
      );
    } catch (e, stack) {
      throw ServerException('Unknown error: $e', stack);
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
    } on GoogleSignInException catch (e, stack) {
      throw ServerException(
        'GoogleSignInException: code=${e.code}, description=${e.description}',
        stack,
      );
    } catch (e, stack) {
      throw ServerException('Unknown error: $e', stack);
    }
  }
}