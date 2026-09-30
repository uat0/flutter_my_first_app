// Замените этим файлом стандартный test/widget_test.dart
// (старый ссылается на удалённый MyApp со счётчиком и будет с ошибкой).
// Если проект называется не my_first_app — поправьте имя в импорте.
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/bmi.dart';

void main() {
  test('ИМТ считается с точностью до 2 знаков', () {
    expect(calculateBmi(77, 1.85), 22.5);
    expect(calculateBmi(80, 1.78), 25.25);
    expect(calculateBmi(70, 1.75), 22.86);
  });

  test('форматирование как в макете', () {
    expect(formatNumber(22.5), '22.5');
    expect(formatNumber(25.25), '25.25');
    expect(formatNumber(77), '77');
  });

  test('рост в см и в метрах, запятая', () {
    expect(heightToMeters(175), 1.75);
    expect(heightToMeters(1.75), 1.75);
    expect(parseNumber('72,5'), 72.5);
  });

  test('категории по границам из ТЗ', () {
    expect(categoryFor(16).title, 'Выраженный дефицит массы тела');
    expect(categoryFor(18.49).title, 'Недостаточная масса тела');
    expect(categoryFor(18.5).title, 'Норма');
    expect(categoryFor(24.99).title, 'Норма');
    expect(categoryFor(25).title, 'Избыточная масса тела или предожирение');
    expect(categoryFor(30).title, 'Ожирение');
    expect(categoryFor(35).title, 'Ожирение резкое');
    expect(categoryFor(40).title, 'Очень резкое ожирение');
  });

  test('тексты ошибок как в макете', () {
    expect(validateLogin('', ''), 'Заполните все поля!');
    expect(validateBmiInput('', '77'), 'Поле Рост не заполнено!');
    expect(validateBmiInput('185', ''), 'Поле Вес не заполнено!');
    expect(validateRegistration('Иван', 'Иванов', 'a@b.ru', '123'),
        'Пароль должен содержать минимум 6 символов');
    expect(validateBmiInput('185', '77'), isNull);
  });
}
