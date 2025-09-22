import 'package:flutter/material.dart';
import 'package:web_flut/models/book.dart';
import 'package:web_flut/models/comic.dart';
import 'package:web_flut/models/library_item.dart';
import 'package:web_flut/services/bookshelf_service.dart';

/// Enum for sorting options
enum SortOption { byTitle, byAuthor, byDate }

/// Enum for item type filter
enum ItemTypeFilter { all, booksOnly, komiksOnly }

/// View model for the Home Screen
/// Implements proper encapsulation of business logic
class HomeViewModel extends ChangeNotifier {
  // Services
  final BookshelfService _bookshelfService = BookshelfService();
  
  // State
  List<LibraryItem> _items = [];
  String _searchQuery = '';
  SortOption _sortOption = SortOption.byDate;
  ItemTypeFilter _itemTypeFilter = ItemTypeFilter.all;
  bool _isLoading = false;

  // Getters
  List<LibraryItem> get items => _items;
  String get searchQuery => _searchQuery;
  SortOption get sortOption => _sortOption;
  ItemTypeFilter get itemTypeFilter => _itemTypeFilter;
  bool get isLoading => _isLoading;
  
  // Filtered getters
  List<Book> get books => _items.whereType<Book>().toList();
  List<Comic> get komiks => _items.whereType<Comic>().toList();
  
  // Read status filtered getters
  List<LibraryItem> get unreadItems => _items.where((item) => !item.isFinished).toList();
  List<LibraryItem> get readItems => _items.where((item) => item.isFinished).toList();

  // Filtered and sorted items with type filtering
  List<LibraryItem> get filteredUnreadItems {
    List<LibraryItem> result = unreadItems;

    // Apply type filter
    if (_itemTypeFilter == ItemTypeFilter.booksOnly) {
      result = result.whereType<Book>().toList();
    } else if (_itemTypeFilter == ItemTypeFilter.komiksOnly) {
      result = result.whereType<Comic>().toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      result = _filterItemsBySearch(result);
    }

    // Apply sorting
    return _sortItems(result);
  }

  List<LibraryItem> get filteredReadItems {
    List<LibraryItem> result = readItems;

    // Apply type filter
    if (_itemTypeFilter == ItemTypeFilter.booksOnly) {
      result = result.whereType<Book>().toList();
    } else if (_itemTypeFilter == ItemTypeFilter.komiksOnly) {
      result = result.whereType<Comic>().toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      result = _filterItemsBySearch(result);
    }

    // Apply sorting
    return _sortItems(result);
  }

  // Constructor
  HomeViewModel() {
    loadItems();
  }
  
  /// Load items from the service
  Future<void> loadItems() async {
    _setLoading(true);
    try {
      _items = await _bookshelfService.getItems();
      notifyListeners();
    } catch (e) {
      // Error handling could be added here
    } finally {
      _setLoading(false);
    }
  }
  
  /// Add a new item
  Future<void> addItem(LibraryItem item) async {
    _setLoading(true);
    try {
      await _bookshelfService.addItem(item);
      await loadItems();
    } catch (e) {
      // Error handling could be added here
    } finally {
      _setLoading(false);
    }
  }
  
  /// Update search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  /// Update sort option
  void updateSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  /// Update item type filter
  void updateItemTypeFilter(ItemTypeFilter filter) {
    // This forces the filter to reset completely when changing types
    if (_itemTypeFilter != filter) {
      _itemTypeFilter = filter;
      notifyListeners();
    }
  }

  /// Delete an item
  Future<void> deleteItem(String id) async {
    _setLoading(true);
    try {
      await _bookshelfService.deleteItem(id);
      await loadItems();
    } catch (e) {
      // Error handling could be added here
    } finally {
      _setLoading(false);
    }
  }
  
  /// Toggle reading status
  Future<void> toggleFinishedStatus(LibraryItem item) async {
    _setLoading(true);
    try {
      await _bookshelfService.toggleFinishedStatus(item);
      await loadItems();
    } catch (e) {
      // Error handling could be added here
    } finally {
      _setLoading(false);
    }
  }
  
  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  /// Filter items by search query
  List<LibraryItem> _filterItemsBySearch(List<LibraryItem> items) {
    if (_searchQuery.isEmpty) {
      return items;
    }
    
    final query = _searchQuery.toLowerCase();
    return items.where((item) {
      final titleMatch = item.title.toLowerCase().contains(query);
      final authorMatch = item.author.toLowerCase().contains(query); // Using polymorphic author property

      // Additional type-specific search criteria
      if (item is Comic) {
        final genreMatch = item.genre.toLowerCase().contains(query);
        final typeMatch = item.type.toLowerCase().contains(query);
        return titleMatch || authorMatch || genreMatch || typeMatch;
      }

      return titleMatch || authorMatch;
    }).toList();
  }
  
  /// Sort items based on the selected sort option
  List<LibraryItem> _sortItems(List<LibraryItem> items) {
    final sortedItems = List<LibraryItem>.from(items);
    
    sortedItems.sort((a, b) {
      switch (_sortOption) {
        case SortOption.byTitle:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case SortOption.byAuthor:
          // Properly handle author comparison for all LibraryItem types
          return a.author.toLowerCase().compareTo(b.author.toLowerCase());
        case SortOption.byDate:
          return b.insertedAt.compareTo(a.insertedAt); // Newest first
      }
    });
    
    return sortedItems;
  }
}
