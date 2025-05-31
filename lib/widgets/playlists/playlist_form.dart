import 'package:flutter/material.dart';
import 'package:jammies_app/models/playlist.dart';
import 'package:jammies_app/services/playlist_services.dart';

class PlaylistForm extends StatefulWidget {
  const PlaylistForm({super.key});

  @override
  _PlaylistFormState createState() => _PlaylistFormState();
}

class _PlaylistFormState extends State<PlaylistForm> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = false;
  final PlaylistServices _playlistServices = PlaylistServices();

  void _onTextChanged(String value) {
    setState(() {
      _isButtonEnabled = value.trim().isNotEmpty;
    });
  }

  void _createPlaylist() {
    final playlistName = _controller.text.trim();
    if (playlistName.isEmpty) {
      return;
    }

    final playlist = _playlistServices.createPlaylist(playlistName);
    if (playlist is Playlist) {
      print('Playlist creada $playlist');
    }

    Navigator.pop(context, playlistName);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Crear nueva playlist',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Nombre de la playlist',
              border: OutlineInputBorder(),
            ),
            onChanged: _onTextChanged,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isButtonEnabled ? _createPlaylist : null,
              child: const Text('Crear'),
            ),
          ),
        ],
      ),
    );
  }
}
