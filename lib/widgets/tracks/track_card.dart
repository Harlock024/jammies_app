import 'package:flutter/material.dart';
import 'package:jammies_app/models/playlist.dart';
import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/providers/audio_player.dart';
import 'package:jammies_app/services/favorite_track_service.dart';
import 'package:jammies_app/services/playlist_services.dart';
import 'package:provider/provider.dart';
import 'package:jammies_app/providers/queue_controller.dart';

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
    return Consumer<AudioController>(
      builder: (context, audioController, child) {
        final isCurrentTrack = audioController.currentTrack?.id == track.id;
        final isPlaying = isCurrentTrack && audioController.isPlaying;
        final isLoading = isCurrentTrack && audioController.currentlyLoading;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                context.read<AudioController>().selectTrack(track);
                if (onTap != null) onTap!();
              },
              child: Container(
                decoration: BoxDecoration(
                  color:
                      isCurrentTrack
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        isCurrentTrack
                            ? Colors.white.withOpacity(0.15)
                            : Colors.white.withOpacity(0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      _buildAlbumCover(isCurrentTrack, isLoading),
                      const SizedBox(width: 14),
                      Expanded(child: _buildTrackInfo(isCurrentTrack)),
                      const SizedBox(width: 12),
                      _buildActions(
                        context,
                        audioController,
                        isPlaying,
                        isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlbumCover(bool isCurrentTrack, bool isLoading) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              isCurrentTrack
                  ? Colors.white.withOpacity(0.2)
                  : Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Stack(
          children: [
            Image.network(
              track.coverUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    Icons.music_note,
                    color: Colors.white.withOpacity(0.6),
                    size: 30,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(9),
                  ),
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    ),
                  ),
                );
              },
            ),
            if (isCurrentTrack)
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : Icon(
                            Icons.graphic_eq,
                            color: Colors.white,
                            size: 24,
                          ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackInfo(bool isCurrentTrack) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          track.title,
          style: TextStyle(
            color:
                isCurrentTrack ? Colors.white : Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: isCurrentTrack ? FontWeight.w600 : FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          track.postedBy.toUpperCase(),
          style: TextStyle(
            color:
                isCurrentTrack
                    ? Colors.white.withOpacity(0.8)
                    : Colors.white.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 14,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(width: 4),
            Text(
              _formatDuration(track.duration),
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(
    BuildContext context,
    AudioController audioController,
    bool isPlaying,
    bool isLoading,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Play/Pause button
        _buildActionButton(
          onPressed:
              isLoading
                  ? null
                  : () {
                    if (isPlaying) {
                      audioController.pause();
                    } else {
                      audioController.play();
                      if (onPlay != null) onPlay!();
                    }
                  },
          icon:
              isLoading
                  ? Icons.hourglass_empty
                  : isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
          isPrimary: true,
        ),

        const SizedBox(width: 8),

        // Playlist button
        _buildActionButton(
          onPressed: () => _showPlaylistsDialog(context),
          icon: Icons.playlist_add,
          tooltip: 'Agregar a playlist',
        ),

        const SizedBox(width: 8),

        // Add to queue button
        _buildActionButton(
          onPressed: () {
            final queueController = Provider.of<QueueController>(context, listen: false);
            queueController.addToQueue(track);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${track.title} agregado a la cola')),
            );
          },
          icon: Icons.queue_music,
          tooltip: 'Agregar a la cola',
        ),

        const SizedBox(width: 8),

        // Favorite button
        FavoriteIconButton(track: track),

        // Delete button (solo si está en playlist)
        if (playlistId != null) ...[
          const SizedBox(width: 8),
          _buildActionButton(
            onPressed: () => _confirmDelete(context),
            icon: Icons.delete_outline,
            tooltip: 'Eliminar de playlist',
            color: Colors.red.withOpacity(0.7),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required IconData icon,
    String? tooltip,
    bool isPrimary = false,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: isPrimary ? 36 : 32,
        height: isPrimary ? 36 : 32,
        decoration: BoxDecoration(
          color:
              isPrimary
                  ? Colors.white.withOpacity(0.15)
                  : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(isPrimary ? 18 : 16),
          border:
              isPrimary
                  ? Border.all(color: Colors.white.withOpacity(0.2), width: 1)
                  : null,
        ),
        child: Icon(
          icon,
          size: isPrimary ? 20 : 18,
          color: color ?? Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Eliminar track',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              '¿Quieres eliminar este track de la playlist?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.2),
                ),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm == true && playlistId != null) {
      try {
        await PlaylistServices().removeTrackFromPlaylist(playlistId!, track.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Track eliminado de la playlist'),
            backgroundColor: Colors.green.withOpacity(0.8),
          ),
        );
        if (onRemoved != null) onRemoved!();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar track: $e'),
            backgroundColor: Colors.red.withOpacity(0.8),
          ),
        );
      }
    }
  }

  void _showPlaylistsDialog(BuildContext context) async {
    try {
      final playlists = await PlaylistServices().fetchUserPlaylists();

      if (playlists.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No tienes playlists para agregar.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final selectedPlaylist = await showDialog<Playlist>(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Selecciona una playlist',
              style: TextStyle(color: Colors.white),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        playlist.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () => Navigator.of(context).pop(playlist),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar playlists: $e'),
          backgroundColor: Colors.red.withOpacity(0.8),
        ),
      );
    }
  }

  Future<void> _addTrackToPlaylist(
    BuildContext context,
    String playlistId,
  ) async {
    try {
      await PlaylistServices().addTrackToPlaylist(playlistId, track.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Track agregado a la playlist'),
          backgroundColor: Colors.green.withOpacity(0.8),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agregar track: $e'),
          backgroundColor: Colors.red.withOpacity(0.8),
        ),
      );
    }
  }
}

String _formatDuration(double duration) {
  final int minutes = duration ~/ 60;
  final int seconds = duration.toInt().remainder(60);
  return '${minutes}:${seconds.toString().padLeft(2, '0')}';
}

class FavoriteIconButton extends StatefulWidget {
  final Track track;

  const FavoriteIconButton({super.key, required this.track});

  @override
  State<FavoriteIconButton> createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<FavoriteIconButton>
    with SingleTickerProviderStateMixin {
  late bool isFavorite;
  final _favoriteService = FavoriteTrackService();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.track.isFavorite;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFavorite() async {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

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
        SnackBar(
          content: Text('Error al actualizar favorito: $e'),
          backgroundColor: Colors.red.withOpacity(0.8),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color:
              isFavorite
                  ? Colors.red.withOpacity(0.15)
                  : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border:
              isFavorite
                  ? Border.all(color: Colors.red.withOpacity(0.3), width: 1)
                  : null,
        ),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color:
                    isFavorite
                        ? Colors.red.withOpacity(0.9)
                        : Colors.white.withOpacity(0.8),
                size: 18,
              ),
            );
          },
        ),
      ),
    );
  }
}

// Versión compacta para listas pequeñas
class TrackCardCompact extends StatelessWidget {
  final Track track;
  final VoidCallback? onTap;

  const TrackCardCompact({super.key, required this.track, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioController>(
      builder: (context, audioController, child) {
        final isCurrentTrack = audioController.currentTrack?.id == track.id;
        final isPlaying = isCurrentTrack && audioController.isPlaying;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                context.read<AudioController>().selectTrack(track);
                if (onTap != null) onTap!();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isCurrentTrack
                          ? const Color(0xFF2A2A2A)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      isCurrentTrack
                          ? Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          )
                          : null,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        track.coverUrl,
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 45,
                            height: 45,
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.white70,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.title,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            track.postedBy.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (isCurrentTrack)
                      Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
