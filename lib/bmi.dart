class BmiCategory {
  final String title;
  final String advice;
  const BmiCategory(this.title, this.advice);

  /// Полный текст рекомендации, как в макете.
  String get recommendation => '$title. $advice';
}

/// ИМТ = вес (кг) / рост (м)², округление до 2 знаков.
double calculateBmi(double weightKg, double heightM) {
  final bmi = weightKg / (heightM * heightM);
  return (bmi * 100).roundToDouble() / 100;
}

BmiCategory categoryFor(double bmi) {
  if (bmi <= 16) {
    return const BmiCategory('Выраженный дефицит массы тела',
        'Советуем набрать вес для здоровья.');
  }
  if (bmi < 18.5) {
    return const BmiCategory(
        'Недостаточная масса тела', 'Рекомендуется увеличить массу тела.');
  }
  if (bmi < 25) {
    return const BmiCategory(
        'Норма', 'Ваш вес в здоровом диапазоне — поддерживайте его!');
  }
  if (bmi < 30) {
    return const BmiCategory('Избыточная масса тела или предожирение',
        'Желательно снизить вес для улучшения самочувствия.');
  }
  if (bmi < 35) {
    return const BmiCategory(
        'Ожирение', 'Рекомендуется уменьшить вес под контролем специалиста.');
  }
  if (bmi < 40) {
    return const BmiCategory('Ожирение резкое',
        'Необходимо снижение веса с медицинской поддержкой.');
  }
  return const BmiCategory('Очень резкое ожирение',
      'Требуется срочная коррекция веса под наблюдением врача.');
}

/// Принимает и точку, и запятую: "72,5" → 72.5
double? parseNumber(String s) =>
    double.tryParse(s.trim().replaceAll(',', '.'));

/// Рост можно ввести в см (175) или в метрах (1.75).
double heightToMeters(double value) => value > 3 ? value / 100 : value;

/// До 2 знаков без лишних нулей: 22.50 → "22.5", 25.25 → "25.25", 77.0 → "77"
String formatNumber(double v) {
  var s = v.toStringAsFixed(2);
  if (s.contains('.')) {
    s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
  return s;
}

// ---------- Валидация (тексты ошибок как в макете) ----------

final _emailRe = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
final _nameRe = RegExp(r"^[A-Za-zА-Яа-яЁё\- ']+$");

String? validateLogin(String email, String password) {
  if (email.trim().isEmpty || password.isEmpty) return 'Заполните все поля!';
  if (!_emailRe.hasMatch(email.trim())) return 'Некорректный формат email!';
  return null;
}

String? validateRegistration(
    String firstName, String lastName, String email, String password) {
  if ([firstName, lastName, email].any((s) => s.trim().isEmpty) ||
      password.isEmpty) {
    return 'Заполните все поля!';
  }
  if (!_nameRe.hasMatch(firstName.trim())) {
    return 'Имя должно содержать только буквы!';
  }
  if (!_nameRe.hasMatch(lastName.trim())) {
    return 'Фамилия должна содержать только буквы!';
  }
  if (!_emailRe.hasMatch(email.trim())) return 'Некорректный формат email!';
  if (password.length < 6) return 'Пароль должен содержать минимум 6 символов';
  return null;
}

String? validateBmiInput(String height, String weight) {
  final hEmpty = height.trim().isEmpty;
  final wEmpty = weight.trim().isEmpty;
  if (hEmpty && wEmpty) return 'Заполните все поля!';
  if (hEmpty) return 'Поле Рост не заполнено!';
  if (wEmpty) return 'Поле Вес не заполнено!';

  final h = parseNumber(height);
  if (h == null) return 'Рост должен быть числом!';
  final m = heightToMeters(h);
  if (m < 0.5 || m > 2.5) return 'Рост должен быть от 50 до 250 см!';

  final w = parseNumber(weight);
  if (w == null) return 'Вес должен быть числом!';
  if (w < 20 || w > 300) return 'Вес должен быть от 20 до 300 кг!';
  return null;
}
