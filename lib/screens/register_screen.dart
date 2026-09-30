import 'package:flutter/material.dart';

import '../bmi.dart';
import '../data.dart';
import '../widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final error = validateRegistration(
        _firstName.text, _lastName.text, _email.text, _password.text);
    setState(() => _error = error);
    if (error != null) return;

    setState(() => _loading = true);
    try {
      final res = await db.auth.signUp(
        email: _email.text.trim(),
        password: _password.text,
        data: {
          'first_name': _firstName.text.trim(),
          'last_name': _lastName.text.trim(),
        },
      );
      if (!mounted) return;

      if (res.session == null) {
        // В Supabase включено подтверждение почты.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Аккаунт создан. Подтвердите email и войдите.'),
        ));
      }
      // Если сессия есть, AuthGate уже показал главный экран под этим.
      Navigator.of(context).pop();
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
        const PageTitle('Регистрация'),
        AppCard(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LabeledField(
                label: 'Имя',
                hint: 'Введите ваше имя',
                controller: _firstName,
                capitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              LabeledField(
                label: 'Фамилия',
                hint: 'Введите вашу фамилию',
                controller: _lastName,
                capitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              LabeledField(
                label: 'Email',
                hint: 'example@gmail.com',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              LabeledField(
                label: 'Пароль',
                hint: 'Введите пароль',
                controller: _password,
                obscure: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 12),
              GreenLink(
                'Вернуться к странице входа',
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton('СОЗДАТЬ АККАУНТ',
            loading: _loading, onPressed: _submit),
        ErrorText(_error),
      ]),
    );
  }
}
