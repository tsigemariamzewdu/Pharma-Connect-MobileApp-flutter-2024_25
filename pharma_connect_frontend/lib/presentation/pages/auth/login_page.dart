import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/application/notifiers/auth_notifier.dart';
import 'package:pharma_connect_flutter/domain/entities/auth/user.dart';
import 'package:pharma_connect_flutter/presentation/widgets/loading_indicator.dart';
import 'package:pharma_connect_flutter/presentation/widgets/error_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pharma_connect_flutter/presentation/pages/admin/admin_home_page.dart';
import 'package:pharma_connect_flutter/infrastructure/repositories/pharmacy_repository.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/pharmacy_api.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/api_client.dart';
import 'package:pharma_connect_flutter/presentation/pages/user/user_home_page.dart';
import 'package:pharma_connect_flutter/presentation/pages/owner/owner_home_page.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/local/session_manager.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  void _handleAuth(BuildContext context, User user) {
    if (user.role.toLowerCase() == 'admin') {
      Navigator.pushReplacementNamed(context, '/admin');
    } else if (user.role.toLowerCase() == 'owner') {
      Navigator.pushReplacementNamed(context, '/owner');
    } else {
      Navigator.pushReplacementNamed(context, '/user');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final notifier = ref.read(authProvider.notifier);
    // Get email from route arguments if present
    String? initialEmail;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['email'] is String) {
      initialEmail = args['email'] as String;
    }
    ref.listen<AsyncValue<User?>>(authProvider, (prev, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            _handleAuth(context, user);
          }
        },
        error: (err, _) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text(err.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      );
    });
    return Scaffold(
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (_) => LoginForm(notifier: notifier, initialEmail: initialEmail),
        error: (err, _) => LoginForm(
            notifier: notifier,
            error: err.toString(),
            initialEmail: initialEmail),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final AuthNotifier notifier;
  final String? error;
  final String? initialEmail;
  const LoginForm(
      {Key? key, required this.notifier, this.error, this.initialEmail})
      : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail != null) {
      _emailController.text = widget.initialEmail!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.notifier.login(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (widget.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(widget.error!,
                      style: const TextStyle(color: Colors.red)),
                ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  if (!value!.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }
                  if (value!.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onSubmit,
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
