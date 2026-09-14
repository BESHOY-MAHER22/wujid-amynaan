import 'dart:async';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'core/services/audio_service.dart';
import 'core/services/name_utils.dart';
import 'core/theme/app_theme.dart';
import 'welcome_page.dart';
import 'widgets/royal_header.dart';

class NameEntryPage extends StatefulWidget {
  const NameEntryPage({super.key});

  static const routeName = '/name-entry';

  @override
  State<NameEntryPage> createState() => _NameEntryPageState();
}

class _NameEntryPageState extends State<NameEntryPage>
    with TickerProviderStateMixin {
  late final AnimationController _introController;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  void _navigateToWelcome(String name, String gender) {
    Navigator.of(context).push(
      PageRouteBuilder(
        settings: RouteSettings(
          name: WelcomeInvitationPage.routeName,
          arguments: {'name': name, 'gender': gender},
        ),
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 320),
        pageBuilder: (_, animation, secondaryAnimation) {
          final page = WelcomeInvitationPage(name: name, gender: gender);

          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
              child: page,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                constraints: const BoxConstraints(maxWidth: 700),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 18,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedReveal(
                        controller: _introController,
                        delay: 0.0,
                        child: RoyalHeader(
                          title: 'حفل تخرج دفعة الشهيد القس أبونا مينا عبود',
                          subtitle: 'وُجِدَ أَمِينًا',
                        ),
                      ),
                      const SizedBox(height: 24),
                      AnimatedReveal(
                        controller: _introController,
                        delay: 0.22,
                        child: NameEntryCard(onSubmit: _navigateToWelcome),
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
    const logoSize = 85.0;
    const sharedTop = 20.0;

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            left: 24,
            top: sharedTop,
            child: _FloatingSideLogo(
              imagePath: 'assets/images/logo_float_1.png',
              size: logoSize,
              shadowColor: const Color(0xFFD4AF37).withValues(alpha: 0.26),
            ),
          ),
          Positioned(
            right: 24,
            top: sharedTop,
            child: _FloatingSideLogo(
              imagePath: 'assets/images/logo_float_2.png',
              size: logoSize,
              shadowColor: const Color(0xFFCC9C3F).withValues(alpha: 0.22),
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
    required this.shadowColor,
  });

  final String imagePath;
  final double size;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 24,
              spreadRadius: 10,
              offset: const Offset(0, 0),
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

class NameEntryCard extends StatefulWidget {
  const NameEntryCard({super.key, required this.onSubmit});

  final void Function(String name, String gender) onSubmit;

  @override
  State<NameEntryCard> createState() => _NameEntryCardState();
}

class _NameEntryCardState extends State<NameEntryCard> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final ConfettiController _confettiController;
  final List<String> _femaleNames = [
    'ماريا',
    'مريم',
    'سارة',
    'فاطمة',
    'مروة',
    'إيمان',
    'آية',
    'داليا',
    'رنا',
    'ياسمين',
    'هبة',
    'رغدة',
    'هدى',
    'منال',
    'دينا',
    'أماني',
    'أمل',
    'ملاك',
    'سلمى',
    'مها',
    'حلا',
    'فادية',
    'لينا',
    'سالي',
    'آلاء',
    'ليلى',
    'نورا',
    'ميرا',
    'هند',
    'شهد',
    'يمنى',
    'غادة',
    'منى',
    'رانية',
    'سميرة',
    'مها',
    'أنا',
  ];

  bool _isPressed = false;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  String _smartTitlePrefix(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'أ./';
    return _isFemaleName(trimmed) ? 'م./' : 'أ./';
  }

  bool _isFemaleName(String name) {
    final normalized = name.trim();
    if (normalized.isEmpty) return false;

    final lastChar = normalized.characters.last;
    if (lastChar == 'ة') return true;

    final simpleName = normalized
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll('-', '')
        .toLowerCase();

    return _femaleNames.any(
      (femaleName) =>
          femaleName.replaceAll(RegExp(r'\s+'), '').toLowerCase() == simpleName,
    );
  }

  void _showEmptyNameSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF2A1A08),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: const [
              Icon(Icons.info_outline_rounded, color: Colors.amber),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'برجاء كتابة اسمك أولاً قبل التأكيد.',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'EventBodyFont',
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleConfirm() async {
    final rawName = _controller.text.trim();

    if (rawName.isEmpty) {
      if (!mounted) return;
      _showEmptyNameSnackBar(context);
      return;
    }

    if (!mounted) return;
    await AudioService.instance.initializeFromUserAction();
    if (!mounted) return;

    await AudioService.instance.playClick();
    if (mounted) {
      _confettiController.play();
    }

    final gender = _isFemaleName(rawName) ? 'أنثى' : 'ذكر';
    widget.onSubmit(rawName, gender);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 600 ? screenWidth * 0.88 : 520.0;
    final helperPrefix = _smartTitlePrefix(_controller.text);
    final helperText = _controller.text.trim().isEmpty
        ? 'اكتب اسمك ليتغير العنوان تلقائيًا'
        : '$helperPrefix${_controller.text.trim()}';

    return Stack(
      children: [
        Positioned(
          top: 28,
          left: 20,
          child: ValueListenableBuilder<bool>(
            valueListenable: AudioService.instance.isMuted,
            builder: (context, isMuted, _) {
              return FloatingActionButton.small(
                backgroundColor: Colors.black.withValues(alpha: 0.38),
                foregroundColor: AppColors.imperialGold,
                elevation: 0,
                onPressed: () async {
                  await AudioService.instance.toggleMute();
                },
                child: Icon(
                  isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                ),
              );
            },
          ),
        ),
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 24,
                  maxBlastForce: 30,
                  minBlastForce: 10,
                  emissionFrequency: 0.05,
                  gravity: 0.18,
                  shouldLoop: false,
                  colors: const [
                    Colors.amber,
                    Colors.orange,
                    Colors.red,
                    Colors.yellow,
                    Colors.pink,
                    Colors.white,
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: cardWidth,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(18, 13, 8, 0.52),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.imperialGold.withValues(alpha: 0.9),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.imperialGold.withValues(alpha: 0.18),
                      blurRadius: 25,
                      spreadRadius: 1,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 18,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'اكتب اسمك في الدعوة',
                            textAlign: TextAlign.center,
                            style: AppTheme.bodyStyle(fontSize: 18).copyWith(
                              color: AppColors.imperialGold,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'اكتب اسمك هنا',
                                hintStyle: const TextStyle(
                                  color: Colors.white70,
                                  fontFamily: 'EventBodyFont',
                                ),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.06),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 18,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide(
                                    color:
                                        (_hasFocus ||
                                            _controller.text.isNotEmpty)
                                        ? Colors.amber.withValues(alpha: 0.9)
                                        : Colors.white.withValues(alpha: 0.18),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Colors.amber,
                                    width: 1.8,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'EventBodyFont',
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              child: isBishopAthanasius(_controller.text)
                                  ? Text(
                                      'نيافة الحبر الجليل الأنبا أثناسيوس الأسقف العام لمنطقة القبة',
                                      key: const ValueKey('bishop-badge'),
                                      textAlign: TextAlign.right,
                                      style: AppTheme.bodyStyle(fontSize: 13)
                                          .copyWith(
                                            color: AppColors.imperialGold,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    )
                                  : Text(
                                      helperText,
                                      key: ValueKey(helperText),
                                      textAlign: TextAlign.right,
                                      style: AppTheme.bodyStyle(fontSize: 13)
                                          .copyWith(
                                            color:
                                                _controller.text.trim().isEmpty
                                                ? Colors.white70
                                                : AppColors.imperialGold,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          AnimatedScale(
                            scale: _isPressed ? 0.96 : 1.0,
                            duration: const Duration(milliseconds: 120),
                            curve: Curves.easeInOut,
                            child: InkWell(
                              onTapDown: (_) =>
                                  setState(() => _isPressed = true),
                              onTapUp: (_) =>
                                  setState(() => _isPressed = false),
                              onTapCancel: () =>
                                  setState(() => _isPressed = false),
                              onTap: _handleConfirm,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE7C76A),
                                      Color(0xFFB77A00),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFB77A00)
                                          .withValues(alpha: 0.35),
                                      blurRadius: 18,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'دخول الدعوة',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF1A0F00),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'EventBodyFont',
                                  ),
                                ),
                              ),
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
        ),
      ],
    );
  }
}
