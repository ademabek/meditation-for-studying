import 'package:flutter/material.dart';

class MeditationTimerPage extends StatefulWidget {
  final String title;
  final int time;

  MeditationTimerPage({required this.title, required this.time});

  @override
  _MeditationTimerPageState createState() => _MeditationTimerPageState();
}

class _MeditationTimerPageState extends State<MeditationTimerPage> {
  late int remainingMinutes;
  late int totalMinutes;
  double progress = 1.0;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    remainingMinutes = widget.time;
    totalMinutes = widget.time;
  }

  void _startTimer() {
    setState(() {
      isRunning = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (isRunning && remainingMinutes > 0) {
        setState(() {
          remainingMinutes--;
          progress = remainingMinutes / totalMinutes;
        });
        _startTimer();
      } else {
        setState(() {
          isRunning = false;
        });
      }
    });
  }

  void _stopTimer() {
    setState(() {
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade300,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Remaining",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      "$remainingMinutes min",
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Turn off",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Switch(
                  value: isRunning,
                  onChanged: (value) {
                    if (value) {
                      _startTimer();
                    } else {
                      _stopTimer();
                    }
                  },
                  activeColor: Colors.deepPurple,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Focus on your breathing.\nRelax and let go of distractions.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
