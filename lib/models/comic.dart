import 'package:web_flut/models/library_item.dart';

class Comic extends LibraryItem {
  final String _type; // manga, manhwa, manhua
  final String _genre;
  final int _chapters;
  final int _currentChapter;
  final String _status; // ongoing, completed

  Comic({
    required String id,
    required String title,
    required String author,
    required String type,
    required String genre,
    required String summary,
    required int chapters,
    int currentChapter = 0,
    required String coverImageUrl,
    required String status,
    bool isReading = false,
    bool isFinished = false,
    required DateTime insertedAt,
  })  : _type = type,
        _genre = genre,
        _chapters = chapters,
        _currentChapter = currentChapter,
        _status = status,
        super(
          id: id,
          title: title,
          author: author,
          summary: summary,
          coverImageUrl: coverImageUrl,
          isReading: isReading,
          isFinished: isFinished,
          insertedAt: insertedAt,
        );

  // Getters for Komik-specific properties
  String get type => _type;
  String get genre => _genre;
  int get chapters => _chapters;
  int get currentChapter => _currentChapter;
  String get status => _status;

  // Calculate reading progress percentage
  double get progressPercentage =>
      chapters > 0 ? (currentChapter / chapters) : 0.0;

  @override
  Comic copyWith({
    String? id,
    String? title,
    String? author,
    String? type,
    String? genre,
    String? summary,
    int? chapters,
    int? currentChapter,
    String? coverImageUrl,
    String? status,
    bool? isReading,
    bool? isFinished,
    DateTime? insertedAt,
  }) {
    return Comic(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      type: type ?? this.type,
      genre: genre ?? this.genre,
      summary: summary ?? this.summary,
      chapters: chapters ?? this.chapters,
      currentChapter: currentChapter ?? this.currentChapter,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      status: status ?? this.status,
      isReading: isReading ?? this.isReading,
      isFinished: isFinished ?? this.isFinished,
      insertedAt: insertedAt ?? this.insertedAt,
    );
  }

  @override
  String getDetails() {
    return 'Komik: $title ($type) by $author, $genre, $chapters chapters, $status';
  }

  @override
  String getProgressText() {
    return '$currentChapter of $chapters chapters';
  }

  @override
  String getStatusText() {
    if (isFinished) return 'Finished';
    if (isReading) return 'Reading';
    return status; // Ongoing or Completed
  }
}
