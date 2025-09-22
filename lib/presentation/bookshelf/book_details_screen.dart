import 'package:flutter/material.dart';
import 'package:web_flut/models/book.dart';
import 'package:web_flut/models/comic.dart';
import 'package:web_flut/models/library_item.dart';
import 'package:web_flut/presentation/bookshelf/library_item_form.dart';
import 'package:web_flut/services/bookshelf_service.dart';

class LibraryItemDetailsScreen extends StatefulWidget {
  final LibraryItem item;

  const LibraryItemDetailsScreen({super.key, required this.item});

  @override
  State<LibraryItemDetailsScreen> createState() => _LibraryItemDetailsScreenState();
}

class _LibraryItemDetailsScreenState extends State<LibraryItemDetailsScreen> {
  final BookshelfService _bookshelfService = BookshelfService();

  void _deleteItem() async {
    // Pop the details screen before deleting
    Navigator.of(context).pop();
    await _bookshelfService.deleteItem(widget.item.id);
  }

  Future<void> _showEditFormDialog() async {
    final formKey = GlobalKey<LibraryItemFormState>();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit ${widget.item is Comic ? 'Komik' : 'Book'}'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: SingleChildScrollView(
              child: LibraryItemForm(key: formKey, item: widget.item, isKomik: widget.item is Comic),
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
                  await _bookshelfService.updateItem(newItem);
                  // Pop the dialog
                  Navigator.of(context).pop();
                  // Pop the details screen to force a refresh on the home screen
                  Navigator.of(context).pop();
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
    String coverImageUrl = '';
    String author = '';
    String summary = '';

    if (widget.item is Book) {
      Book book = widget.item as Book;
      coverImageUrl = book.coverImageUrl;
      author = book.author;
      summary = book.summary;
    } else if (widget.item is Comic) {
      Comic komik = widget.item as Comic;
      coverImageUrl = komik.coverImageUrl;
      author = komik.author;
      summary = komik.summary;
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.5),
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
                            icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                            tooltip: 'Delete',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete ${widget.item is Comic ? 'Komik' : 'Book'}'),
                                  content: Text('Are you sure you want to delete this ${widget.item is Comic ? 'komik' : 'book'}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Dismiss dialog
                                        _deleteItem();
                                      },
                                      child: Text('Delete', style: TextStyle(color: theme.colorScheme.error)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    color: theme.scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                                coverImageUrl,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported, size: 100);
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
                                Text(widget.item.title, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text('by $author', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
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
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                     child: Padding(
                       padding: const EdgeInsets.all(24.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text('Summary', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                           const SizedBox(height: 16),
                           Text(summary, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
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
    if (widget.item is Book) {
      final book = widget.item as Book;
      return Card(
        elevation: 0,
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(theme, 'Status', book.isFinished ? 'Finished' : (book.isReading ? 'Reading' : 'Not Started')),
              _buildInfoItem(theme, 'Pages', book.pageCount.toString()),
              _buildInfoItem(theme, 'Progress', '${book.currentPage} pages'),
            ],
          ),
        ),
      );
    } else if (widget.item is Comic) {
      final komik = widget.item as Comic;
      return Card(
        elevation: 0,
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(theme, 'Status', komik.isFinished ? 'Finished' : (komik.isReading ? 'Reading' : komik.status)),
              _buildInfoItem(theme, 'Type', komik.type),
              _buildInfoItem(theme, 'Genre', komik.genre),
              _buildInfoItem(theme, 'Chapters', komik.chapters.toString()),
              _buildInfoItem(theme, 'Progress', '${komik.currentChapter} chapters'),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildInfoItem(ThemeData theme, String title, String value) {
    return Column(
      children: [
        Text(title, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
