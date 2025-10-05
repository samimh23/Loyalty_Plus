import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled6/firebase_options.dart';

import 'features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import 'features/auth/presentation/screens/LoginScrren.dart';

// Import your Bloc, repository, usecase, and service
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/data/datasources/google_sign_in_service.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up dependencies
  final googleSignInService = GoogleSignInService();
  final authRepository = AuthRepositoryImpl(googleSignInService);
  final signInWithGoogle = SignInWithGoogle(authRepository);

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(signInWithGoogle: signInWithGoogle),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}