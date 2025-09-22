import 'package:flutter/material.dart';
import 'package:web_flut/models/book.dart';
import 'package:web_flut/models/comic.dart';
import 'package:web_flut/presentation/auth/login_screen.dart';
import 'package:web_flut/presentation/bookshelf/library_item_card.dart';
import 'package:web_flut/presentation/bookshelf/library_item_form.dart';
import 'package:web_flut/presentation/home/home_view_model.dart';

/// The main home screen of the application
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // View model and controllers
  final HomeViewModel _viewModel = HomeViewModel();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  /// Callback for search changes
  void _onSearchChanged() {
    _viewModel.updateSearchQuery(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Show dialog to add a new item
  void _showAddItemDialog({required bool isKomik}) async {
    final formKey = GlobalKey<LibraryItemFormState>();
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add ${isKomik ? 'Komik' : 'Book'}'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: SingleChildScrollView(
              child: LibraryItemForm(key: formKey, isKomik: isKomik),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                final newItem = formKey.currentState?.saveAndGetItem();
                if (newItem != null) {
                  await _viewModel.addItem(newItem);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// Show dialog to choose the type of item to add
  Future<void> _showItemTypeDialog() async {
    final type = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose Item Type'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'book'),
            child: const Text('Book'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'komik'),
            child: const Text('Komik'),
          ),
        ],
      ),
    );

    if (type == 'book') {
      _showAddItemDialog(isKomik: false);
    } else if (type == 'komik') {
      _showAddItemDialog(isKomik: true);
    }
  }

  /// Show dialog to choose the sort option
  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Sort by'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              _viewModel.updateSortOption(SortOption.byTitle);
              Navigator.pop(context);
            },
            child: const Text('Title'),
          ),
          SimpleDialogOption(
            onPressed: () {
              _viewModel.updateSortOption(SortOption.byAuthor);
              Navigator.pop(context);
            },
            child: const Text('Author'),
          ),
          SimpleDialogOption(
            onPressed: () {
              _viewModel.updateSortOption(SortOption.byDate);
              Navigator.pop(context);
            },
            child: const Text('Recently Added'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              // App bar section
              _buildAppBar(theme),

              // Search and filters section
              _buildSearchAndFilters(theme),

              // Library items list
              _buildLibraryItemsList(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the app bar section
  Widget _buildAppBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('My Bookshelf',
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _navigateToLogin,
          ),
        ],
      ),
    );
  }

  /// Navigate to the login screen
  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen(),
      ),
    );
  }

  /// Build the search and filters section
  Widget _buildSearchAndFilters(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by title or author...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _viewModel.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _viewModel.updateSearchQuery('');
                      },
                    )
                  : null,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Filter and sort menu button
          Material(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.tune),
              tooltip: 'Filter and Sort',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (context) => [
                // Divider with label for filter section
                PopupMenuItem(
                  enabled: false,
                  child: Text(
                    'FILTER BY TYPE',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                // Filter options
                PopupMenuItem(
                  value: 'filter_all',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: _viewModel.itemTypeFilter == ItemTypeFilter.all
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      const Text('All Items'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'filter_books',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: _viewModel.itemTypeFilter == ItemTypeFilter.booksOnly
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      const Text('Books Only'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'filter_komiks',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: _viewModel.itemTypeFilter == ItemTypeFilter.komiksOnly
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      const Text('Komiks Only'),
                    ],
                  ),
                ),
                // Divider between filter and sort sections
                const PopupMenuDivider(),
                // Divider with label for sort section
                PopupMenuItem(
                  enabled: false,
                  child: Text(
                    'SORT BY',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                // Sort options
                PopupMenuItem(
                  value: 'sort_title',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: _viewModel.sortOption == SortOption.byTitle
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      const Text('Title'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'sort_author',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: _viewModel.sortOption == SortOption.byAuthor
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      const Text('Author'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'sort_date',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: _viewModel.sortOption == SortOption.byDate
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      const Text('Recently Added'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                // Handle filter selection
                if (value == 'filter_all') {
                  _viewModel.updateItemTypeFilter(ItemTypeFilter.all);
                } else if (value == 'filter_books') {
                  _viewModel.updateItemTypeFilter(ItemTypeFilter.booksOnly);
                } else if (value == 'filter_komiks') {
                  _viewModel.updateItemTypeFilter(ItemTypeFilter.komiksOnly);
                }
                // Handle sort selection
                else if (value == 'sort_title') {
                  _viewModel.updateSortOption(SortOption.byTitle);
                } else if (value == 'sort_author') {
                  _viewModel.updateSortOption(SortOption.byAuthor);
                } else if (value == 'sort_date') {
                  _viewModel.updateSortOption(SortOption.byDate);
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _showItemTypeDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Item'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Build the library items list
  Widget _buildLibraryItemsList() {
    return Expanded(
      child: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final unreadItems = _viewModel.filteredUnreadItems;
          final readItems = _viewModel.filteredReadItems;

          if (unreadItems.isEmpty && readItems.isEmpty) {
            return const Center(child: Text('No items found.'));
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 24.0),
            children: [
              // Currently Reading section
              if (unreadItems.isNotEmpty) ...[
                _buildSectionHeader('Currently Reading'),
                ...unreadItems.map((item) =>
                  LibraryItemCard(
                    key: ValueKey(item.id),
                    item: item,
                    onItemChanged: () => _viewModel.loadItems(),
                  )
                ),
              ],

              // Completed section
              if (readItems.isNotEmpty) ...[
                _buildSectionHeader('Completed'),
                ...readItems.map((item) =>
                  LibraryItemCard(
                    key: ValueKey(item.id),
                    item: item,
                    onItemChanged: () => _viewModel.loadItems(),
                  )
                ),
              ]
            ],
          );
        },
      ),
    );
  }

  /// Build a section header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
