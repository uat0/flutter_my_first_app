# Калькулятор ИМТ (BodyMassIndexCalculator) — Flutter + Supabase

Дизайн сделан по макету Figma: палитра #F5F5F5 / #4CAF50 / #FFFFFF / #FF5252 / #757575 / #212121,
шрифт Inter, белые карточки с тенью, поля с подписью сверху, ошибки красным текстом под кнопкой.

## Структура

```
lib/
  main.dart                 запуск, Supabase, выбор экрана (вход / главный)
  config.dart               URL и ключ Supabase  ← ЗАПОЛНИТЬ
  theme.dart                цвета и стили из макета
  bmi.dart                  формула ИМТ, категории, валидация, тексты ошибок
  data.dart                 работа с базой (история, профиль)
  widgets.dart              компоненты из макета: кнопка, поле, карточка, навигация, текст ошибки
  screens/                  вход, регистрация, калькулятор, профиль, нижнее меню
assets/avatar.png           аватарка (можно заменить на картинку из Figma)
supabase/schema.sql         таблицы и права доступа
test/widget_test.dart       тесты расчёта и валидации
```

## 1. Supabase

1. Создайте проект на https://supabase.com.
2. **SQL Editor → New query**, вставьте `supabase/schema.sql`, нажмите **Run**.
3. **Authentication → Sign In / Providers → Email**: выключите **Confirm email**.
4. **Project Settings → API**: скопируйте **Project URL** и **anon / publishable key** в `lib/config.dart`.

## 2. Flutter-проект

1. Скопируйте папки `lib/`, `test/` и `assets/` в корень проекта с заменой файлов.
2. Установите пакеты:
   ```
   flutter pub add supabase_flutter google_fonts
   ```
3. В `pubspec.yaml` в разделе `flutter:` добавьте картинку (отступы — пробелами):
   ```yaml
   flutter:
     uses-material-design: true
     assets:
       - assets/avatar.png
   ```
4. В `android/app/src/main/AndroidManifest.xml` перед `<application` добавьте
   (нужно для release-сборки):
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```
5. Запуск: `flutter pub get`, затем `flutter run`. Тесты: `flutter test`.

Аватарку из макета можно выгрузить из Figma: выделить картинку → справа внизу **Export → PNG**,
сохранить как `assets/avatar.png`.
