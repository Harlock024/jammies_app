import 'package:flutter/material.dart';
import 'package:jammies_app/models/playlist.dart';
import 'package:jammies_app/models/track.dart';
import 'package:jammies_app/services/favorite_track_service.dart';
import 'package:jammies_app/services/playlist_services.dart';
import 'package:jammies_app/widgets/playlists/playlist_card.dart';
import 'package:jammies_app/widgets/playlists/playlist_form.dart';
import 'package:jammies_app/widgets/tracks/track_card.dart';

enum LibraryCategory { tracks, albums, playlists }

enum LibraryFilter { created, saved }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final FavoriteTrackService _favoriteTrackService = FavoriteTrackService();
  final PlaylistServices _playlistService = PlaylistServices();

  LibraryFilter _filter = LibraryFilter.created;

  List<Track> tracks = [];
  List<Playlist> playlists = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // 🔁 Listener para actualizar el AppBar cuando cambia la pestaña
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    _fetchTracks();
    _fetchPlaylists();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchTracks() async {
    final fetchedTracks = await _favoriteTrackService.fetchFavoriteTracks();
    setState(() {
      tracks = fetchedTracks;
    });
  }

  Future<void> _fetchPlaylists() async {
    final fetchedPlaylists = await _playlistService.fetchPlaylists();
    setState(() {
      playlists = fetchedPlaylists;
    });
  }

  void _onFilterChanged(LibraryFilter filter) {
    setState(() {
      _filter = filter;
    });
    _fetchTracks();
    _fetchPlaylists();
  }

  void _showCreatePlaylistModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const PlaylistForm(),
    ).then((result) {
      if (result != null && result is String) {
        print('Playlist creada: $result');
        _fetchPlaylists();
      }
    });
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8,
        children:
            LibraryFilter.values.map((f) {
              final isSelected = f == _filter;
              return ChoiceChip(
                label: Text(
                  f == LibraryFilter.created ? 'Creados por mí' : 'Guardados',
                ),
                selected: isSelected,
                onSelected: (_) => _onFilterChanged(f),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildTabContent(LibraryCategory category) {
    switch (category) {
      case LibraryCategory.tracks:
        return tracks.isEmpty
            ? const Center(child: Text('No hay tracks para mostrar'))
            : ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) => TrackCard(track: tracks[index]),
            );

      case LibraryCategory.playlists:
        return playlists.isEmpty
            ? const Center(child: Text('No hay playlists para mostrar'))
            : ListView.builder(
              itemCount: playlists.length,
              itemBuilder:
                  (context, index) => PlaylistCard(playlist: playlists[index]),
            );

      case LibraryCategory.albums:
        final label =
            _filter == LibraryFilter.created ? 'creados' : 'guardados';
        return Center(
          child: Text(
            'Álbumes $label',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPlaylistsTab = _tabController.index == 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Biblioteca"),
        actions: [
          if (isPlaylistsTab)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Nueva playlist',
              onPressed: _showCreatePlaylistModal,
              color: Theme.of(context).colorScheme.primary,
              iconSize: 24,
            ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Tracks'),
              Tab(text: 'Álbumes'),
              Tab(text: 'Playlists'),
            ],
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
          _buildFilterChips(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent(LibraryCategory.tracks),
                _buildTabContent(LibraryCategory.albums),
                _buildTabContent(LibraryCategory.playlists),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
