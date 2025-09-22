import 'package:flutter/material.dart';
import 'package:web_flut/models/book.dart';
import 'package:web_flut/models/library_item.dart';
import 'package:web_flut/models/comic.dart';
import 'dart:math' as math;

/// A form for adding/editing library items (Books and Komiks)
class LibraryItemForm extends StatefulWidget {
  final LibraryItem? item;
  final bool isKomik;
  
  const LibraryItemForm({
    super.key, 
    this.item, 
    required this.isKomik,
  });

  @override
  State<LibraryItemForm> createState() => LibraryItemFormState();
}

class LibraryItemFormState extends State<LibraryItemForm> {
  final _formKey = GlobalKey<FormState>();

  // Common controllers
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _summaryController;
  late TextEditingController _coverImageUrlController;
  
  // Book-specific controllers
  late TextEditingController _pageCountController;
  late TextEditingController _currentPageController;
  
  // Komik-specific controllers
  late TextEditingController _typeController;
  late TextEditingController _genreController;
  late TextEditingController _chaptersController;
  late TextEditingController _currentChapterController;
  late TextEditingController _statusController;
  
  // Reading status
  bool _isReading = false;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize with values from the provided item or empty values
    _initializeControllers();
  }
  
  /// Initialize controllers with values from item or empty values
  void _initializeControllers() {
    // Common controllers
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _authorController = TextEditingController(text: widget.item?.author ?? '');
    _summaryController = TextEditingController(text: widget.item?.summary ?? '');
    _coverImageUrlController = TextEditingController(text: widget.item?.coverImageUrl ?? '');
    
    // Book-specific controllers
    if (widget.item is Book) {
      final book = widget.item as Book;
      _pageCountController = TextEditingController(text: book.pageCount.toString());
      _currentPageController = TextEditingController(text: book.currentPage.toString());
    } else {
      _pageCountController = TextEditingController(text: '0');
      _currentPageController = TextEditingController(text: '0');
    }
    
    // Komik-specific controllers
    if (widget.item is Comic) {
      final komik = widget.item as Comic;
      _typeController = TextEditingController(text: komik.type);
      _genreController = TextEditingController(text: komik.genre);
      _chaptersController = TextEditingController(text: komik.chapters.toString());
      _currentChapterController = TextEditingController(text: komik.currentChapter.toString());
      _statusController = TextEditingController(text: komik.status);
    } else {
      _typeController = TextEditingController(text: 'Manga');
      _genreController = TextEditingController(text: '');
      _chaptersController = TextEditingController(text: '0');
      _currentChapterController = TextEditingController(text: '0');
      _statusController = TextEditingController(text: 'Ongoing');
    }
    
    // Reading status
    _isReading = widget.item?.isReading ?? false;
    _isFinished = widget.item?.isFinished ?? false;
  }

  @override
  void dispose() {
    // Dispose all controllers
    _titleController.dispose();
    _authorController.dispose();
    _summaryController.dispose();
    _coverImageUrlController.dispose();
    _pageCountController.dispose();
    _currentPageController.dispose();
    _typeController.dispose();
    _genreController.dispose();
    _chaptersController.dispose();
    _currentChapterController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  /// Save and get the library item (Book or Komik)
  LibraryItem? saveAndGetItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Generate a random ID for new items
      final id = widget.item?.id ?? math.Random().nextInt(10000).toString();
      
      if (widget.isKomik) {
        return Comic(
          id: id,
          title: _titleController.text,
          author: _authorController.text,
          type: _typeController.text,
          genre: _genreController.text,
          summary: _summaryController.text,
          chapters: int.tryParse(_chaptersController.text) ?? 0,
          currentChapter: int.tryParse(_currentChapterController.text) ?? 0,
          coverImageUrl: _coverImageUrlController.text,
          status: _statusController.text,
          isReading: _isReading,
          isFinished: _isFinished,
          insertedAt: widget.item?.insertedAt ?? DateTime.now(),
        );
      } else {
        return Book(
          id: id,
          title: _titleController.text,
          author: _authorController.text,
          summary: _summaryController.text,
          pageCount: int.tryParse(_pageCountController.text) ?? 0,
          currentPage: int.tryParse(_currentPageController.text) ?? 0,
          coverImageUrl: _coverImageUrlController.text,
          isReading: _isReading,
          isFinished: _isFinished,
          insertedAt: widget.item?.insertedAt ?? DateTime.now(),
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Common fields
          _buildCommonFields(),
          
          // Type-specific fields
          if (widget.isKomik)
            _buildKomikFields()
          else
            _buildBookFields(),
            
          // Reading status
          _buildReadingStatusFields(),
        ],
      ),
    );
  }
  
  /// Build common fields for both Book and Komik
  Widget _buildCommonFields() {
    return Column(
      children: [
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Title'),
          validator: _validateRequired,
        ),
        TextFormField(
          controller: _authorController,
          decoration: const InputDecoration(labelText: 'Author'),
          validator: _validateRequired,
        ),
        TextFormField(
          controller: _summaryController,
          decoration: const InputDecoration(labelText: 'Summary'),
          maxLines: 3,
          validator: _validateRequired,
        ),
        TextFormField(
          controller: _coverImageUrlController,
          decoration: const InputDecoration(labelText: 'Cover Image URL'),
        ),
      ],
    );
  }
  
  /// Build Book-specific fields
  Widget _buildBookFields() {
    return Column(
      children: [
        TextFormField(
          controller: _pageCountController,
          decoration: const InputDecoration(labelText: 'Page Count'),
          keyboardType: TextInputType.number,
          validator: _validateNumber,
        ),
        TextFormField(
          controller: _currentPageController,
          decoration: const InputDecoration(labelText: 'Current Page'),
          keyboardType: TextInputType.number,
          validator: _validateNumber,
        ),
      ],
    );
  }
  
  /// Build Komik-specific fields
  Widget _buildKomikFields() {
    return Column(
      children: [
        TextFormField(
          controller: _typeController,
          decoration: const InputDecoration(labelText: 'Type (Manga/Manhwa/Manhua)'),
          validator: _validateRequired,
        ),
        TextFormField(
          controller: _genreController,
          decoration: const InputDecoration(labelText: 'Genre'),
          validator: _validateRequired,
        ),
        TextFormField(
          controller: _chaptersController,
          decoration: const InputDecoration(labelText: 'Total Chapters'),
          keyboardType: TextInputType.number,
          validator: _validateNumber,
        ),
        TextFormField(
          controller: _currentChapterController,
          decoration: const InputDecoration(labelText: 'Current Chapter'),
          keyboardType: TextInputType.number,
          validator: _validateNumber,
        ),
        TextFormField(
          controller: _statusController,
          decoration: const InputDecoration(labelText: 'Status (Ongoing/Completed)'),
          validator: _validateRequired,
        ),
      ],
    );
  }
  
  /// Build reading status fields
  Widget _buildReadingStatusFields() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Currently Reading'),
          value: _isReading,
          onChanged: (value) {
            setState(() {
              _isReading = value;
              // If finished, can't be reading
              if (_isFinished && _isReading) {
                _isFinished = false;
              }
            });
          },
        ),
        SwitchListTile(
          title: const Text('Finished'),
          value: _isFinished,
          onChanged: (value) {
            setState(() {
              _isFinished = value;
              // If reading, can't be finished
              if (_isReading && _isFinished) {
                _isReading = false;
              }
            });
          },
        ),
      ],
    );
  }
  
  /// Validate required fields
  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }
  
  /// Validate number fields
  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }
}
