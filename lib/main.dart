import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

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
      title: 'xecho',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE6E6FA), // Lavender seed
          primary: const Color(0xFF6A5ACD),   // Slate Blue
          secondary: const Color(0xFF9370DB), // Medium Purple
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.nunitoTextTheme(),
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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  int _counter = 0;
  bool _cloudButtonVisible = true;
  MentalHealthTip? _selectedMessage;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Random _random = Random();
  Timer? _timer;
  int _timeLeft = 180; // 3 minutes in seconds
  int _rating = 0;
  bool _isHoveringCloud = false;
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    
    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
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

  void _incrementCounter() {
    _playRandomSound();
    setState(() {
      _counter++;
    });
  }

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
      _rating = 0; // Reset rating
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
      _rating = 0; // Reset rating
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _cloudButtonVisible
          ? AppBar(
              forceMaterialTransparency: true,
              backgroundColor: Colors.transparent,
              title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: true,
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF0F4F8), // Pale blue/grey
              Color(0xFFE6E6FA), // Lavender
            ],
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _cloudButtonVisible
                ? _buildHomeView()
                : _buildTipView(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHomeView() {
    return Column(
      key: const ValueKey('HomeView'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Welcome to xecho',
          style: TextStyle(
            fontSize: 36, 
            fontWeight: FontWeight.w900, 
            color: Colors.black87,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Your stress relief companion',
          style: TextStyle(fontSize: 18, color: Colors.grey[700], letterSpacing: 0.5),
        ),
        const SizedBox(height: 60),
        // Cloud-shaped button with Glow and Animation
        Stack(
          alignment: Alignment.center,
          children: [
            // Glow effect
            ScaleTransition(
              scale: _breathingAnimation,
              child: Container(
                width: 280,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Approximate since it's a blob, but circle/box showing shadow works
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.6),
                      blurRadius: 60,
                      spreadRadius: 20,
                    ),
                    BoxShadow(
                      color: const Color(0xFFE6E6FA).withOpacity(0.5), // Lavender glow
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
            // Floating & Breathing Cloud
            SlideTransition(
              position: Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.05)).animate(
                CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
              ),
              child: ScaleTransition(
                scale: _breathingAnimation,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _isHoveringCloud = true),
                  onExit: (_) => setState(() => _isHoveringCloud = false),
                  child: GestureDetector(
                    onTap: _onCloudButtonPressed,
                    child: SizedBox(
                      width: 320, // Much bigger
                      height: 220,
                      child: Image.asset(
                        'assets/cloud.png',
                        fit: BoxFit.contain,
                        color: _isHoveringCloud ? Colors.white : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Text(
          'Tap the cloud',
          style: TextStyle(color: Colors.grey[500], fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildTipView() {
    return Container(
      key: ValueKey(_selectedMessage?.title ?? 'TipView'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 8,
            shadowColor: Colors.black12,
            color: Colors.white.withOpacity(0.9), // Glassmorphism-ish
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedMessage!.title,
                    style: TextStyle(
                      fontSize: 26, 
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _selectedMessage!.explanation,
                    style: const TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _timerString,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Rate this activity',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () => _setRating(index + 1),
                        icon: Icon(
                          index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: const Color(0xFFFFB74D), // Soft Amber
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
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.tonalIcon(
                onPressed: _goBack,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Back'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(width: 16),
              FilledButton.icon(
                onPressed: _showNextTip,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Next Tip'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

