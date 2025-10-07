import 'package:web_flut/models/books/base_book.dart';
import 'package:web_flut/models/users/author.dart';
import 'package:web_flut/models/genre.dart'; // Import Genre
import 'package:web_flut/models/language.dart'; // Import Language

class LightNovel extends BaseBook {
  LightNovel({
    required super.id,
    required super.title,
    required super.author,
    required super.summary,
    required super.coverImageUrl,
    required super.pageCount,
    super.currentPage,
    super.isReading,
    super.isFinished,
    super.updatedAt,
    super.genres, // Added genres
    super.language, // Added language
  });

  @override
  String getDetails() {
    return 'Light Novel: $title by ${author.fullName}, ${pageCount ?? 0} pages, Progress: ${(progressPercentage * 100).toStringAsFixed(1)}%';
  }

  @override
  String getProgressText() {
    return '${currentPage ?? 0} of ${pageCount ?? 0} pages';
  }

  double get progressPercentage =>
      (pageCount ?? 0) > 0 ? ((currentPage ?? 0) / (pageCount ?? 0)) : 0.0;

  @override
  LightNovel copyWith({
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
    List<Genre>? genres, // Added genres
    int? chapters,
    int? currentChapter,
    String? status,
    Language? language, // Added language
  }) {
    return LightNovel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      summary: summary ?? this.summary,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      pageCount: pageCount ?? this.pageCount,
      currentPage: currentPage ?? this.currentPage,
      isReading: isReading ?? this.isReading,
      isFinished: isFinished ?? this.isFinished,
      updatedAt: updatedAt ?? this.updatedAt,
      genres: genres ?? this.genres, // Added genres
      language: language ?? this.language, // Added language
    );
  }

  factory LightNovel.fromMap(Map<String, dynamic> map) {
    return LightNovel(
      id: map['id'],
      title: map['title'],
      author: Author.fromMap(map['author']), // Assuming Author has fromMap()
      summary: map['summary'],
      coverImageUrl: map['coverImageUrl'],
      pageCount: map['pageCount'],
      currentPage: map['currentPage'],
      isReading: map['isReading'],
      isFinished: map['isFinished'],
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
      genres: (map['genres'] as List<dynamic>?)
          ?.map((g) => Genre.fromMap(g))
          .toList(), // Assuming Genre has fromMap()
      language: map['language'] != null
          ? Language.fromMap(map['language'])
          : null, // Assuming Language has fromMap()
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    // LightNovel-specific properties are already in BaseBook's toMap, so no need to add them again.
    return baseMap;
  }
}
