import 'package:web_flut/models/library_item.dart';

/// Base service interface for all library item services
abstract class LibraryItemService<T extends LibraryItem> {
  /// Get all items
  Future<List<T>> getItems();

  /// Get a specific item by ID
  Future<T?> getItemById(String id);

  /// Add a new item
  Future<void> addItem(T item);

  /// Update an existing item
  Future<void> updateItem(T item);

  /// Delete an item by ID
  Future<void> deleteItem(String id);

  /// Toggle the finished status of an item
  Future<void> toggleFinishedStatus(T item);
}
