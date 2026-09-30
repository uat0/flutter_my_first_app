import 'package:supabase_flutter/supabase_flutter.dart';

SupabaseClient get db => Supabase.instance.client;

class BmiRecord {
  final double weight; // кг
  final double height; // м
  final double bmi;
  final DateTime createdAt;

  BmiRecord({
    required this.weight,
    required this.height,
    required this.bmi,
    required this.createdAt,
  });

  factory BmiRecord.fromMap(Map<String, dynamic> m) => BmiRecord(
        weight: (m['weight'] as num).toDouble(),
        height: (m['height'] as num).toDouble(),
        bmi: (m['bmi'] as num).toDouble(),
        createdAt: DateTime.parse(m['created_at'] as String).toLocal(),
      );
}

class Profile {
  final String firstName;
  final String lastName;
  final String email;
  Profile(this.firstName, this.lastName, this.email);
}

Future<void> saveRecord({
  required double weight,
  required double height,
  required double bmi,
  required String category,
}) async {
  // user_id подставляется в базе автоматически (default auth.uid()).
  await db.from('bmi_records').insert({
    'weight': weight,
    'height': height,
    'bmi': bmi,
    'category': category,
  });
}

Future<List<BmiRecord>> fetchRecords() async {
  final rows = await db
      .from('bmi_records')
      .select()
      .order('created_at', ascending: false);
  return rows.map(BmiRecord.fromMap).toList();
}

Future<Profile> fetchProfile() async {
  final user = db.auth.currentUser!;
  final row =
      await db.from('profiles').select().eq('id', user.id).maybeSingle();
  final meta = user.userMetadata ?? {};
  return Profile(
    (row?['first_name'] ?? meta['first_name'] ?? '') as String,
    (row?['last_name'] ?? meta['last_name'] ?? '') as String,
    (row?['email'] ?? user.email ?? '') as String,
  );
}

/// Понятные сообщения вместо английских ошибок Supabase.
String authErrorMessage(Object e) {
  if (e is AuthException) {
    final msg = e.message.toLowerCase();
    if (msg.contains('invalid login credentials')) {
      return 'Неверный email или пароль!';
    }
    if (msg.contains('already registered') || msg.contains('already exists')) {
      return 'Пользователь с таким email уже существует!';
    }
    if (msg.contains('email not confirmed')) {
      return 'Email не подтверждён. Проверьте почту!';
    }
    if (msg.contains('rate limit')) {
      return 'Слишком много попыток. Попробуйте позже!';
    }
    return e.message;
  }
  return 'Нет подключения к серверу. Проверьте интернет!';
}
