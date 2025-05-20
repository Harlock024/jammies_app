import 'package:jammies_app/models/track.dart';

final List<Track> createdTracks = [
  Track(
    id: '1',
    title: 'Mi Canción 1',
    artist: 'Yo',
    album: 'Mi Álbum',
    duration: 3.45,
    coverUrl: 'https://via.placeholder.com/150',
    audioUrl: '',
  ),
  Track(
    id: '2',
    title: 'Mi Canción 2',
    artist: 'Yo',
    album: 'Mi Álbum',
    duration: 2.30,
    coverUrl: 'https://via.placeholder.com/150',
    audioUrl: '',
  ),
];

final List<Track> savedTracks = [
  Track(
    id: '3',
    title: 'Track Favorito',
    artist: 'Otro Artista',
    album: 'Top Hits',
    duration: 4.00,
    coverUrl: 'https://via.placeholder.com/150',
    audioUrl: '',
  ),
];
