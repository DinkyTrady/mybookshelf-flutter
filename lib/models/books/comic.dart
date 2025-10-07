import 'package:web_flut/models/books/base_book.dart';
import 'package:web_flut/models/users/author.dart';
import 'package:web_flut/models/genre.dart';
import 'package:web_flut/models/language.dart'; // Import Language
import 'package:web_flut/models/books/comic_type.dart';

class Comic extends BaseBook {
  Comic({
    required super.id,
    required super.title,
    required super.author,
    required super.summary,
    required super.coverImageUrl,
    required ComicType super.type,
    super.genres, // Changed to super.genres
    required super.chapters,
    super.currentChapter,
    required super.status,
    super.isReading,
    super.isFinished,
    super.updatedAt,
    super.language, // Added language
  });

  // Calculate reading progress percentage
  double get progressPercentage =>
      (chapters ?? 0) > 0 ? ((currentChapter ?? 0) / (chapters ?? 0)) : 0.0;

  @override
  Comic copyWith({
    // Changed return type to Comic
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
    ComicType? type,
    List<Genre>? genres, // Changed to List<Genre>
    int? chapters,
    int? currentChapter,
    String? status,
    Language? language, // Added language
  }) {
    return Comic(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      summary: summary ?? this.summary,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      type: type ?? this.type!,
      genres: genres ?? this.genres, // Changed to genres
      chapters: chapters ?? this.chapters,
      currentChapter: currentChapter ?? this.currentChapter,
      status: status ?? this.status,
      isReading: isReading ?? this.isReading,
      isFinished: isFinished ?? this.isFinished,
      updatedAt: updatedAt ?? this.updatedAt,
      language: language ?? this.language, // Added language
    );
  }

  @override
  String getDetails() {
    final genreNames = genres?.map((g) => g.name).join(', ') ?? 'N/A';
    String typeString = type?.toString().split('.').last ?? 'Comic';
    if (type == ComicType.manga) {
      typeString = 'Manga (Japanese Comic)';
    } else if (type == ComicType.manhwa) {
      typeString = 'Manhwa (Korean Comic)';
    } else if (type == ComicType.manhua) {
      typeString = 'Manhua (Chinese Comic)';
    }
    return '$typeString: $title by ${author.fullName}, Genres: $genreNames, ${chapters ?? 0} chapters, ${status ?? 'N/A'}';
  }

  @override
  String getProgressText() {
    return '${currentChapter ?? 0} of ${chapters ?? 0} chapters';
  }

  @override
  String getStatusText() {
    if (isFinished) return 'Finished';
    if (isReading) return 'Reading';
    return status ?? 'Not Started';
  }

  factory Comic.fromMap(Map<String, dynamic> map) {
    return Comic(
      id: map['id'],
      title: map['title'],
      author: Author.fromMap(map['author']), // Assuming Author has fromMap()
      summary: map['summary'],
      coverImageUrl: map['coverImageUrl'],
      type: ComicType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => ComicType.comic,
      ),
      genres: (map['genres'] as List<dynamic>?)
          ?.map((g) => Genre.fromMap(g))
          .toList(), // Assuming Genre has fromMap()
      chapters: map['chapters'],
      currentChapter: map['currentChapter'],
      status: map['status'],
      isReading: map['isReading'],
      isFinished: map['isFinished'],
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
      language: map['language'] != null
          ? Language.fromMap(map['language'])
          : null, // Assuming Language has fromMap()
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    // Comic-specific properties are already in BaseBook's toMap, so no need to add them again.
    return baseMap;
  }
}
