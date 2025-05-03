import 'package:jammies_app/models/post.dart';
import 'package:jammies_app/models/user.dart';

final List<Post> mockPosts = [
  Post(
    id: '1',
    title: 'Flutter is awesome',
    content: 'Waam',
    author: User(
      id: '1',
      name: 'John Doe',
      avatarUrl:
          'https://res.cloudinary.com/drdefvojb/image/upload/v1724779733/proyects_uv/k3o6eoted3lma2uzgbme.png',
      email: 'john.doe@example.com',
    ),
    createdAt: DateTime.now(),
    userId: '1',
    timestamp: DateTime.now().toString(),
    commentsCount: 0,
    likesCount: 0,
    imageUrl:
        'https://us-tuna-sounds-images.voicemod.net/aba1dc8c-862c-4b81-bffa-e59f1abb19db.jpg',

    isLikedByMe: false,
    track: null,
  ),
  Post(
    id: '2',
    title: '',
    content: 'Jamming',
    author: User(
      id: '2',
      name: 'Jane Doe',
      avatarUrl:
          'https://res.cloudinary.com/drdefvojb/image/upload/v1724779733/proyects_uv/k3o6eoted3lma2uzgbme.png',
      email: 'jane.doe@example.com',
    ),
    createdAt: DateTime.now(),
    userId: '2',
    timestamp: DateTime.now().toString(),
    commentsCount: 0,
    likesCount: 0,
    imageUrl:
        'https://media.tenor.com/D_F--PvRH4wAAAAe/pepe-listening-to-music.png',

    isLikedByMe: false,
    track: null,
  ),
  Post(
    id: '3',
    title: 'Flutter is awesome',
    content: 'idk',
    author: User(
      id: '3',
      name: 'John Doe',
      avatarUrl:
          'https://us-tuna-sounds-images.voicemod.net/1ff44856-704e-432b-a040-407b6128b10c-1677808295273.png',
      email: 'john.doe@example.com',
    ),
    createdAt: DateTime.now(),
    userId: '3',
    timestamp: DateTime.now().toString(),
    commentsCount: 0,
    likesCount: 0,
    imageUrl: null,

    isLikedByMe: false,
    track: null,
  ),
];
