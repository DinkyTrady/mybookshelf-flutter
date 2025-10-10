import 'package:flutter/material.dart';
import 'package:web_flut/presentation/auth/sign_in_screen.dart';
import 'package:web_flut/presentation/bookshelf/book_form.dart';
import 'package:web_flut/presentation/bookshelf/library_item_card.dart';
import 'package:web_flut/presentation/home/home_view_model.dart';
import 'package:web_flut/services/auth_service.dart';
import 'package:web_flut/utils/toast_util.dart';

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
  void _showAddItemDialog({required BookType bookType}) async {
    final formKey = GlobalKey<BookFormState>();
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add ${bookType.name}'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: SingleChildScrollView(
              child: BookForm(key: formKey, bookType: bookType),
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
                  final navigator = Navigator.of(context);
                  await _viewModel.addItems(newItem);
                  navigator.pop();
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
    final type = await showDialog<BookType>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose Item Type'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, BookType.novel),
            child: const Text('Novel'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, BookType.lightNovel),
            child: const Text('Light Novel'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, BookType.comic),
            child: const Text('Comic'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, BookType.manga),
            child: const Text('Manga'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, BookType.manhwa),
            child: const Text('Manhwa'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, BookType.manhua),
            child: const Text('Manhua'),
          ),
        ],
      ),
    );

    if (type != null) {
      _showAddItemDialog(bookType: type);
    }
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
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 24.0,
        bottom: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Bookshelf',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _navigateToLogin,
          ),
        ],
      ),
    );
  }

  /// Navigate to the login screen
  void _navigateToLogin() async {
    await AuthService().signOut();
    ToastUtil.showToast(context, 'Successfully logged out', success: true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => const SignInScreen(),
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
                  value: 'filter_novels',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color:
                            _viewModel.itemTypeFilter == ItemTypeFilter.novels
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      const Text('Novels Only'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'filter_light_novels',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color:
                            _viewModel.itemTypeFilter ==
                                ItemTypeFilter.lightNovels
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      const Text('Light Novels Only'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'filter_comics',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color:
                            _viewModel.itemTypeFilter == ItemTypeFilter.comics
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      const Text('Comics Only'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'filter_manga',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: _viewModel.itemTypeFilter == ItemTypeFilter.manga
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      const Text('Manga Only'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'filter_manhwa',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color:
                            _viewModel.itemTypeFilter == ItemTypeFilter.manhwa
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      const Text('Manhwa Only'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'filter_manhua',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color:
                            _viewModel.itemTypeFilter == ItemTypeFilter.manhua
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      const Text('Manhua Only'),
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
                } else if (value == 'filter_novels') {
                  _viewModel.updateItemTypeFilter(ItemTypeFilter.novels);
                } else if (value == 'filter_light_novels') {
                  _viewModel.updateItemTypeFilter(ItemTypeFilter.lightNovels);
                } else if (value == 'filter_comics') {
                  _viewModel.updateItemTypeFilter(ItemTypeFilter.comics);
                } else if (value == 'filter_manga') {
                  _viewModel.updateItemTypeFilter(ItemTypeFilter.manga);
                } else if (value == 'filter_manhwa') {
                  _viewModel.updateItemTypeFilter(ItemTypeFilter.manhwa);
                } else if (value == 'filter_manhua') {
                  _viewModel.updateItemTypeFilter(ItemTypeFilter.manhua);
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
          ),
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
                ...unreadItems.map(
                  (item) => LibraryItemCard(
                    key: ValueKey(item.id),
                    item: item,
                    viewModel: _viewModel,
                  ),
                ),
              ],

              // Completed section
              if (readItems.isNotEmpty) ...[
                _buildSectionHeader('Completed'),
                ...readItems.map(
                  (item) => LibraryItemCard(
                    key: ValueKey(item.id),
                    item: item,
                    viewModel: _viewModel,
                  ),
                ),
              ],
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
