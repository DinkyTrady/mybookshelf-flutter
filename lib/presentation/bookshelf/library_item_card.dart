import 'package:flutter/material.dart';
import 'package:web_flut/models/book.dart';
import 'package:web_flut/models/library_item.dart';
import 'package:web_flut/models/comic.dart';
import 'package:web_flut/presentation/bookshelf/book_details_screen.dart';
import 'package:web_flut/services/bookshelf_service.dart';

/// A reusable card widget that displays a library item (Book or Komik)
class LibraryItemCard extends StatelessWidget {
  final LibraryItem item;
  final VoidCallback onItemChanged;

  const LibraryItemCard({
    super.key,
    required this.item,
    required this.onItemChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookshelfService = BookshelfService();
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      color: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: _buildLeadingImage(),
        title: Text(
          item.title, 
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        ),
        subtitle: _buildSubtitle(theme),
        trailing: _buildTrailingActions(theme, bookshelfService, context),
        onTap: () => _navigateToDetails(context),
      ),
    );
  }
  
  /// Builds the leading image for the card
  Widget _buildLeadingImage() {
    return SizedBox(
      width: 50,
      child: Image.network(
        item.coverImageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image_not_supported, size: 50);
        },
      ),
    );
  }
  
  /// Builds the subtitle based on the item type
  Widget? _buildSubtitle(ThemeData theme) {
    if (item is Book) {
      final book = item as Book;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(item.author, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          if (book.isReading && !book.isFinished)
            LinearProgressIndicator(
              value: book.progressPercentage,
              backgroundColor: theme.colorScheme.surface.withAlpha(128),
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
            ),
        ],
      );
    } else if (item is Comic) {
      final komik = item as Comic;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text('${komik.type} • ${komik.genre}', style: theme.textTheme.bodyMedium),
          Text('by ${komik.author}', style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          Text('${komik.currentChapter}/${komik.chapters} chapters • ${komik.status}',
               style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          if (komik.isReading && !komik.isFinished)
            LinearProgressIndicator(
              value: komik.progressPercentage,
              backgroundColor: theme.colorScheme.surface.withAlpha(128),
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
            ),
        ],
      );
    }
    return null;
  }
  
  /// Builds the trailing actions based on the item type
  Widget? _buildTrailingActions(ThemeData theme, BookshelfService service, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            item.isFinished ? Icons.check_box : Icons.check_box_outline_blank,
            color: item.isFinished ? theme.colorScheme.secondary : null
          ),
          tooltip: item.isFinished ? 'Mark as Unread' : 'Mark as Read',
          onPressed: () => _toggleFinishedStatus(service),
        ),
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          tooltip: 'Edit',
          onPressed: () => _showEditDialog(context),
        ),
        IconButton(
          icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
          tooltip: 'Delete',
          onPressed: () => _showDeleteDialog(context, service),
        ),
      ],
    );
  }
  
  /// Toggles the finished status of the item
  void _toggleFinishedStatus(BookshelfService service) async {
    await service.toggleFinishedStatus(item);
    onItemChanged();
  }
  
  /// Shows the edit dialog
  void _showEditDialog(BuildContext context) {
    // Edit dialog implementation (will be added in HomeScreen refactoring)
    onItemChanged();
  }
  
  /// Shows the delete confirmation dialog
  void _showDeleteDialog(BuildContext context, BookshelfService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${item is Comic ? 'Komik' : 'Book'}'),
        content: Text('Are you sure you want to delete this ${item is Comic ? 'komik' : 'book'}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteItem(service);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  /// Deletes the item from the bookshelf
  void _deleteItem(BookshelfService service) async {
    await service.deleteItem(item.id);
    onItemChanged();
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
