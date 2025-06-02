import 'package:flutter/material.dart';
import 'package:jammies_app/models/playlist.dart';
import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/providers/audio_player.dart';
import 'package:jammies_app/services/favorite_track_service.dart';
import 'package:jammies_app/services/playlist_services.dart';
import 'package:provider/provider.dart';

class TrackCard extends StatelessWidget {
  final Track track;
  final String? playlistId;
  final VoidCallback? onTap;
  final VoidCallback? onPlay;
  final VoidCallback? onRemoved;

  const TrackCard({
    super.key,
    required this.track,
    this.playlistId,
    this.onTap,
    this.onPlay,
    this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<AudioController>().selectTrack(track);
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  track.coverUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      track.postedBy.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDuration(track.duration),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.play_arrow), onPressed: onPlay),
              IconButton(
                icon: const Icon(Icons.playlist_add),
                tooltip: 'Agregar a playlist',
                onPressed: () => _showPlaylistsDialog(context),
              ),
              FavoriteIconButton(track: track),
              if (playlistId != null)
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Eliminar de playlist',
                  onPressed: () => _confirmDelete(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Eliminar track'),
            content: const Text('¿Quieres eliminar este track de la playlist?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );

    if (confirm == true && playlistId != null) {
      try {
        await PlaylistServices().removeTrackFromPlaylist(playlistId!, track.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Track eliminado de la playlist')),
        );
        if (onRemoved != null) onRemoved!();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al eliminar track: $e')));
      }
    }
  }

  void _showPlaylistsDialog(BuildContext context) async {
    try {
      final playlists = await PlaylistServices().fetchUserPlaylists();

      if (playlists.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No tienes playlists para agregar.')),
        );
        return;
      }

      final selectedPlaylist = await showDialog<Playlist>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Selecciona una playlist'),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  return ListTile(
                    title: Text(playlist.name),
                    onTap: () => Navigator.of(context).pop(playlist),
                  );
                },
              ),
            ),
          );
        },
      );

      if (selectedPlaylist != null) {
        await _addTrackToPlaylist(context, selectedPlaylist.id);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar playlists: $e')));
    }
  }

  Future<void> _addTrackToPlaylist(
    BuildContext context,
    String playlistId,
  ) async {
    try {
      await PlaylistServices().addTrackToPlaylist(playlistId, track.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Track agregado a la playlist')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al agregar track: $e')));
    }
  }
}

String _formatDuration(double duration) {
  final int minutes = duration ~/ 60;
  final int seconds = duration.toInt().remainder(60);
  return '$minutes min ${seconds.toString().padLeft(2, '0')} sec';
}

class FavoriteIconButton extends StatefulWidget {
  final Track track;

  const FavoriteIconButton({super.key, required this.track});

  @override
  State<FavoriteIconButton> createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<FavoriteIconButton> {
  late bool isFavorite;
  final _favoriteService = FavoriteTrackService();

  @override
  void initState() {
    super.initState();
    isFavorite = widget.track.isFavorite;
  }

  void _toggleFavorite() async {
    try {
      setState(() => isFavorite = !isFavorite);

      if (isFavorite) {
        await _favoriteService.addTrackToFavorite(widget.track.id);
      } else {
        await _favoriteService.removeTrackToFavorite(widget.track.id);
      }
    } catch (e) {
      setState(() => isFavorite = !isFavorite);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar favorito: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
      ),
      tooltip: isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
      onPressed: _toggleFavorite,
    );
  }
}
