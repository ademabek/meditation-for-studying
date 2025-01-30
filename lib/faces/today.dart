import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petproject/cubit/meditation_cubit.dart';
import 'package:petproject/timermedi.dart';

class TodayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hi, Stephanie!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                  ),
                ),
              ).then(
                  (_) => context.read<MeditationCubit>().markCompleted(title));
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
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.music_note, size: 40, color: Colors.orange),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Podcast • 5 min",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
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
}
