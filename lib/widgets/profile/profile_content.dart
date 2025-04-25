import 'package:flutter/material.dart';
import 'package:jammies_app/widgets/playlists/playlist_list.dart';
import 'package:jammies_app/widgets/posts/post_list.dart';
import 'package:jammies_app/widgets/tracks/tracks_list.dart';

class ProfileContentTabs extends StatefulWidget {
  const ProfileContentTabs({super.key});

  @override
  State<ProfileContentTabs> createState() => _ProfileContentTabsState();
}

class _ProfileContentTabsState extends State<ProfileContentTabs>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(text: "Posts"),
    Tab(text: "Tracks"),
    Tab(text: "Playlists"),
    Tab(text: "Albums"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: _tabs,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: [
              _PostsTab(),
              _TracksTab(),
              _PlaylistsTab(),
              _AlbumsTab(),
            ],
          ),
        ),
      ],
    );
  }
}

class _PostsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PostList();
  }
}

class _TracksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TracksList();
  }
}

class _PlaylistsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaylistGrid();
  }
}

class _AlbumsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Álbumes del usuario"));
  }
}
