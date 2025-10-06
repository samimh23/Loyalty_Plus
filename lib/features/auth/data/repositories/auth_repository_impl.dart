import 'package:untitled6/core/errors/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import 'package:untitled6/core/network/network_info.dart';
import 'package:untitled6/core/services/logger.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<UserEntity?> signInWithGoogle() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signInWithGoogle();
        if (user == null) return null;
        return UserEntity(
          id: user.id,
          email: user.email,
          name: user.displayName,
          photoUrl: user.photoUrl,
        );
      } on ServerException catch (e, stack) {
        AppLogger.e('Google sign-in failed', e, stack);
        throw ServerException(e.message, stack); // propagate message
      } catch (e, stack) {
        AppLogger.e('Google sign-in failed', e, stack);
        throw ServerException('Google sign-in failed.', stack);
      }
    } else {
      AppLogger.w('No internet connection');
      throw NoConnectionException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } on ServerException catch (e, stack) {
      AppLogger.e('Sign out failed', e, stack);
      throw ServerException(e.message, stack);
    } catch (e, stack) {
      AppLogger.e('Sign out failed', e, stack);
      throw ServerException('Sign out failed.', stack);
    }
  }
}