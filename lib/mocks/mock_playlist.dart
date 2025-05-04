import 'package:jammies_app/mocks/mock_user.dart';
import 'package:jammies_app/models/playlist.dart';

final List<Playlist> mockPlaylists = [
  Playlist(
    id: '1',
    name: 'My Playlist',
    createdBy: mockUsers[0],
    userId: mockUsers[0].id,
    description: 'My favorite songs',
    coverUrl:
        'https://i.pinimg.com/736x/27/b1/05/27b105523f4f52ce94aaa04056121b9a.jpg',
    trackCount: 10,
  ),
  Playlist(
    id: '2',
    name: 'My Playlist',
    createdBy: mockUsers[1],
    userId: mockUsers[1].id,
    description: 'My favorite songs',
    coverUrl:
        'https://i.pinimg.com/736x/94/0e/3f/940e3f55e575825a16f0a5fc2920af1a.jpg',
    trackCount: 15,
  ),
  Playlist(
    id: '3',
    name: 'My Playlist',
    createdBy: mockUsers[2],
    userId: mockUsers[2].id,
    description: 'My favorite songs',
    coverUrl:
        'https://i.pinimg.com/736x/17/e8/75/17e875941a230335da394f717beaddbe.jpg',
    trackCount: 20,
  ),
];
