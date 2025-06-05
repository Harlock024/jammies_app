import 'package:flutter/material.dart';
import 'package:jammies_app/providers/audio_player.dart';
import 'package:jammies_app/providers/queue_controller.dart';
import 'package:provider/provider.dart';

class QueueModal extends StatelessWidget {
  const QueueModal({super.key});

  @override
  Widget build(BuildContext context) {
    final queueController = context.watch<QueueController>();
    final audioController = context.read<AudioController>();

    return Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cola de reproducción",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: queueController.queue.length,
              itemBuilder: (context, index) {
                final track = queueController.queue[index];
                final isCurrent = queueController.current == track;

                return ListTile(
                  title: Text(
                    track.title,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    track.postedBy,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  selected: isCurrent,
                  leading:
                      isCurrent
                          ? Icon(Icons.equalizer, color: Colors.green)
                          : Icon(Icons.music_note, color: Colors.white),
                  onTap: () {
                    queueController.playAt(index);
                    audioController.playCurrentFromQueue();
                    Navigator.of(context).pop();
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.close, color: Colors.redAccent),
                    onPressed: () {
                      queueController.removeFromQueue(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
