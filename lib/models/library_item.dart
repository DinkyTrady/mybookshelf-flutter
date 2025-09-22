abstract class LibraryItem {
  final String _id;
  String _title;
  final String _author;
  final String _summary;
  final String _coverImageUrl;
  final bool _isReading;
  final bool _isFinished;
  final DateTime _insertedAt;

  LibraryItem({
    required String id,
    required String title,
    required String author,
    required String summary,
    required String coverImageUrl,
    bool isReading = false,
    bool isFinished = false,
    required DateTime insertedAt,
  })  : _id = id,
        _title = title,
        _author = author,
        _summary = summary,
        _coverImageUrl = coverImageUrl,
        _isReading = isReading,
        _isFinished = isFinished,
        _insertedAt = insertedAt;

  // Getters
  String get id => _id;
  String get title => _title;
  String get author => _author;
  String get summary => _summary;
  String get coverImageUrl => _coverImageUrl;
  bool get isReading => _isReading;
  bool get isFinished => _isFinished;
  DateTime get insertedAt => _insertedAt;

  // Required methods to be implemented by subclasses
  String getDetails();

  // Abstract method for copying with new values
  LibraryItem copyWith({
    String? id,
    String? title,
    String? author,
    String? summary,
    String? coverImageUrl,
    bool? isReading,
    bool? isFinished,
    DateTime? insertedAt,
  });

  // Factory method to create progress text based on the type
  String getProgressText();

  // Get status text based on reading status
  String getStatusText() {
    if (isFinished) return 'Finished';
    if (isReading) return 'Reading';
    return 'Not Started';
  }
}
