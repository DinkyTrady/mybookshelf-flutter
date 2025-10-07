import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_flut/models/books/base_book.dart';
import 'package:web_flut/models/books/comic.dart';
import 'package:web_flut/models/books/comic_type.dart';
import 'package:web_flut/models/books/light_novel.dart';
import 'package:web_flut/data/default_data.dart';

import 'package:web_flut/models/books/novel.dart';

/// Enum for sorting options
enum SortOption { byTitle, byAuthor, byDate }

/// Enum for item type filter
enum ItemTypeFilter { all, novels, lightNovels, comics, manga, manhwa, manhua }

/// View model for the Home Screen
/// Implements proper encapsulation of business logic
class HomeViewModel extends ChangeNotifier {
  List<BaseBook> _items = [];
  String _searchQuery = '';
  SortOption _sortOption = SortOption.byDate;
  ItemTypeFilter _itemTypeFilter = ItemTypeFilter.all;
  bool _isLoading = false;

  List<BaseBook> get items => _items;
  String get searchQuery => _searchQuery;
  SortOption get sortOption => _sortOption;
  ItemTypeFilter get itemTypeFilter => _itemTypeFilter;
  bool get isLoading => _isLoading;

  List<BaseBook> get unreadItems =>
      _items.where((item) => !item.isFinished).toList();
  List<BaseBook> get readItems =>
      _items.where((item) => item.isFinished).toList();

  List<BaseBook> get filteredUnreadItems => _filterAndSort(unreadItems);
  List<BaseBook> get filteredReadItems => _filterAndSort(readItems);

  HomeViewModel() {
    loadItems();
  }

  Future<void> loadItems() async {
    _setLoading(true);
    // In-memory data
    _items = defaultBooks;
    notifyListeners();
    _setLoading(false);
  }

  Future<void> addItems(BaseBook book) async {
    _setLoading(true);
    _items.add(book);
    notifyListeners();
    _setLoading(false);
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void updateItemTypeFilter(ItemTypeFilter filter) {
    if (_itemTypeFilter != filter) {
      _itemTypeFilter = filter;
      notifyListeners();
    }
  }

  Future<void> updateItem(BaseBook book) async {
    _setLoading(true);
    final index = _items.indexWhere((item) => item.id == book.id);
    if (index != -1) {
      _items[index] = book;
    }
    notifyListeners();
    _setLoading(false);
  }

  Future<void> deleteItem(String id) async {
    _setLoading(true);
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
    _setLoading(false);
  }

  Future<void> toggleFinishedStatus(BaseBook book) async {
    _setLoading(true);
    final index = _items.indexWhere((item) => item.id == book.id);
    if (index != -1) {
      _items[index] = book.copyWith(isFinished: !book.isFinished);
      notifyListeners();
    }
    _setLoading(false);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  List<BaseBook> _filterAndSort(List<BaseBook> items) {
    List<BaseBook> result = items;

    // Type filter
    switch (_itemTypeFilter) {
      case ItemTypeFilter.novels:
        result = result.whereType<Novel>().toList();
        break;
      case ItemTypeFilter.lightNovels:
        result = result.whereType<LightNovel>().toList();
        break;
      case ItemTypeFilter.comics:
        result = result.whereType<Comic>().toList();
        break;
      case ItemTypeFilter.manga:
        result = result
            .where((item) => item is Comic && item.type == ComicType.manga)
            .toList();
        break;
      case ItemTypeFilter.manhwa:
        result = result
            .where((item) => item is Comic && item.type == ComicType.manhwa)
            .toList();
        break;
      case ItemTypeFilter.manhua:
        result = result
            .where((item) => item is Comic && item.type == ComicType.manhua)
            .toList();
        break;
      case ItemTypeFilter.all:
        break;
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((item) {
        final titleMatch = item.title.toLowerCase().contains(query);
        final authorMatch = item.author.fullName.toLowerCase().contains(query);
        final genreMatch =
            item.genres?.any((g) => g.name.toLowerCase().contains(query)) ??
            false;
        final typeMatch =
            item.type
                ?.toString()
                .split('.')
                .last
                .toLowerCase()
                .contains(query) ??
            false;
        return titleMatch || authorMatch || genreMatch || typeMatch;
      }).toList();
    }

    // Sorting
    result.sort((a, b) {
      switch (_sortOption) {
        case SortOption.byTitle:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case SortOption.byAuthor:
          return a.author.fullName.toLowerCase().compareTo(
            b.author.fullName.toLowerCase(),
          );
        case SortOption.byDate:
          return b.updatedAt?.compareTo(a.updatedAt ?? DateTime(0)) ?? 0;
      }
    });

    return result;
  }
}
