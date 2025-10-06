import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/errors/exceptions.dart';
import '../datasources/google_sign_in_service.dart';

class AuthRemoteDataSource {
  final GoogleSignInService googleSignInService;

  AuthRemoteDataSource(this.googleSignInService);

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      return await googleSignInService.signIn();
    } on ServerException catch (e, stack) {
      // Optionally add more context or rethrow
      throw ServerException('AuthRemoteDataSource: ${e.message}', stack);
    } catch (e, stack) {
      throw ServerException('Unknown error in AuthRemoteDataSource', stack);
    }
  }

  Future<void> signOut() async {
    try {
      await googleSignInService.signOut();
    } on ServerException catch (e, stack) {
      throw ServerException('AuthRemoteDataSource: ${e.message}', stack);
    } catch (e, stack) {
      throw ServerException('Unknown error in AuthRemoteDataSource', stack);
    }
  }
}