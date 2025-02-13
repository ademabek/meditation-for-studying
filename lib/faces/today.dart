import 'package:flutter/material.dart';
import 'package:petproject/faces/meditation/meditation-timer.dart';
import 'package:petproject/faces/profile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petproject/studypage/data/meditation_cubit.dart';
import 'package:petproject/auth/data/profile-provider.dart';
import 'package:just_audio/just_audio.dart'; // Add this package to your pubspec.yaml

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentPlayingAudio;

  final Map<String, String> _audioFiles = {
    'General Anxiety': 'assets/firstpage.mp3',
    'Follow the Breath': 'assets/firstpage.mp3',
    'Stress and Sleep': 'assets/firstpage.mp3',
    'Lavender Fields': 'assets/firstpage.mp3',
  };

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            icon: const Icon(Icons.account_circle, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, ${profile.name.isNotEmpty ? profile.name : '...'}!",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Choose what you want to do today.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _buildMeditationOptions(),
            const SizedBox(height: 20),
            const Text(
              "Relax Playlist",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildMeditationList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildMeditationOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _optionButton(Icons.cloud, "Relax"),
        _optionButton(Icons.spa, "Meditate"),
        _optionButton(Icons.fitness_center, "Health"),
        _optionButton(Icons.nature_people, "Mindful"),
      ],
    );
  }

  Widget _optionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.orange,
          radius: 30,
          child: Icon(icon, size: 30, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMeditationList(BuildContext context) {
    final cubit = context.read<MeditationCubit>();

    return BlocBuilder<MeditationCubit, Map<String, bool>>(
      builder: (context, completedSessions) {
        final meditations = [
          "General Anxiety",
          "Follow the Breath",
          "Stress and Sleep",
          "Lavender Fields",
        ];

        return ListView.builder(
          itemCount: meditations.length,
          itemBuilder: (context, index) {
            final title = meditations[index];
            final isCompleted = cubit.isCompleted(title);

            return _buildMeditationCard(context, title, isCompleted);
          },
        );
      },
    );
  }

  Widget _buildMeditationCard(
      BuildContext context, String title, bool isCompleted) {
    return GestureDetector(
      onTap: isCompleted
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeditationTimerPage(
                    title: title,
                    time: 5,
                    onProgressStarted: () {
                      context.read<MeditationCubit>().markCompleted(title);
                    },
                  ),
                ),
              );
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isCompleted ? Colors.grey.shade300 : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.music_note, size: 40, color: Colors.orange),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(
                  _currentPlayingAudio == title
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  color: Colors.blue,
                ),
                onPressed: () => _playMeditationAudio(title),
              ),
              isCompleted
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.play_arrow),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _playMeditationAudio(String title) async {
    if (_currentPlayingAudio == title) {
      await _audioPlayer.pause();
      setState(() {
        _currentPlayingAudio = null;
      });
    } else {
      await _audioPlayer.stop();

      final audioPath = _audioFiles[title];
      if (audioPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Audio file not found')),
        );
        return;
      }

      try {
        print('Playing audio: $audioPath');
        await _audioPlayer.setAsset(audioPath);
        await _audioPlayer.play();

        setState(() {
          _currentPlayingAudio = title;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing audio: $e')),
        );
      }
    }
  }
}
