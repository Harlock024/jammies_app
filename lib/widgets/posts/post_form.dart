import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jammies_app/mocks/mock_track.dart';

import 'package:jammies_app/models/track.dart';

import 'package:image_picker/image_picker.dart';

class PostForm extends StatefulWidget {
  const PostForm({super.key});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _controller = TextEditingController();
  Track? _selectedTrack;
  XFile? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  void _openTrackSearchDialog() async {
    final track = await showDialog<Track>(
      context: context,
      builder: (context) => SearchTrackDialog(),
    );

    if (track != null) {
      setState(() => _selectedTrack = track);
    }
  }

  void _submitPost() {
    final content = _controller.text.trim();

    if (content.isEmpty && _selectedTrack == null && _selectedImage == null)
      return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "¿Qué estás pensando?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _openTrackSearchDialog,
                icon: const Icon(Icons.music_note),
                label: const Text("Vincular canción"),
              ),
            ),
            if (_selectedTrack != null)
              _TrackPreview(
                track: _selectedTrack!,
                onRemove: () {
                  setState(() => _selectedTrack = null);
                },
              ),
            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Agregar imagen"),
              ),
            ),
            if (_selectedImage != null)
              Image.file(
                File(_selectedImage!.path),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: _submitPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF86CECB),
                  ),
                  child: const Text("Publicar"),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _TrackPreview extends StatelessWidget {
  final Track track;
  final VoidCallback onRemove;

  const _TrackPreview({required this.track, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Image.network(track.coverUrl, width: 48, height: 48),
        title: Text(track.title),
        subtitle: Text(track.artist),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onRemove,
        ),
      ),
    );
  }
}

class SearchTrackDialog extends StatelessWidget {
  const SearchTrackDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Buscar canción"),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: mockTracks.length,
          itemBuilder: (context, index) {
            final track = mockTracks[index];
            return ListTile(
              leading: Image.network(track.coverUrl, width: 48, height: 48),
              title: Text(track.title),
              subtitle: Text(track.artist),
              onTap: () => Navigator.pop(context, track),
            );
          },
        ),
      ),
    );
  }
}
