import 'package:flutter/material.dart';
import 'package:web_flut/models/books/base_book.dart';
import 'package:web_flut/models/books/book_type.dart';
import 'package:web_flut/models/books/comic.dart';
import 'package:web_flut/models/books/novel.dart';
import 'package:web_flut/presentation/home/home_view_model.dart';
import 'package:web_flut/presentation/bookshelf/book_details_screen.dart';
import 'package:web_flut/presentation/bookshelf/book_form.dart';

/// A reusable card widget that displays a library item (BaseBook)
class LibraryItemCard extends StatelessWidget {
  final BaseBook item;
  final HomeViewModel viewModel;

  const LibraryItemCard({
    super.key,
    required this.item,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      color: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: _buildLeadingImage(),
        title: Text(
          item.title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: _buildSubtitle(theme),
        trailing: _buildTrailingActions(theme, context),
        onTap: () => _navigateToDetails(context),
      ),
    );
  }

  /// Builds the leading image for the card
  Widget _buildLeadingImage() {
    return SizedBox(
      width: 80,
      height: 140,
      child: Image.network(
        item.coverImageUrl,
        fit: BoxFit.contain,
        height: 140,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image_not_supported, size: 80);
        },
      ),
    );
  }

  /// Builds the subtitle based on the item type
  Widget? _buildSubtitle(ThemeData theme) {
    String subtitleText = '';
    double progressValue = 0.0;
    bool showProgress = false;

    if (item is Novel) {
      final novel = item as Novel;
      final genreNames = novel.genres?.map((g) => g.name).join(', ') ?? 'N/A';
      subtitleText =
          '${novel.author.fullName} • $genreNames • ${novel.pageCount} pages';
      progressValue = novel.progressPercentage;
      showProgress = novel.isReading && !novel.isFinished;

    } else if (item is Comic) {
      final comic = item as Comic;
      final chapter =
          comic.chapters != null ? '${comic.chapters} Chapters' : 'Ongoing';
      final genreNames = comic.genres?.map((g) => g.name).join(', ') ?? 'N/A';
      subtitleText =
          '${comic.author.fullName} • $genreNames • $chapter';
      progressValue = comic.progressPercentage;
      showProgress = comic.isReading && !comic.isFinished;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text(subtitleText, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        if (showProgress)
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: theme.colorScheme.surface.withAlpha(128),
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.secondary,
            ),
          ),
      ],
    );
  }

  /// Builds the trailing actions based on the item type
  Widget? _buildTrailingActions(ThemeData theme, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            item.isFinished ? Icons.check_box : Icons.check_box_outline_blank,
            color: item.isFinished ? theme.colorScheme.secondary : null,
          ),
          tooltip: item.isFinished ? 'Mark as Unread' : 'Mark as Read',
          onPressed: () => viewModel.toggleFinishedStatus(item),
        ),
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          tooltip: 'Edit',
          onPressed: () => _showEditDialog(context),
        ),
        IconButton(
          icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
          tooltip: 'Delete',
          onPressed: () =>
              _showDeleteDialog(context, item.runtimeType.toString()),
        ),
      ],
    );
  }

  /// Shows the edit dialog
  void _showEditDialog(BuildContext context) async {
    BookType bookType;
    if (item is Novel) {
      bookType = BookType.novel;

    } else if (item is Comic) {
      bookType = BookType.comic;
    } else {
      // Default to novel or handle error
      bookType = BookType.novel;
    }

    final formKey = GlobalKey<BookFormState>();
    final navigator = Navigator.of(context); // Get the navigator
    await showDialog<void>(
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
              child: BookForm(key: formKey, item: item, bookType: bookType),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => navigator.pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                final updatedItem = formKey.currentState?.saveAndGetItem();
                if (updatedItem != null) {
                  await viewModel.updateItem(updatedItem);
                  navigator.pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows the delete confirmation dialog
  void _showDeleteDialog(BuildContext context, String itemType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete $itemType'),
        content: Text('Are you sure you want to delete this $itemType?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              viewModel.deleteItem(item.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Navigates to the details screen for the item
  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LibraryItemDetailsScreen(item: item),
      ),
    );
  }
}
