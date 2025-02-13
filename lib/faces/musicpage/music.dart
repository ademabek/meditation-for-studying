import 'dart:async';

import 'package:flutter/material.dart';

class MusicPlayerPage extends StatefulWidget {
  final String title;
  final String description;

  MusicPlayerPage({required this.title, required this.description});

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  double _currentPosition = 0.0;
  bool _isPlaying = false;
  late Timer _timer;
  late int _remainingTimeInSeconds;
  int _totalTimeInSeconds = 3600;

  @override
  void initState() {
    super.initState();
    _setTotalTime(widget.description);
    _remainingTimeInSeconds = _totalTimeInSeconds;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _setTotalTime(String description) {
    RegExp regex = RegExp(r'(\d+)\s*min');
    Match? match = regex.firstMatch(description);
    if (match != null) {
      _totalTimeInSeconds = int.parse(match.group(1)!) * 60;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTimeInSeconds > 0 && _isPlaying) {
        setState(() {
          _remainingTimeInSeconds--;
          _currentPosition = (_totalTimeInSeconds - _remainingTimeInSeconds) /
              _totalTimeInSeconds;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _playPauseMusic() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      _startTimer();
    } else {
      _timer.cancel();
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Now Playing"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.deepPurple.withOpacity(0.1),
              child: const Icon(
                Icons.music_note,
                size: 80,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 30),
            Slider(
              value: _currentPosition,
              min: 0.0,
              max: 1.0,
              onChanged: (value) {},
              activeColor: Colors.deepPurple,
              inactiveColor: Colors.grey.shade300,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(_totalTimeInSeconds - _remainingTimeInSeconds),
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  _formatTime(_totalTimeInSeconds),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 40),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    size: 60,
                    color: Colors.deepPurple,
                  ),
                  onPressed: _playPauseMusic,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 40),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Stay focused and keep going.\nGreat things take time!",
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
