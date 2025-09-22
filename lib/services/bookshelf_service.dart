import 'package:web_flut/models/book.dart';
import 'package:web_flut/models/comic.dart';
import 'package:web_flut/models/library_item.dart';
import 'package:web_flut/services/library_item_service.dart';

/// Service for managing both books and komiks (comics)
class BookshelfService implements LibraryItemService<LibraryItem> {
  // Singleton pattern implementation
  static final BookshelfService _instance = BookshelfService._internal();

  factory BookshelfService() {
    return _instance;
  }

  BookshelfService._internal();

  // Private data store - encapsulated
  final List<LibraryItem> _libraryItems = [
    Book(
      id: '1',
      title: 'The Hobbit',
      author: 'J.R.R. Tolkien',
      summary: 'A fantasy novel by J.R.R. Tolkien.',
      coverImageUrl: 'https://covers.openlibrary.org/b/id/8264489-L.jpg',
      pageCount: 310,
      currentPage: 120,
      isReading: true,
      insertedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Book(
      id: '2',
      title: 'The Lord of the Rings',
      author: 'J.R.R. Tolkien',
      summary: 'A fantasy novel by J.R.R. Tolkien.',
      coverImageUrl: 'https://covers.openlibrary.org/b/id/10581273-L.jpg',
      pageCount: 1178,
      currentPage: 0,
      isReading: false,
      insertedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Book(
      id: '3',
      title: 'Pride and Prejudice',
      author: 'Jane Austen',
      summary: 'A romantic novel of manners.',
      coverImageUrl: 'https://covers.openlibrary.org/b/id/8267148-L.jpg',
      pageCount: 279,
      isFinished: true,
      currentPage: 279,
      insertedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Comic(
      id: '4',
      title: 'One Piece',
      author: 'Eiichiro Oda',
      type: 'Manga',
      genre: 'Adventure',
      summary: 'A legendary pirate adventure following Luffy and his crew.',
      chapters: 1090,
      currentChapter: 1090,
      coverImageUrl: 'https://static.wikia.nocookie.net/onepiece/images/6/6e/One_Piece_Manga_Volume_1.jpg',
      status: 'Ongoing',
      isReading: true,
      isFinished: false,
      insertedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Comic(
      id: '5',
      title: 'Solo Leveling',
      author: 'Chugong',
      type: 'Manhwa',
      genre: 'Action',
      summary: 'A weak hunter becomes the world\'s strongest through leveling up.',
      chapters: 200,
      currentChapter: 200,
      coverImageUrl: 'https://static.wikia.nocookie.net/sololeveling/images/2/2e/Solo_Leveling_Volume_1.jpg',
      status: 'Completed',
      isReading: false,
      isFinished: true,
      insertedAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  // Implementation of LibraryItemService interface methods
  @override
  Future<List<LibraryItem>> getItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _libraryItems;
  }

  @override
  Future<LibraryItem?> getItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _libraryItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addItem(LibraryItem item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _libraryItems.add(item);
  }

  @override
  Future<void> updateItem(LibraryItem updatedItem) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _libraryItems.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _libraryItems[index] = updatedItem;
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _libraryItems.removeWhere((item) => item.id == id);
  }

  @override
  Future<void> toggleFinishedStatus(LibraryItem item) async {
    // Use polymorphism through the copyWith method
    final updatedItem = item.copyWith(
      isFinished: !item.isFinished,
      isReading: item.isFinished ? false : item.isReading,
    );
    await updateItem(updatedItem);
  }

  // Type-specific filtered getters
  Future<List<Book>> getBooks() async {
    final items = await getItems();
    return items.whereType<Book>().toList();
  }

  Future<List<Comic>> getKomiks() async {
    final items = await getItems();
    return items.whereType<Comic>().toList();
  }
}