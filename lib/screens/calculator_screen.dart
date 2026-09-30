import 'package:flutter/material.dart';

import '../bmi.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

class CalculatorScreen extends StatefulWidget {
  final VoidCallback? onSaved;
  const CalculatorScreen({super.key, this.onSaved});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _height = TextEditingController();
  final _weight = TextEditingController();
  bool _saving = false;
  String? _error;
  double? _bmi;

  @override
  void dispose() {
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    FocusScope.of(context).unfocus();
    final error = validateBmiInput(_height.text, _weight.text);
    setState(() => _error = error);
    if (error != null) return;

    final heightM = heightToMeters(parseNumber(_height.text)!);
    final weight = parseNumber(_weight.text)!;
    final bmi = calculateBmi(weight, heightM);

    setState(() {
      _bmi = bmi;
      _saving = true;
    });

    try {
      await saveRecord(
        weight: weight,
        height: heightM,
        bmi: bmi,
        category: categoryFor(bmi).title,
      );
      widget.onSaved?.call();
    } catch (_) {
      if (mounted) {
        setState(() =>
            _error = 'Результат не сохранён в историю. Проверьте интернет!');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CenteredScroll(children: [
      const PageTitle('Индекс массы тела'),
      AppCard(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Персональные данные',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
            const SizedBox(height: 10),
            LabeledField(
              label: 'Рост (см)',
              hint: 'Например, 175',
              controller: _height,
              numeric: true,
            ),
            const SizedBox(height: 16),
            LabeledField(
              label: 'Вес (кг)',
              hint: 'Например, 70',
              controller: _weight,
              numeric: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _calculate(),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      PrimaryButton('РАССЧИТАТЬ', loading: _saving, onPressed: _calculate),
      ErrorText(_error),
      if (_bmi != null) ...[
        const SizedBox(height: 20),
        _ResultCard(bmi: _bmi!),
      ],
    ]);
  }
}

class _ResultCard extends StatelessWidget {
  final double bmi;
  const _ResultCard({required this.bmi});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.resultBackground,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Ваш индекс массы тела:',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
          const SizedBox(height: 12),
          Text(formatNumber(bmi),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
          const SizedBox(height: 16),
          Text(categoryFor(bmi).recommendation,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
