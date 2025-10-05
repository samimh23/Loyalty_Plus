import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/google_sign_in_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../network/network_info.dart';
import '../network/network_info_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => AuthBloc(signInWithGoogle: sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(Connectivity()));

  // Usecases
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Data sources / services
  sl.registerLazySingleton(() => GoogleSignInService());

  // If you have other services, APIs, etc, register them too
}