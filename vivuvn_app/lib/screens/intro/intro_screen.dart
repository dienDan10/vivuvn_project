import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:vivuvn_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import '../../common/theme/app_theme.dart';
import '../../core/routes/routes.dart';

/// Provider load trạng thái đã xem intro
final seenIntroProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('seen_intro') ?? false;
});

/// Provider action để set seen_intro = true
final seenIntroActionProvider = Provider((ref) {
  return (bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_intro', value);
    // force refresh provider
    ref.invalidate(seenIntroProvider);
  };
});

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  bool showFirstScene = true;
  bool showSecondScene = false;
  bool isExiting = false;

  Timer? _timer1;
  Timer? _timer2;

  @override
  void initState() {
    super.initState();

    // Sau 5s -> ẩn cảnh 1
    _timer1 = Timer(const Duration(seconds: 5), () {
      if (mounted && !isExiting) {
        setState(() => showFirstScene = false);
      }
      // Sau thêm 1s -> hiện cảnh 2
      _timer2 = Timer(const Duration(seconds: 1), () {
        if (mounted && !isExiting) {
          setState(() => showSecondScene = true);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer1?.cancel();
    _timer2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        // 👉 nếu đang thoát thì hiển thị trống ngay lập tức
        child: isExiting
            ? const SizedBox.shrink()
            : (showFirstScene
            ? buildFirstScene()
            : (showSecondScene
            ? buildSecondScene()
            : const SizedBox.shrink())),
      ),
    );
  }

  /// Cảnh 1
  Widget buildFirstScene() {
    final theme = Theme.of(context);
    final gradient = theme.extension<GradientBackground>();
    return Container(
      key: const ValueKey(1),
      decoration: BoxDecoration(
        gradient: gradient != null
            ? LinearGradient(
          colors: gradient.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: gradient == null ? theme.colorScheme.background : null,
      ),
      alignment: Alignment.center,
      child: Stack(
        children: [
          Center(
            child: Text(
              AppLocalizations.of(context)!.introHello,
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground,
              ),
            ),
          ),
          const Positioned(
            top: 130,
            left: 30,
            child: ShakeIcon(assetPath: "assets/intro/banhtrung.png", size: 160),
          ),
          const Positioned(
            top: 70,
            right: 30,
            child: ShakeIcon(assetPath: "assets/intro/non.png", size: 155),
          ),
          const Positioned(
            bottom: 150,
            left: 20,
            child: ShakeIcon(assetPath: "assets/intro/quoctugiam.png", size: 135),
          ),
          const Positioned(
            bottom: 70,
            right: 20,
            child: ShakeIcon(assetPath: "assets/intro/pho.png", size: 155),
          ),
        ],
      ),
    );
  }

  /// Cảnh 2
  Widget buildSecondScene() {
    final theme = Theme.of(context);
    final gradient = theme.extension<GradientBackground>();

    return Container(
      key: const ValueKey(2),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        gradient: gradient != null
            ? LinearGradient(
          colors: gradient.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: gradient == null ? theme.colorScheme.background : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Image.asset("assets/logo.png", height: 100),
          const SizedBox(height: 20),

          // Slogan
          Text(
            AppLocalizations.of(context)!.introSlogan,
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 35),

          // Stars + Editor Choice
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
                  (index) => const Icon(Icons.star, color: Colors.yellow, size: 40),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.introEditorChoice,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          /// Trips planned
          Text(
            AppLocalizations.of(context)!.introTripsPlanned,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          /// Marquee địa điểm
          SizedBox(
            height: 50,
            child: Marquee(
              text: AppLocalizations.of(context)!.introDestinations,
              style: GoogleFonts.raleway(
                fontSize: 36,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: theme.colorScheme.onBackground,
              ),
              blankSpace: 80.0,
              velocity: 40.0,
            ),
          ),
          const SizedBox(height: 40),

          // Button Continue
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0.8, end: 1),
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 90,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 6,
              ),
              onPressed: () async {
                final setSeenIntro = ref.read(seenIntroActionProvider);
                await setSeenIntro(true);

                if (mounted) {
                  setState(() {
                    isExiting = true;
                    showFirstScene = false;
                    showSecondScene = false;
                  });

                  _timer1?.cancel();
                  _timer2?.cancel();

                  // delay 1 frame để AnimatedSwitcher build rỗng rồi mới replace
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      context.replace(homeRoute);
                    }
                  });
                }
              },
              child: Text(
                AppLocalizations.of(context)!.introContinue,
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget Image lắc nhẹ
class ShakeIcon extends StatefulWidget {
  final String assetPath;
  final int delay;
  final double size;

  const ShakeIcon({
    super.key,
    required this.assetPath,
    this.delay = 0,
    this.size = 80,
  });

  @override
  State<ShakeIcon> createState() => _ShakeIconState();
}

class _ShakeIconState extends State<ShakeIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // chỉ start repeat khi widget còn mounted
    if (mounted) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: -0.03, end: 0.03).animate(_controller),
      child: Image.asset(
        widget.assetPath,
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}
