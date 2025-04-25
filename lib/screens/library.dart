import 'package:flutter/material.dart';

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
  LibraryFilter _filter = LibraryFilter.created;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                onSelected: (_) {
                  setState(() {
                    _filter = f;
                  });
                },
              );
            }).toList(),
      ),
    );
  }

  Widget _buildTabContent(LibraryCategory category) {
    String label;
    switch (category) {
      case LibraryCategory.tracks:
        label = 'Tracks';
        break;
      case LibraryCategory.albums:
        label = 'Álbumes';
        break;
      case LibraryCategory.playlists:
        label = 'Playlists';
        break;
    }
    return Center(
      child: Text(
        '$label ${_filter == LibraryFilter.created ? "creados" : "guardados"}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mi Biblioteca")),
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
