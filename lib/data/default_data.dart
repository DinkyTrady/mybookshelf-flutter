import 'package:web_flut/models/language.dart';
import 'package:web_flut/models/genre.dart';
import 'package:web_flut/models/users/author.dart';
import 'package:web_flut/models/books/novel.dart';
import 'package:web_flut/models/books/light_novel.dart';
import 'package:web_flut/models/books/comic.dart';
import 'package:web_flut/models/books/comic_type.dart';

final defaultLanguages = [
  Language(id: '1', name: 'Indonesian', code: 'id'),
  Language(id: '2', name: 'English', code: 'en'),
  Language(id: '3', name: 'Japanese', code: 'ja'),
  Language(id: '4', name: 'Korean', code: 'ko'),
];

final defaultGenres = [
  Genre(id: '1', name: 'Fiction'),
  Genre(id: '2', name: 'Sci-Fi'),
  Genre(id: '3', name: 'Fantasy'),
  Genre(id: '4', name: 'Romance'),
  Genre(id: '5', name: 'Mystery'),
  Genre(id: '6', name: 'Slice of Life'),
  Genre(id: '7', name: 'Action'),
  Genre(id: '8', name: 'Adventure'),
  Genre(id: '9', name: 'Comedy'),
  Genre(id: '10', name: 'Drama'),
];

final defaultAuthors = [
  Author(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    biography: 'An aspiring author.',
    dateOfBirth: DateTime(1990, 1, 1),
  ),
  Author(
    id: '2',
    firstName: 'Jane',
    lastName: 'Smith',
    biography: 'A renowned author.',
    dateOfBirth: DateTime(1985, 5, 10),
  ),
];

final defaultBooks = [
  Novel(
    id: '1',
    title: 'The Great Novel',
    author: defaultAuthors[0],
    summary: 'A great novel about something.',
    coverImageUrl: 'https://via.placeholder.com/150/FFC107/000000?Text=Novel+1',
    pageCount: 300,
    currentPage: 150,
    isReading: true,
    language: defaultLanguages[1],
    genres: [defaultGenres[0], defaultGenres[2]],
  ),
  Novel(
    id: '2',
    title: 'Another Novel',
    author: defaultAuthors[1],
    summary: 'Another novel about something else.',
    coverImageUrl: 'https://via.placeholder.com/150/03A9F4/000000?Text=Novel+2',
    pageCount: 250,
    isFinished: true,
    language: defaultLanguages[1],
    genres: [defaultGenres[4]],
  ),
  LightNovel(
    id: '3',
    title: 'Light Novel Adventure',
    author: defaultAuthors[0],
    summary: 'A light novel about an adventure.',
    coverImageUrl: 'https://via.placeholder.com/150/4CAF50/000000?Text=LN+1',
    pageCount: 200,
    language: defaultLanguages[2],
    genres: [defaultGenres[7], defaultGenres[8]],
  ),
  LightNovel(
    id: '4',
    title: 'Slice of Life Light Novel',
    author: defaultAuthors[1],
    summary: 'A relaxing slice of life light novel.',
    coverImageUrl: 'https://via.placeholder.com/150/E91E63/000000?Text=LN+2',
    pageCount: 180,
    language: defaultLanguages[2],
    genres: [defaultGenres[5]],
  ),
  Comic(
    id: '5',
    title: 'Action Manga',
    author: defaultAuthors[0],
    summary: 'An action-packed manga.',
    coverImageUrl: 'https://via.placeholder.com/150/F44336/000000?Text=Manga+1',
    type: ComicType.manga,
    chapters: 100,
    currentChapter: 50,
    status: 'Ongoing',
    isReading: true,
    language: defaultLanguages[2],
    genres: [defaultGenres[6], defaultGenres[7]],
  ),
  Comic(
    id: '6',
    title: 'Romance Manhwa',
    author: defaultAuthors[1],
    summary: 'A sweet romance manhwa.',
    coverImageUrl:
        'https://via.placeholder.com/150/9C27B0/000000?Text=Manhwa+1',
    type: ComicType.manhwa,
    chapters: 80,
    status: 'Completed',
    isFinished: true,
    language: defaultLanguages[3],
    genres: [defaultGenres[3], defaultGenres[9]],
  ),
];
