import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'xecho - Stress Relief App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _cloudButtonVisible = true;
  String? _selectedMessage;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Random _random = Random();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playRandomSound() async {
    try {
      final sounds = ['beep.mp3', 'boop.mp3'];
      final selectedSound = sounds[_random.nextInt(sounds.length)];
      await _audioPlayer.setReleaseMode(ReleaseMode.release);
      await _audioPlayer.play(AssetSource(selectedSound));
    } catch (e) {
      // Handle error silently or show a message
      debugPrint('Error playing sound: $e');
    }
  }

  void _incrementCounter() {
    _playRandomSound();
    setState(() {
      _counter++;
    });
  }

  void _onCloudButtonPressed() {
    final messages = [
      'Please try square breathing',
      'Stare at a wall for three minutes',
      'Please try micro-meditation',
      'Please try 4-7-8 breathing',
    ];
    
    setState(() {
      _cloudButtonVisible = false;
      _selectedMessage = messages[_random.nextInt(messages.length)];
    });
  }

  void _goBack() {
    setState(() {
      _cloudButtonVisible = true;
      _selectedMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!_cloudButtonVisible && _selectedMessage != null) ...[
              Text(
                _selectedMessage!,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _goBack,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ]
            else ...[
              const Text(
                'Welcome to xecho',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your stress relief companion',
              ),
              const SizedBox(height: 60),
              // Cloud-shaped button
              Material(
                color: Colors.white,
                elevation: 4,
                shadowColor: Colors.black26,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: _onCloudButtonPressed,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      painter: CloudPainter(),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Custom painter for cloud shape
class CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Draw cloud shape using circles
    // Main body
    path.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.4, size.height * 0.5),
      radius: size.width * 0.25,
    ));
    
    // Left puff
    path.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.25, size.height * 0.6),
      radius: size.width * 0.2,
    ));
    
    // Right puff
    path.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.6, size.height * 0.6),
      radius: size.width * 0.2,
    ));
    
    // Top puff
    path.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.5, size.height * 0.35),
      radius: size.width * 0.18,
    ));
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

