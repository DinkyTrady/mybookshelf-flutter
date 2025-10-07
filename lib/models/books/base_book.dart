import 'package:web_flut/models/base.dart';
import 'package:web_flut/models/users/author.dart';
import 'package:web_flut/models/genre.dart';
import 'package:web_flut/models/language.dart'; // Import Language model
import 'package:web_flut/models/books/comic_type.dart';

abstract class BaseBook extends Base {
  final String _title;
  final Author _author;
  final String _summary;
  final String _coverImageUrl;
  final bool _isReading;
  final bool _isFinished;

  // Book-specific properties
  final int? _pageCount;
  final int? _currentPage;

  // Comic-specific properties
  final ComicType? _type; // manga, manhwa, manhua
  final List<Genre>? _genres; // Changed to List<Genre>
  final int? _chapters;
  final int? _currentChapter;
  final String? _status; // ongoing, completed

  final Language? _language; // Added language property

  BaseBook({
    required super.id,
    required String title,
    required Author author,
    required String summary,
    required String coverImageUrl,
    bool isReading = false,
    bool isFinished = false,
    super.updatedAt,
    // Book-specific
    int? pageCount,
    int? currentPage,
    // Comic-specific
    ComicType? type,
    List<Genre>? genres, // Changed to List<Genre>
    int? chapters,
    int? currentChapter,
    String? status,
    // Language
    Language? language, // Added language parameter
  }) : _title = title,
       _author = author,
       _summary = summary,
       _coverImageUrl = coverImageUrl,
       _isReading = isReading,
       _isFinished = isFinished,
       _pageCount = pageCount,
       _currentPage = currentPage,
       _type = type,
       _genres = genres, // Changed to _genres
       _chapters = chapters,
       _currentChapter = currentChapter,
       _status = status,
       _language = language; // Assigned language

  // Getters
  String get title => _title;
  Author get author => _author;
  String get summary => _summary;
  bool get isReading => _isReading;
  bool get isFinished => _isFinished;
  String get coverImageUrl => _coverImageUrl;

  int? get pageCount => _pageCount;
  int? get currentPage => _currentPage;

  ComicType? get type => _type;
  List<Genre>? get genres => _genres; // Changed to genres
  int? get chapters => _chapters;
  int? get currentChapter => _currentChapter;
  String? get status => _status;

  Language? get language => _language; // Added language getter

  // Abstract methods
  String getDetails();
  String getProgressText();
  String getStatusText() {
    if (isFinished) return 'Finished';
    if (isReading) return 'Reading';
    return 'Not Started';
  }

  BaseBook copyWith({
    String? id,
    String? title,
    Author? author,
    String? summary,
    String? coverImageUrl,
    bool? isReading,
    bool? isFinished,
    DateTime? updatedAt,
    int? pageCount,
    int? currentPage,
    List<Genre>? genres, // Changed to List<Genre>
    int? chapters,
    int? currentChapter,
    String? status,
    Language? language, // Added language parameter
  });

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'title': _title,
      'author': _author.toMap(), // Assuming Author has toMap()
      'summary': _summary,
      'coverImageUrl': _coverImageUrl,
      'isReading': _isReading,
      'isFinished': _isFinished,
      'pageCount': _pageCount,
      'currentPage': _currentPage,
      'type': _type?.toString().split('.').last,
      'genres': _genres
          ?.map((g) => g.toMap())
          .toList(), // Assuming Genre has toMap()
      'chapters': _chapters,
      'currentChapter': _currentChapter,
      'status': _status,
      'language': _language?.toMap(), // Assuming Language has toMap()
    });
    return baseMap;
  }

  factory BaseBook.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError('fromMap() must be implemented in subclasses');
  }
}
