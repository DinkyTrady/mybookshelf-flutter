import 'package:web_flut/models/library_item.dart';

class Book extends LibraryItem {
  final int _pageCount;
  final int _currentPage;

  Book({
    required String id,
    required String title,
    required String author,
    required String summary,
    required String coverImageUrl,
    required int pageCount,
    int currentPage = 0,
    bool isReading = false,
    bool isFinished = false,
    required DateTime insertedAt,
  })  : _pageCount = pageCount,
        _currentPage = currentPage,
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

  // Getters for Book-specific properties
  int get pageCount => _pageCount;
  int get currentPage => _currentPage;

  // Calculate reading progress percentage
  double get progressPercentage =>
      pageCount > 0 ? (currentPage / pageCount) : 0.0;

  @override
  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? summary,
    String? coverImageUrl,
    int? pageCount,
    int? currentPage,
    bool? isReading,
    bool? isFinished,
    DateTime? insertedAt,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      summary: summary ?? this.summary,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      pageCount: pageCount ?? this.pageCount,
      currentPage: currentPage ?? this.currentPage,
      isReading: isReading ?? this.isReading,
      isFinished: isFinished ?? this.isFinished,
      insertedAt: insertedAt ?? this.insertedAt,
    );
  }

  @override
  String getDetails() {
    return 'Book: $title by $author, $pageCount pages, Progress: ${(progressPercentage * 100).toStringAsFixed(1)}%';
  }

  @override
  String getProgressText() {
    return '$currentPage of $pageCount pages';
  }
}
