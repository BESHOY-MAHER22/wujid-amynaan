import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/services/audio_service.dart';
import '../core/theme/app_theme.dart';

class RoyalHeader extends StatefulWidget {
  const RoyalHeader({
    super.key,
    required this.title,
    this.subtitle = 'وُجِدَ أَمِينًا',
    this.showAudioToggle = true,
  });

  final String title;
  final String subtitle;
  final bool showAudioToggle;

  @override
  State<RoyalHeader> createState() => _RoyalHeaderState();
}

class _RoyalHeaderState extends State<RoyalHeader> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 420;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              if (widget.showAudioToggle)
                Positioned(
                  top: 4,
                  right: 10,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: AudioService.instance.isMuted,
                    builder: (context, isMuted, _) {
                      return FloatingActionButton.small(
                        heroTag: 'royal_header_audio_toggle',
                        backgroundColor: Colors.black.withValues(alpha: 0.32),
                        foregroundColor: AppColors.imperialGold,
                        elevation: 0,
                        tooltip: isMuted ? 'تشغيل الصوت' : 'إيقاف الصوت',
                        onPressed: () async {
                          await AudioService.instance.toggleMute();
                        },
                        child: Icon(
                          isMuted
                              ? Icons.volume_off_rounded
                              : Icons.volume_up_rounded,
                          size: 18,
                        ),
                      );
                    },
                  ),
                ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _isHovered = true),
                    onExit: (_) => setState(() => _isHovered = false),
                    child: Animate(
                      autoPlay: true,
                      onComplete: (controller) =>
                          controller.repeat(reverse: true),
                      effects: const [
                        ScaleEffect(
                          begin: Offset(1, 1),
                          end: Offset(1.04, 1.04),
                          duration: Duration(milliseconds: 1800),
                          curve: Curves.easeInOut,
                        ),
                        ShimmerEffect(
                          duration: Duration(milliseconds: 1600),
                          color: AppColors.imperialGold,
                          blendMode: BlendMode.srcIn,
                        ),
                      ],
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        scale: _isHovered ? 1.05 : 1.0,
                        child: Image.asset(
                          'assets/images/logo_main.png',
                          height: isCompact ? 110 : 140,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.goldTitleStyle(
                        fontSize: isCompact ? 22 : 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyStyle(fontSize: isCompact ? 18 : 22)
                        .copyWith(
                          color: AppColors.imperialGold,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
