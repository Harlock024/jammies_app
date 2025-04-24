import 'package:jammies_app/models/post.dart';
import 'package:jammies_app/models/user.dart';
import 'package:jammies_app/models/track.dart';

final List<Post> mockPosts = [
  Post(
    id: '1',
    title: 'Flutter is awesome',
    content:
        'Flutter is a powerful framework for building cross-platform apps.',
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
        'https://res.cloudinary.com/drdefvojb/image/upload/v1724779733/proyects_uv/k3o6eoted3lma2uzgbme.png',

    isLikedByMe: false,
    track: null,
  ),
  Post(
    id: '2',
    title: 'Dart is fun',
    content: 'Dart is a great language for building web and mobile apps.',
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
        'https://res.cloudinary.com/drdefvojb/image/upload/v1724779733/proyects_uv/k3o6eoted3lma2uzgbme.png',

    isLikedByMe: false,
    track: null,
  ),
  Post(
    id: '3',
    title: 'Flutter is awesome',
    content:
        'Flutter is a powerful framework for building cross-platform apps.',
    author: User(
      id: '3',
      name: 'John Doe',
      avatarUrl:
          'https://res.cloudinary.com/drdefvojb/image/upload/v1724779733/proyects_uv/k3o6eoted3lma2uzgbme.png',
      email: 'john.doe@example.com',
    ),
    createdAt: DateTime.now(),
    userId: '3',
    timestamp: DateTime.now().toString(),
    commentsCount: 0,
    likesCount: 0,
    imageUrl:
        'https://res.cloudinary.com/drdefvojb/image/upload/v1724779733/proyects_uv/k3o6eoted3lma2uzgbme.png',

    isLikedByMe: false,
    track: null,
  ),
];
