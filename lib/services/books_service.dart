import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_flut/models/books/base_book.dart';
import 'package:web_flut/models/books/novel.dart';

import 'package:web_flut/models/books/comic.dart';

typedef BookFromMap = BaseBook Function(Map<String, dynamic>);

void debug(dynamic e) {
  print('Error has occured: \n$e');
}

class BooksService {
  final FirebaseFirestore _firestore;
  late final CollectionReference<Map<String, dynamic>> _booksRef;

  BooksService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance {
    _booksRef = _firestore.collection('books');
  }
  static final Map<String, BookFromMap> _bookFactories = {
    'novel': (map) => Novel.fromMap(map),
    'comic': (map) => Comic.fromMap(map),
  };

  Future<void> createBook(BaseBook book) async {
    await _booksRef.doc(book.id).set(book.toMap());
  }

  Future<BaseBook?> getBook(String id, {required String bookType}) async {
    try {
      final doc = await _booksRef.doc(id).get();
      if (!doc.exists) return null;
      final data = doc.data()!;
      final type = data['type'] as String?;
      if (type == null) {
        return null;
      }
      final factory = _bookFactories[type];
      if (factory == null) {
        return null;
      }

      return factory(data);
    } catch (e) {
      debug(e);
      return null;
    }
  }

  Future<void> updateBook(BaseBook book) async {
    await _booksRef.doc(book.id).update(book.toMap());
  }

  Future<void> deleteBook(String bookId) async {
    await _booksRef.doc(bookId).delete();
  }

  Future<List<BaseBook>> getAllBooks() async {
    final snapshot = await _booksRef.get();
    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          final type = data['type'] as String?;
          final factory = _bookFactories[type];
          if (factory != null) {
            return factory(data);
          }
          return null;
        })
        .whereType<BaseBook>()
        .toList();
  }

  Stream<List<BaseBook>> getBooksStream() {
    return _booksRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            final type = data['type'] as String?;
            final factory = _bookFactories[type];
            if (factory != null) {
              return factory(data);
            }
            print('Unknown type: $type');
            return null;
          })
          .whereType<BaseBook>()
          .toList();
    });
  }
}
