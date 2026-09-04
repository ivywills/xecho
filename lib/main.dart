import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Light blue + white palette.
const Color _skyTop = Color(0xFFFFFFFF);
const Color _skyMid = Color(0xFFE3F2FD);
const Color _skyBottom = Color(0xFFBBDEFB);
const Color _ink = Color(0xFF0D3B66);
const Color _mutedInk = Color(0xFF3F7CB0);
const Color _accentBlue = Color(0xFF42A5F5);
const Color _cardWhite = Color(0xFFFFFFFF);

class MentalHealthTip {
  final String title;
  final String explanation;

  MentalHealthTip(this.title, this.explanation);
}

void main() {
  runApp(const MyApp());
}

// Arimo is metrically identical to Arial and is served as a web font, so it
// renders the same on every device (Flutter web cannot rely on system Arial).
TextStyle _font({
  required double fontSize,
  FontWeight fontWeight = FontWeight.w700,
  required Color color,
  double height = 1.2,
  double? letterSpacing,
  List<FontFeature>? fontFeatures,
}) {
  return GoogleFonts.arimo(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
    fontFeatures: fontFeatures,
  );
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
          seedColor: _accentBlue,
          brightness: Brightness.light,
          primary: _accentBlue,
        ),
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: GoogleFonts.arimoTextTheme().apply(
          bodyColor: _ink,
          displayColor: _ink,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MentalHealthTip _selectedMessage;
  final Random _random = Random();
  Timer? _timer;
  int _timeLeft = 180;

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
    _selectedMessage = _messages[_random.nextInt(_messages.length)];
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
      MentalHealthTip newMessage;
      do {
        newMessage = _messages[_random.nextInt(_messages.length)];
      } while (_messages.length > 1 && newMessage == _selectedMessage);

      _selectedMessage = newMessage;
    });
    _startTimer();
  }

  String get _timerString {
    if (_timeLeft <= 0) return 'I hope you are feeling better';
    final minutes = _timeLeft ~/ 60;
    final seconds = _timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_skyTop, _skyMid, _skyBottom],
            stops: [0, 0.55, 1],
          ),
        ),
        child: _buildTipView(),
      ),
    );
  }

  Widget _buildTipView() {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 600;
          final cardWidth = min(640.0, constraints.maxWidth - 32);

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              children: [
                // The card is laid out at its natural size for [cardWidth],
                // then scaled down uniformly if the viewport is too short, so
                // it always fits without scrolling.
                Expanded(
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        width: cardWidth,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          child: _buildCard(
                            key: ValueKey(_selectedMessage.title),
                            compact: compact,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: FilledButton.icon(
                    onPressed: _showNextTip,
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(
                      'Next Tip',
                      style: _font(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: _accentBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({required Key key, required bool compact}) {
    return Card(
      key: key,
      elevation: 0,
      color: _cardWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: _skyBottom),
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? 22 : 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedMessage.title,
              style: _font(
                fontSize: compact ? 24 : 28,
                fontWeight: FontWeight.w700,
                color: _ink,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: compact ? 16 : 24),
            Text(
              _selectedMessage.explanation,
              style: _font(
                fontSize: compact ? 17 : 19,
                fontWeight: FontWeight.w700,
                color: _ink,
                height: 1.55,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: compact ? 20 : 28),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: _skyMid,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                _timerString,
                style: _font(
                  fontSize: _timeLeft <= 0 ? 16 : 22,
                  fontWeight: FontWeight.w700,
                  color: _mutedInk,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
