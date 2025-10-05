import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../Custom_Text_Feald.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool get isIOS => Theme.of(context).platform == TargetPlatform.iOS;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Navigate to home or show success
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return isIOS
            ? CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(middle: Text('Login')),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: padding,
              child: _buildColumn(context),
            ),
          ),
        )
            : Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(title: const Text('Login')),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: padding,
              child: _buildColumn(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColumn(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        decoration: TextDecoration.none,
        fontFamily: '.SF Pro Text', // iOS default font
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 50),
          const Text(
            "Welcome To Loyal Brew",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomTextField(controller: emailController, hint: "Email"),
          const SizedBox(height: 12),
          CustomTextField(
            controller: passwordController,
            hint: "Password",
            obscureText: true,
          ),
          const SizedBox(height: 24),
          isIOS
              ? CupertinoButton.filled(
            onPressed: () => _login(context),
            child: const Text("Log In"),
          )
              : ElevatedButton(
            onPressed: () => _login(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text("Log In"),
          ),
          const SizedBox(height: 50),
          _ConnectionOption(context),
        ],
      ),
    );
  }

  Widget _ConnectionOption(BuildContext context) {
    return Column(
      children: [
        // Apple Sign-In
        SignInWithAppleButton(
          onPressed: () =>
              context.read<AuthBloc>().add(AppleSignInRequested()),
        ),
        const SizedBox(height: 12),

        // Google Sign-In
        isIOS
            ? CupertinoButton.filled(
          onPressed: () =>
              context.read<AuthBloc>().add(GoogleSignInRequested()),
          child: const Text("Continue with Google"),
        )
            : ElevatedButton.icon(
          onPressed: () =>
              context.read<AuthBloc>().add(GoogleSignInRequested()),
          icon: const Icon(Icons.g_mobiledata, size: 20),
          label: const Text("Continue with Google"),
        ),
        const SizedBox(height: 12),

        // Facebook Sign-In
        isIOS
            ? CupertinoButton.filled(
          onPressed: () =>
              context.read<AuthBloc>().add(FacebookSignInRequested()),
          child: const Text("Continue with Facebook"),
        )
            : ElevatedButton.icon(
          onPressed: () =>
              context.read<AuthBloc>().add(FacebookSignInRequested()),
          icon: const Icon(Icons.facebook, size: 20),
          label: const Text("Continue with Facebook"),
        ),
      ],
    );
  }

  void _login(BuildContext context) {
    final email = emailController.text;
    final password = passwordController.text;
    // You may want to validate or add a Bloc event for email/password login here
    debugPrint("Login pressed: $email / $password");
  }
}