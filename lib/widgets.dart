import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme.dart';

/// Центрированная прокручиваемая колонка с ограничением ширины.
class CenteredScroll extends StatelessWidget {
  final List<Widget> children;
  const CenteredScroll({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

/// «Заголовок страницы»
class PageTitle extends StatelessWidget {
  final String text;
  const PageTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// «Фон блока интерфейса» — белая карточка со скруглением и тенью.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color color;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(24, 24, 24, 16),
    this.color = AppColors.surface,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: kCardShadow,
      ),
      child: child,
    );
  }
}

/// «Поле ввода»: подпись сверху + поле с линией снизу.
class LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final bool numeric;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization capitalization;

  const LabeledField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.numeric = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.capitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: numeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : keyboardType,
          inputFormatters: numeric
              ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))]
              : null,
          textInputAction: textInputAction,
          textCapitalization: capitalization,
          onSubmitted: onSubmitted,
          style: const TextStyle(fontSize: 14, color: AppColors.text),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

/// Зелёный кликабельный текст («Зарегистрироваться», «Вернуться к странице входа»).
class GreenLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const GreenLink(this.text, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
        child: Text(text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

/// «Кнопка действия»
class PrimaryButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;
  const PrimaryButton(this.label,
      {super.key, required this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2.5, color: Colors.white))
          : Text(label),
    );
  }
}

/// «Текст ошибки» — красный текст под кнопкой.
class ErrorText extends StatelessWidget {
  final String? message;
  const ErrorText(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        message!,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, color: AppColors.error),
      ),
    );
  }
}

/// «Навигация» — белая панель с двумя текстовыми вкладками.
class AppBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const AppBottomNav({super.key, required this.index, required this.onTap});

  static const _items = ['Калькулятор', 'Профиль'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
              color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(i),
                    child: Center(
                      child: Text(
                        _items[i],
                        style: TextStyle(
                          fontSize: 15,
                          color: i == index
                              ? AppColors.text
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
