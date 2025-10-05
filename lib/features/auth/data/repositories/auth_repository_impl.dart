import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/google_sign_in_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignInService googleSignInService;
  AuthRepositoryImpl(this.googleSignInService);

  @override
  Future<UserEntity?> signInWithGoogle() async {
    final user = await googleSignInService.signIn();
    if (user == null) return null;
    return UserEntity(
      id: user.id,
      email: user.email,
      name: user.displayName,
      photoUrl: user.photoUrl,
    );
  }

  @override
  Future<void> signOut() async {
    await googleSignInService.signOut();
  }
}