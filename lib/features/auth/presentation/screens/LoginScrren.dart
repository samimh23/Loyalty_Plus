import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../widgets/Custom_Text_Feald.dart';
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

  void _showError(BuildContext context, String message) {
    if (isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24);

    // Ensure SnackBar always works by having Scaffold above BlocConsumer!
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: isIOS ? null : AppBar(title: const Text('Login')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is AuthError) {
              _showError(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(
                child: isIOS
                    ? const CupertinoActivityIndicator()
                    : const CircularProgressIndicator(),
              );
            }
            return isIOS
                ? CupertinoPageScaffold(
              navigationBar: const CupertinoNavigationBar(middle: Text('Login')),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: padding,
                  child: _buildColumn(context, state),
                ),
              ),
            )
                : SafeArea(
              child: SingleChildScrollView(
                padding: padding,
                child: _buildColumn(context, state),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildColumn(BuildContext context, AuthState state) {
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
          CustomTextField(
            controller: emailController,
            hint: "Email",
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: passwordController,
            hint: "Password",
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),
          isIOS
              ? CupertinoButton.filled(
            onPressed: state is AuthLoading ? null : () => _login(context),
            child: const Text("Log In"),
          )
              : ElevatedButton(
            onPressed: state is AuthLoading ? null : () => _login(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text("Log In"),
          ),
          const SizedBox(height: 50),
          _ConnectionOption(context, state),
        ],
      ),
    );
  }

  Widget _ConnectionOption(BuildContext context, AuthState state) {
    return Column(
      children: [
        // Apple Sign-In
        SignInWithAppleButton(
          onPressed: state is AuthLoading
              ? null
              : () => context.read<AuthBloc>().add(AppleSignInRequested()),
        ),
        const SizedBox(height: 12),

        // Google Sign-In
        isIOS
            ? CupertinoButton.filled(
          onPressed: state is AuthLoading
              ? null
              : () => context.read<AuthBloc>().add(GoogleSignInRequested()),
          child: const Text("Continue with Google"),
        )
            : ElevatedButton.icon(
          onPressed: state is AuthLoading
              ? null
              : () => context.read<AuthBloc>().add(GoogleSignInRequested()),
          icon: const Icon(Icons.g_mobiledata, size: 20),
          label: const Text("Continue with Google"),
        ),
        const SizedBox(height: 12),

        // Facebook Sign-In
        isIOS
            ? CupertinoButton.filled(
          onPressed: state is AuthLoading
              ? null
              : () => context.read<AuthBloc>().add(FacebookSignInRequested()),
          child: const Text("Continue with Facebook"),
        )
            : ElevatedButton.icon(
          onPressed: state is AuthLoading
              ? null
              : () => context.read<AuthBloc>().add(FacebookSignInRequested()),
          icon: const Icon(Icons.facebook, size: 20),
          label: const Text("Continue with Facebook"),
        ),
      ],
    );
  }

  void _login(BuildContext context) {
    final email = emailController.text.trim();
    final password = passwordController.text;
    // Input validation
    if (email.isEmpty || password.isEmpty) {
      _showError(context, "Please enter both email and password.");
      return;
    }
    // You may want to fire an event for email/password login here
    // context.read<AuthBloc>().add(EmailPasswordSignInRequested(email, password));
  }
}