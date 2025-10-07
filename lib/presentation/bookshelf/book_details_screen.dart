import 'package:flutter/material.dart';
import 'package:web_flut/models/books/base_book.dart';
import 'package:web_flut/models/books/comic.dart';
import 'package:web_flut/models/books/light_novel.dart';
import 'package:web_flut/models/books/novel.dart';
import 'package:web_flut/presentation/bookshelf/book_form.dart';
import 'package:web_flut/services/bookshelf_service.dart';

class LibraryItemDetailsScreen extends StatefulWidget {
  final BaseBook item;

  const LibraryItemDetailsScreen({super.key, required this.item});

  @override
  State<LibraryItemDetailsScreen> createState() =>
      _LibraryItemDetailsScreenState();
}

class _LibraryItemDetailsScreenState extends State<LibraryItemDetailsScreen> {
  final BookshelfService _bookshelfService = BookshelfService();

  void _deleteItem() async {
    // Pop the details screen before deleting
    Navigator.of(context).pop();
    await _bookshelfService.deleteItem(widget.item.id);
  }

  Future<void> _showEditFormDialog() async {
    BookType bookType;
    if (widget.item is Novel) {
      bookType = BookType.novel;
    } else if (widget.item is LightNovel) {
      bookType = BookType.lightNovel;
    } else if (widget.item is Comic) {
      bookType = BookType.comic;
    } else {
      // Default to novel or handle error
      bookType = BookType.novel;
    }

    final formKey = GlobalKey<BookFormState>();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit ${bookType.name}'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: SingleChildScrollView(
              child: BookForm(
                key: formKey,
                item: widget.item,
                bookType: bookType,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                final newItem = formKey.currentState?.saveAndGetItem();
                if (newItem != null) {
                  final navigator = Navigator.of(context);
                  await _bookshelfService.updateItem(newItem);
                  // Pop the dialog
                  navigator.pop();
                  // Pop the details screen to force a refresh on the home screen
                  navigator.pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withAlpha(127),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            tooltip: 'Edit',
                            onPressed: _showEditFormDialog,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.error,
                            ),
                            tooltip: 'Delete',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    'Delete ${widget.item.runtimeType.toString()}',
                                  ),
                                  content: Text(
                                    'Are you sure you want to delete this ${widget.item.runtimeType.toString().toLowerCase()}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // Dismiss dialog
                                        _deleteItem();
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    color: theme.scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                widget.item.coverImageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image_not_supported,
                                    size: 100,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.item.title,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 24),
                                _buildInfoCard(theme),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 2,
                    color: theme.scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Summary',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.item.summary,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme) {
    if (widget.item is Novel) {
      final novel = widget.item as Novel;
      return Card(
        elevation: 0,
        color: theme.colorScheme.surface.withAlpha(127),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoItem(theme, 'Author', novel.author.fullName),
              const SizedBox(height: 16),
              _buildInfoItem(theme, 'Status', novel.getStatusText()),
              const SizedBox(height: 16),
              _buildInfoItem(theme, 'Language', novel.language?.name ?? 'N/A'),
              const SizedBox(height: 16),
              _buildInfoItem(
                theme,
                'Pages',
                '${novel.currentPage?.toString() ?? 'N/A'} of ${novel.pageCount?.toString() ?? 'N/A'}',
              ),
              const SizedBox(height: 16),
              _buildInfoItem(
                theme,
                'Genres',
                novel.genres?.map((g) => g.name).join(', ') ?? 'N/A',
              ),
            ],
          ),
        ),
      );
    } else if (widget.item is LightNovel) {
      final lightNovel = widget.item as LightNovel;
      return Card(
        elevation: 0,
        color: theme.colorScheme.surface.withAlpha(127),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoItem(theme, 'Author', lightNovel.author.fullName),
              const SizedBox(height: 16),
              _buildInfoItem(theme, 'Status', lightNovel.getStatusText()),
              const SizedBox(height: 16),
              _buildInfoItem(
                theme,
                'Language',
                lightNovel.language?.name ?? 'N/A',
              ),
              const SizedBox(height: 16),
              _buildInfoItem(
                theme,
                'Pages',
                '${lightNovel.currentPage?.toString() ?? 'N/A'} of ${lightNovel.pageCount?.toString() ?? 'N/A'}',
              ),
              const SizedBox(height: 16),
              _buildInfoItem(
                theme,
                'Genres',
                lightNovel.genres?.map((g) => g.name).join(', ') ?? 'N/A',
              ),
            ],
          ),
        ),
      );
    } else if (widget.item is Comic) {
      final comic = widget.item as Comic;
      final genreNames = comic.genres?.map((g) => g.name).join(', ') ?? 'N/A';
      return Card(
        elevation: 0,
        color: theme.colorScheme.surface.withAlpha(127),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Add this
            children: [
              _buildInfoItem(theme, 'Author', widget.item.author.fullName),
              const SizedBox(height: 16),
              _buildInfoItem(theme, 'Status', comic.getStatusText()),
              const SizedBox(height: 16),
              _buildInfoItem(theme, 'Language', comic.language?.name ?? 'N/A'),
              const SizedBox(height: 16),
              _buildInfoItem(
                theme,
                'Type',
                comic.type?.toString().split('.').last ?? 'N/A',
              ),
              const SizedBox(height: 16),
              _buildInfoItem(theme, 'Genres', genreNames),
              const SizedBox(height: 16),
              _buildInfoItem(theme, 'Details', comic.getDetails()),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildInfoItem(ThemeData theme, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Add this
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(178),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
