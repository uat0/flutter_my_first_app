import 'package:flutter/material.dart';

import '../bmi.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<(Profile, List<BmiRecord>)> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<(Profile, List<BmiRecord>)> _load() async {
    final results = await Future.wait([fetchProfile(), fetchRecords()]);
    return (results[0] as Profile, results[1] as List<BmiRecord>);
  }

  Future<void> _refresh() async {
    final f = _load();
    setState(() => _future = f);
    await f;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (snap.hasError) return _ErrorState(onRetry: _refresh);

          final (profile, records) = snap.data!;
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _refresh,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  children: [
                    _ProfileCard(profile),
                    const SizedBox(height: 12),
                    const AppCard(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Text('Активность',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                    ),
                    const SizedBox(height: 12),
                    if (records.isEmpty)
                      const AppCard(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Пока нет расчётов. Посчитайте ИМТ на вкладке «Калькулятор».',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textSecondary),
                        ),
                      )
                    else
                      for (final r in records)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ActivityItem(r),
                        ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Profile p;
  const _ProfileCard(this.p);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Column(
              children: [
                // Аватарка: любое изображение (assets/avatar.png).
                Container(
                  width: 76,
                  height: 76,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/avatar.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        color: AppColors.resultBackground,
                        child: const Icon(Icons.person,
                            size: 44, color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('${p.firstName} ${p.lastName}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(p.email,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          // Выход из аккаунта (AuthGate сам покажет экран входа)
          Positioned(
            top: -8,
            right: -8,
            child: IconButton(
              tooltip: 'Выйти',
              icon: const Icon(Icons.logout,
                  size: 20, color: AppColors.textSecondary),
              onPressed: () => db.auth.signOut(),
            ),
          ),
        ],
      ),
    );
  }
}

/// «Элемент списка активности»
class _ActivityItem extends StatelessWidget {
  final BmiRecord r;
  const _ActivityItem(this.r);

  static String _two(int n) => n.toString().padLeft(2, '0');

  String get _time {
    final d = r.createdAt;
    final now = DateTime.now();
    final days = DateTime(now.year, now.month, now.day)
        .difference(DateTime(d.year, d.month, d.day))
        .inDays;
    final hm = '${_two(d.hour)}:${_two(d.minute)}';
    if (days == 0) return 'Сегодня, $hm';
    if (days == 1) return 'Вчера, $hm';
    return '${_two(d.day)}.${_two(d.month)}.${d.year}, $hm';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Field('Время расчёта', _time),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Field('Рост', '${(r.height * 100).round()}'),
              const SizedBox(width: 36),
              _Field('Вес', formatNumber(r.weight)),
              const SizedBox(width: 40),
              Expanded(child: _Field('Индекс массы тела', formatNumber(r.bmi))),
            ],
          ),
          const SizedBox(height: 10),
          _Field('Рекомендация', categoryFor(r.bmi).recommendation),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;
  const _Field(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.text)),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final Future<void> Function() onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Не удалось загрузить профиль!',
                style: TextStyle(fontSize: 14, color: AppColors.error)),
            const SizedBox(height: 16),
            PrimaryButton('ПОВТОРИТЬ', onPressed: onRetry),
            GreenLink('Выйти из аккаунта', onTap: () => db.auth.signOut()),
          ],
        ),
      ),
    );
  }
}
