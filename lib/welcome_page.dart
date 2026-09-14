import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/services/name_utils.dart';
import 'core/theme/app_theme.dart';

class WelcomeInvitationPage extends WelcomePage {
  const WelcomeInvitationPage({
    super.key,
    required super.name,
    required super.gender,
  });

  static const routeName = '/welcome';
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required this.name, required this.gender});

  static const routeName = '/welcome';

  final String name;
  final String gender;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _countdownController;
  late final Timer? _countdownTimer;
  late DateTime _eventDateTime;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _eventDateTime = DateTime(2026, 10, 2, 18, 0);
    _remaining = _calculateRemaining();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _countdownController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remaining = _calculateRemaining();
      });
    });
  }

  Duration _calculateRemaining() {
    final difference = _eventDateTime.difference(DateTime.now());
    return difference.isNegative ? Duration.zero : difference;
  }

  @override
  void dispose() {
    _introController.dispose();
    _countdownController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  String get _titlePrefix => widget.gender == 'أنثى' ? 'م.' : 'أ.';

  String get _greetingText {
    if (isBishopAthanasius(widget.name)) return 'هنستناك يا سيدنا';
    return widget.gender == 'أنثى'
        ? 'هنستناكي يا $_titlePrefix ${widget.name}'
        : 'هنستناك يا $_titlePrefix ${widget.name}';
  }

  String get _whatsappMessage =>
      'أهلاً بك، أؤكد حضوري لحفل (وُجِدَ أَمِينًا) - الاسم: $_titlePrefix ${widget.name}';

  Future<void> _launchWhatsApp() async {
    final encodedMessage = Uri.encodeComponent(_whatsappMessage);
    final url = Uri.parse('https://wa.me/?text=$encodedMessage');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Unable to open WhatsApp link');
    }
  }

  Future<void> _launchGoogleCalendar() async {
    final start = DateTime(2026, 10, 2, 18, 0);
    final end = start.add(const Duration(hours: 3));
    final startUtc = start.toUtc();
    final endUtc = end.toUtc();

    final url = Uri.parse(
      'https://calendar.google.com/calendar/render'
      '?action=TEMPLATE'
      '&text=${Uri.encodeComponent('وُجِدَ أَمِينًا')}'
      '&details=${Uri.encodeComponent('حفل تخرج دفعة الشهيد القس أبونا مينا عبود\n\n$_greetingText')}'
      '&location=${Uri.encodeComponent('مسرح مارجرجس - منشية الصدر')}'
      '&dates=${startUtc.toIso8601String().replaceAll('-', '').replaceAll(':', '').replaceAll('.000', 'Z').replaceAll('Z', '')}/${endUtc.toIso8601String().replaceAll('-', '').replaceAll(':', '').replaceAll('.000', 'Z').replaceAll('Z', '')}',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Unable to open Google Calendar link');
    }
  }

  Future<void> _launchMap() async {
    const venueAddress = 'كنيسة مارجرجس منشية الصدر';
    final String mapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(venueAddress)}';

    if (!await launchUrl(
      Uri.parse(mapsUrl),
      mode: LaunchMode.externalApplication,
    )) {
      debugPrint('Unable to open Maps link');
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    final cells = [
      _TimeCard(label: 'أيام', value: days.toString().padLeft(2, '0')),
      _TimeCard(label: 'ساعات', value: hours.toString().padLeft(2, '0')),
      _TimeCard(label: 'دقايق', value: minutes.toString().padLeft(2, '0')),
      _TimeCard(label: 'ثواني', value: seconds.toString().padLeft(2, '0')),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A0F00),
                    Color(0xFF3D2200),
                    Color(0xFF0D0600),
                  ],
                ),
              ),
            ),
          ),
          const FloatingSideLogos(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 880),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 18,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedReveal(
                        controller: _introController,
                        delay: 0.0,
                        child: Image.asset(
                          'assets/images/logo_main.png',
                          height: 118,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 18),
                      AnimatedReveal(
                        controller: _introController,
                        delay: 0.08,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(18, 13, 8, 0.58),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.imperialGold.withValues(
                                alpha: 0.8,
                              ),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.imperialGold.withValues(
                                  alpha: 0.15,
                                ),
                                blurRadius: 24,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                _greetingText,
                                textAlign: TextAlign.center,
                                style: AppTheme.goldTitleStyle(fontSize: 26)
                                    .copyWith(
                                      fontSize:
                                          MediaQuery.of(context).size.width <
                                              420
                                          ? 22
                                          : 28,
                                    ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '📅 الجمعة 2 أكتوبر 2026 - ⏰ الساعة 6:00 مساءً',
                                textAlign: TextAlign.center,
                                style: AppTheme.bodyStyle(fontSize: 17)
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '📍 كنيسة مارجرجس منشية الصدر',
                                textAlign: TextAlign.center,
                                style: AppTheme.bodyStyle(fontSize: 17)
                                    .copyWith(
                                      color: AppColors.imperialGold,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      AnimatedReveal(
                        controller: _introController,
                        delay: 0.16,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final itemWidth = constraints.maxWidth < 600
                                ? (constraints.maxWidth - 24) / 2
                                : (constraints.maxWidth - 48) / 4;

                            return Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 12,
                              runSpacing: 12,
                              children: List.generate(cells.length, (index) {
                                return SizedBox(
                                  width: itemWidth,
                                  child: cells[index],
                                );
                              }),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 26),
                      AnimatedReveal(
                        controller: _introController,
                        delay: 0.24,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _ActionButton(
                              label: 'تأكيد الحضور',
                              icon: Icons.chat_rounded,
                              color: const Color(0xFF25D366),
                              onPressed: _launchWhatsApp,
                            ),
                            _ActionButton(
                              label: 'إضافة للتقويم',
                              icon: Icons.calendar_month_rounded,
                              color: const Color(0xFF2F6BFF),
                              onPressed: _launchGoogleCalendar,
                            ),
                            _ActionButton(
                              label: 'موقع الحفل',
                              icon: Icons.location_on_rounded,
                              color: const Color(0xFFB77A00),
                              onPressed: _launchMap,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingSideLogos extends StatelessWidget {
  const FloatingSideLogos({super.key});

  @override
  Widget build(BuildContext context) {
    const double sideSize = 85;
    const double sharedTop = 20;

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            left: 24,
            top: sharedTop,
            child: _FloatingSideLogo(
              imagePath: 'assets/images/logo_float_1.png',
              size: sideSize,
              beginOffset: const Offset(0, -8),
              endOffset: const Offset(0, 8),
              duration: const Duration(milliseconds: 3500),
              shadowColor: const Color(0xFFD4AF37).withValues(alpha: 0.30),
            ),
          ),
          Positioned(
            right: 24,
            top: sharedTop,
            child: _FloatingSideLogo(
              imagePath: 'assets/images/logo_float_2.png',
              size: sideSize,
              beginOffset: const Offset(0, 8),
              endOffset: const Offset(0, -8),
              duration: const Duration(milliseconds: 4000),
              shadowColor: const Color(0xFFCC9C3F).withValues(alpha: 0.26),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingSideLogo extends StatelessWidget {
  const _FloatingSideLogo({
    required this.imagePath,
    required this.size,
    required this.beginOffset,
    required this.endOffset,
    required this.duration,
    required this.shadowColor,
  });

  final String imagePath;
  final double size;
  final Offset beginOffset;
  final Offset endOffset;
  final Duration duration;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return Animate(
      autoPlay: true,
      onComplete: (controller) => controller.repeat(reverse: true),
      effects: [
        MoveEffect(
          begin: beginOffset,
          end: endOffset,
          duration: duration,
          curve: Curves.easeInOut,
        ),
      ],
      child: SizedBox(
        width: size,
        height: size,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 22,
                spreadRadius: 8,
                offset: Offset.zero,
              ),
            ],
          ),
          child: Image.asset(
            imagePath,
            width: size,
            height: size,
            fit: BoxFit.contain,
            opacity: const AlwaysStoppedAnimation(0.82),
          ),
        ),
      ),
    );
  }
}

class AnimatedReveal extends StatelessWidget {
  const AnimatedReveal({
    super.key,
    required this.child,
    required this.controller,
    required this.delay,
    this.offset = const Offset(0, 18),
  });

  final Widget child;
  final AnimationController controller;
  final double delay;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(
        delay.clamp(0.0, 1.0),
        (delay + 0.22).clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );

    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: offset,
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  const _TimeCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.imperialGold.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTheme.goldTitleStyle(fontSize: 26).copyWith(fontSize: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTheme.bodyStyle(fontSize: 14)
                .copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          constraints: const BoxConstraints(minWidth: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.92),
                color.withValues(alpha: 0.78),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Text(
                label,
                style: AppTheme.bodyStyle(fontSize: 15)
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
