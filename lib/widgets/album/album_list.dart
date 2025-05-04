import 'package:flutter/material.dart';
import 'package:jammies_app/mocks/mock_album.dart';
import 'package:jammies_app/widgets/album/album_card.dart';

class AlbumGrid extends StatelessWidget {
  const AlbumGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.80,
                ),
                itemCount: mockAlbums.length,
                itemBuilder: (context, index) {
                  return AlbumCard(album: mockAlbums[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
