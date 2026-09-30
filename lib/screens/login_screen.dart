import 'package:flutter/material.dart';

import '../bmi.dart';
import '../data.dart';
import '../widgets.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final error = validateLogin(_email.text, _password.text);
    setState(() => _error = error);
    if (error != null) return;

    setState(() => _loading = true);
    try {
      await db.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _password.text,
      );
      // Переход на главный экран сделает AuthGate.
    } catch (e) {
      if (mounted) setState(() => _error = authErrorMessage(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CenteredScroll(children: [
        const PageTitle('Вход в приложение'),
        AppCard(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LabeledField(
                label: 'Email',
                hint: 'example@gmail.com',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              LabeledField(
                label: 'Пароль',
                hint: 'Введите пароль',
                controller: _password,
                obscure: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              GreenLink(
                'Зарегистрироваться',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        PrimaryButton('ВОЙТИ', loading: _loading, onPressed: _submit),
        ErrorText(_error),
      ]),
    );
  }
}
