import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

class MeditationTimerPage extends StatefulWidget {
  final String title;
  final int time;
  final VoidCallback onProgressStarted;

  const MeditationTimerPage({
    Key? key,
    required this.title,
    required this.time,
    required this.onProgressStarted,
  }) : super(key: key);

  @override
  State<MeditationTimerPage> createState() => _MeditationTimerPageState();
}

class _MeditationTimerPageState extends State<MeditationTimerPage> {
  late int remainingTime;
  bool isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isGuidePlaying = false;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.time * 60;
  }

  void startMeditation() {
    widget.onProgressStarted();

    setState(() {
      isPlaying = true;
    });
    _audioPlayer.play(
        'https://example.com/relaxing-music.mp3'); 
    startTimer();
  }

  void startTimer() {
    if (remainingTime > 0 && isPlaying) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          remainingTime--;
        });
        startTimer();
      });
    } else {
      setState(() {
        isPlaying = false;
      });
      _audioPlayer.stop();
    }
  }

  String getFormattedTime() {
    final minutes = remainingTime ~/ 60;
    final seconds = remainingTime % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void toggleGuideAudio() async {
    if (isGuidePlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(
          'https://example.com/how-to-meditate.mp3'); 
    }
    setState(() {
      isGuidePlaying = !isGuidePlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/meditation.json', 
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Guided by a short introductory course,\nstart trying meditation',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Text(
              getFormattedTime(),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isPlaying ? null : startMeditation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                isPlaying ? 'Meditation in Progress' : 'Start',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isGuidePlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 40,
                          color: Colors.teal,
                        ),
                        onPressed: toggleGuideAudio,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'How to meditate',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Text('15:29',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
