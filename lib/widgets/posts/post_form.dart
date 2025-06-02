import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/services/track_services.dart';
import 'package:jammies_app/services/post_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PostForm extends StatefulWidget {
  const PostForm({super.key});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _controller = TextEditingController();
  final PostService _postService = PostService();
  Track? _selectedTrack;
  XFile? _selectedImage;
  bool _isSubmitting = false;

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
      builder: (context) => const SearchTrackDialog(),
    );

    if (track != null) {
      setState(() => _selectedTrack = track);
    }
  }

  Future<void> _submitPost() async {
    final content = _controller.text.trim();

    if (content.isEmpty && _selectedTrack == null && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes agregar contenido, una imagen o una canción'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      http.MultipartFile? imageFile;
      if (_selectedImage != null) {
        imageFile = await http.MultipartFile.fromPath(
          'image',
          _selectedImage!.path,
        );
        print('Imagen seleccionada: ${_selectedImage!.path}');
      }

      print('Creando post con: "$content", trackId: ${_selectedTrack?.id}');

      await _postService.createPost(content, imageFile, _selectedTrack?.id);

      print('Post creado exitosamente');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post creado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Error al crear el post: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear el post: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              if (_selectedImage != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(_selectedImage!.path),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF86CECB),
                    ),
                    child:
                        _isSubmitting
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text("Publicar"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
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
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            track.coverUrl,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  width: 48,
                  height: 48,
                  color: Colors.grey[300],
                  child: const Icon(Icons.music_note, color: Colors.grey),
                ),
          ),
        ),
        title: Text(track.title),
        subtitle: Text('${track.postedBy} • ${track.album}'),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onRemove,
        ),
      ),
    );
  }
}

class SearchTrackDialog extends StatefulWidget {
  const SearchTrackDialog({super.key});

  @override
  State<SearchTrackDialog> createState() => _SearchTrackDialogState();
}

class _SearchTrackDialogState extends State<SearchTrackDialog> {
  final TrackService _trackService = TrackService();
  final TextEditingController _searchController = TextEditingController();
  List<Track> _tracks = [];
  List<Track> _filteredTracks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTracks();
    _searchController.addListener(_filterTracks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTracks() async {
    try {
      final tracks = await _trackService.fetchTracks();
      setState(() {
        _tracks = tracks;
        _filteredTracks = tracks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar las canciones: $e')),
        );
      }
    }
  }

  void _filterTracks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTracks =
          _tracks.where((track) {
            return track.title.toLowerCase().contains(query) ||
                track.postedBy.toLowerCase().contains(query) ||
                track.album.toLowerCase().contains(query);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Buscar canción"),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por título, artista o álbum...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredTracks.isEmpty
                      ? const Center(
                        child: Text(
                          'No se encontraron canciones',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: _filteredTracks.length,
                        itemBuilder: (context, index) {
                          final track = _filteredTracks[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                track.coverUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 48,
                                      height: 48,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.music_note,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                            ),
                            title: Text(track.title),
                            subtitle: Text(
                              '${track.postedBy} • ${track.album}',
                            ),
                            onTap: () => Navigator.pop(context, track),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
