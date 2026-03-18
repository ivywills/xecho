import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _skyTop = Color(0xFFF7FBFC);
const Color _skyMid = Color(0xFFE7F0F2);
const Color _skyBottom = Color(0xFFD6E3E7);
const Color _ink = Color(0xFF28424A);
const Color _mutedInk = Color(0xFF607C84);
const Color _mistBlue = Color(0xFF6C8994);
const Color _cardWhite = Color(0xFFF9FBFB);

class MentalHealthTip {
  final String title;
  final String explanation;

  MentalHealthTip(this.title, this.explanation);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'xecho',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _skyBottom,
          brightness: Brightness.light,
          primary: _mistBlue,
        ),
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: GoogleFonts.nunitoSansTextTheme().apply(
          bodyColor: _ink,
          displayColor: _ink,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.nunitoSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: _ink,
          ),
        ),
      ),
      home: const MyHomePage(title: 'xecho'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool _cloudButtonVisible = true;
  MentalHealthTip? _selectedMessage;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Random _random = Random();
  Timer? _timer;
  int _timeLeft = 180;
  int _rating = 0;
  bool _isHoveringCloud = false;
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  late Animation<Offset> _floatingAnimation;

  final List<MentalHealthTip> _messages = [
    MentalHealthTip(
      'Square Breathing',
      'This is a 3-minute activity. Inhale slowly for a count of 4. Hold your breath for a count of 4. Exhale slowly for a count of 4. Hold your empty breath for a count of 4. Repeat this cycle to calm your nervous system.',
    ),
    MentalHealthTip(
      'Wall Gazing',
      'This is a 3-minute activity. Find a blank spot on a wall. Soften your gaze and stare at it. Let your thoughts pass by like clouds without focusing on them. Allow your mind to settle into the present moment.',
    ),
    MentalHealthTip(
      'Micro-Meditation',
      'This is a 3-minute activity. Close your eyes. Focus only on the sensation of air entering and leaving your nostrils. If your mind wanders, gently bring it back to your breath. Feel the coolness of the inhale and warmth of the exhale.',
    ),
    MentalHealthTip(
      '4-7-8 Breathing',
      'This is a 3-minute activity. Inhale quietly through the nose for 4 seconds. Hold the breath for 7 seconds. Exhale forcefully through the mouth for 8 seconds making a whooshing sound. This rhythm acts as a natural tranquilizer for the nervous system.',
    ),
    MentalHealthTip(
      '5-4-3-2-1 Grounding',
      'This is a 3-minute activity. Acknowledge 5 things you see, 4 things you can touch, 3 things you hear, 2 things you can smell, and 1 thing you can taste. This technique brings you back to the present moment when anxiety feels overwhelming.',
    ),
    MentalHealthTip(
      'Progressive Relaxation',
      'This is a 3-minute activity. Starting from your toes, tense your muscles for 5 seconds, then release. Move up progressively through your legs, stomach, hands, shoulders, and face. Feel the difference between tension and relaxation.',
    ),
    MentalHealthTip(
      'Positive Affirmation',
      'This is a 3-minute activity. Repeat to yourself: "I am safe. I am calm. I am capable of handling this moment." Let these words sink in with every breath you take, building inner strength and resilience.',
    ),
    MentalHealthTip(
      'Shoulder Drop',
      'This is a 3-minute activity. Notice your shoulders right now. Are they raised? Drop them down. Roll them back. Let the tension melt away. Focus on keeping your shoulders relaxed while taking deep, slow breaths.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    final curvedAnimation = CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    );

    _breathingAnimation = Tween<double>(
      begin: 1,
      end: 1.05,
    ).animate(curvedAnimation);

    _floatingAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.04),
    ).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer?.cancel();
    _breathingController.dispose();
    super.dispose();
  }

  Future<void> _playRandomSound() async {
    try {
      final sounds = ['beep.mp3', 'boop.mp3'];
      final selectedSound = sounds[_random.nextInt(sounds.length)];
      await _audioPlayer.setReleaseMode(ReleaseMode.release);
      await _audioPlayer.play(AssetSource(selectedSound));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void _onCloudButtonPressed() {
    _showNextTip();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 180;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _showNextTip() {
    setState(() {
      _cloudButtonVisible = false;
      _rating = 0;
      MentalHealthTip newMessage;
      do {
        newMessage = _messages[_random.nextInt(_messages.length)];
      } while (_messages.length > 1 && newMessage == _selectedMessage);

      _selectedMessage = newMessage;
    });
    _startTimer();
  }

  void _goBack() {
    _timer?.cancel();
    setState(() {
      _cloudButtonVisible = true;
      _selectedMessage = null;
      _rating = 0;
    });
  }

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  String get _timerString {
    if (_timeLeft <= 0) return 'I hope you are feeling better';
    final minutes = _timeLeft ~/ 60;
    final seconds = _timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  TextStyle _pageTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double height = 1.2,
    double? letterSpacing,
    List<FontFeature>? fontFeatures,
  }) {
    return GoogleFonts.nunitoSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      fontFeatures: fontFeatures,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _cloudButtonVisible
          ? AppBar(
              forceMaterialTransparency: true,
              title: Text(widget.title),
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_skyTop, _skyMid, _skyBottom],
            stops: [0, 0.58, 1],
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _cloudButtonVisible ? _buildHomeView() : _buildTipView(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _playRandomSound,
        tooltip: 'Play beep boop',
        backgroundColor: Colors.white.withValues(alpha: 0.88),
        foregroundColor: _mistBlue,
        elevation: 2,
        child: const Icon(Icons.graphic_eq_rounded),
      ),
    );
  }

  Widget _buildHomeView() {
    return SafeArea(
      key: const ValueKey('HomeView'),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Drift back to a quieter moment.',
                  style: _pageTextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    color: _ink,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tap the cloud whenever you need a short, calm reset.',
                  style: _pageTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _mutedInk,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 56),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ScaleTransition(
                      scale: _breathingAnimation,
                      child: Container(
                        width: 260,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.78),
                              blurRadius: 70,
                              spreadRadius: 18,
                            ),
                            BoxShadow(
                              color: _skyBottom.withValues(alpha: 0.55),
                              blurRadius: 40,
                              spreadRadius: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: _floatingAnimation,
                      child: ScaleTransition(
                        scale: _breathingAnimation,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) =>
                              setState(() => _isHoveringCloud = true),
                          onExit: (_) =>
                              setState(() => _isHoveringCloud = false),
                          child: GestureDetector(
                            onTap: _onCloudButtonPressed,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOut,
                              padding: EdgeInsets.all(_isHoveringCloud ? 8 : 0),
                              child: SizedBox(
                                width: 280,
                                height: 200,
                                child: Image.asset(
                                  'assets/cloud.png',
                                  fit: BoxFit.contain,
                                  opacity: AlwaysStoppedAnimation(
                                    _isHoveringCloud ? 1 : 0.96,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'Tap the cloud',
                  style: _pageTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _mutedInk,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipView() {
    return SafeArea(
      key: ValueKey(_selectedMessage?.title ?? 'TipView'),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 0,
                  color: _cardWhite.withValues(alpha: 0.92),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.72),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedMessage!.title,
                          style: _pageTextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: _ink,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _selectedMessage!.explanation,
                          style: _pageTextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: _ink.withValues(alpha: 0.95),
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.72),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            _timerString,
                            style: _pageTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _mutedInk,
                              fontFeatures: const [
                                FontFeature.tabularFigures()
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Rate this activity',
                          style: _pageTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _mutedInk,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              onPressed: () => _setRating(index + 1),
                              icon: Icon(
                                index < _rating
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: const Color(0xFFF2B85C),
                                size: 36,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              style: IconButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: _goBack,
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: Text(
                        'Back',
                        style: _pageTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _ink,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        foregroundColor: _ink,
                        backgroundColor: Colors.white.withValues(alpha: 0.62),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: _showNextTip,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(
                        'Next Tip',
                        style: _pageTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: _mistBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
