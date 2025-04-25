import 'package:flutter/material.dart';
import 'package:jammies_app/mocks/mock_album.dart';
import 'package:jammies_app/widgets/album/album_card.dart';

class AlbumGrid extends StatelessWidget {
  const AlbumGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(8),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 0.85,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: mockAlbums.map((album) => AlbumCard(album: album)).toList(),
    );
  }
}
