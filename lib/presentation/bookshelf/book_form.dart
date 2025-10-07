import 'package:web_flut/models/books/comic_type.dart';
import 'package:flutter/material.dart';
import 'package:web_flut/models/books/base_book.dart';
import 'package:web_flut/models/books/novel.dart';
import 'package:web_flut/models/books/comic.dart';
import 'package:web_flut/models/books/light_novel.dart';
import 'package:web_flut/models/users/author.dart';
import 'package:web_flut/models/genre.dart';
import 'package:web_flut/models/language.dart';
import 'package:web_flut/components/custom_text_form_field.dart';
import 'dart:math' as math;

enum BookType { novel, lightNovel, comic, manga, manhwa, manhua }

/// A form for adding/editing library items (Books and Comics)
class BookForm extends StatefulWidget {
  final BaseBook? item;
  final BookType bookType;

  const BookForm({super.key, this.item, required this.bookType});

  @override
  State<BookForm> createState() => BookFormState();
}

class BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();

  // Common controllers
  late TextEditingController _titleController;
  late TextEditingController _authorFirstNameController;
  late TextEditingController _authorLastNameController;
  late TextEditingController _authorBiographyController;
  late TextEditingController _summaryController;
  late TextEditingController _coverImageUrlController;
  late TextEditingController _languageNameController;
  late TextEditingController _languageCodeController;

  // Book-specific controllers (Novel, LightNovel)
  late TextEditingController _pageCountController;
  late TextEditingController _currentPageController;

  // Comic-specific controllers (Comic, Manga, Manhwa, Manhua)
  late TextEditingController
  _comicTypeController; // e.g., Manga, Manhwa, Manhua
  late TextEditingController _genresController; // Comma separated genres
  late TextEditingController _chaptersController;
  late TextEditingController _currentChapterController;
  late TextEditingController _statusController; // ongoing, completed

  // Reading status
  bool _isReading = false;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  /// Initialize controllers with values from item or empty values
  void _initializeControllers() {
    // Common controllers
    _titleController = TextEditingController(text: widget.item?.title ?? '');
    _authorFirstNameController = TextEditingController(
      text: widget.item?.author.firstName ?? '',
    );
    _authorLastNameController = TextEditingController(
      text: widget.item?.author.lastName ?? '',
    );
    _authorBiographyController = TextEditingController(
      text: widget.item?.author.biography ?? '',
    );
    _summaryController = TextEditingController(
      text: widget.item?.summary ?? '',
    );
    _coverImageUrlController = TextEditingController(
      text: widget.item?.coverImageUrl ?? '',
    );
    _languageNameController = TextEditingController(
      text: widget.item?.language?.name ?? '',
    );
    _languageCodeController = TextEditingController(
      text: widget.item?.language?.code ?? '',
    );

    // Book-specific controllers (Novel, LightNovel)
    if (widget.item is Novel || widget.item is LightNovel) {
      final book = widget.item as BaseBook;
      _pageCountController = TextEditingController(
        text: book.pageCount?.toString() ?? '0',
      );
      _currentPageController = TextEditingController(
        text: book.currentPage?.toString() ?? '0',
      );
    } else {
      _pageCountController = TextEditingController(text: '0');
      _currentPageController = TextEditingController(text: '0');
    }

    // Comic-specific controllers (Comic, Manga, Manhwa, Manhua)
    if (widget.item is Comic) {
      final comic = widget.item as Comic;
      _comicTypeController = TextEditingController(
        text: comic.type?.toString().split('.').last ?? '',
      );
      _genresController = TextEditingController(
        text: comic.genres?.map((g) => g.name).join(', ') ?? '',
      );
      _chaptersController = TextEditingController(
        text: comic.chapters?.toString() ?? '0',
      );
      _currentChapterController = TextEditingController(
        text: comic.currentChapter?.toString() ?? '0',
      );
      _statusController = TextEditingController(
        text: comic.status ?? 'Ongoing',
      );
    } else {
      _comicTypeController = TextEditingController(
        text: widget.bookType == BookType.manga
            ? 'Manga'
            : widget.bookType == BookType.manhwa
            ? 'Manhwa'
            : widget.bookType == BookType.manhua
            ? 'Manhua'
            : 'Comic',
      );
      _genresController = TextEditingController(text: '');
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
    _authorFirstNameController.dispose();
    _authorLastNameController.dispose();
    _authorBiographyController.dispose();
    _summaryController.dispose();
    _coverImageUrlController.dispose();
    _languageNameController.dispose();
    _languageCodeController.dispose();
    _pageCountController.dispose();
    _currentPageController.dispose();
    _comicTypeController.dispose();
    _genresController.dispose();
    _chaptersController.dispose();
    _currentChapterController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  /// Save and get the library item (BaseBook subclass)
  BaseBook? saveAndGetItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final id = widget.item?.id ?? math.Random().nextInt(10000).toString();
      final author = Author(
        id: widget.item?.author.id ?? math.Random().nextInt(10000).toString(),
        firstName: _authorFirstNameController.text,
        lastName: _authorLastNameController.text.isNotEmpty
            ? _authorLastNameController.text
            : null,
        biography: _authorBiographyController.text,
        dateOfBirth: DateTime.now(), // Placeholder, ideally from input
      );
      final language =
          _languageNameController.text.isNotEmpty &&
              _languageCodeController.text.isNotEmpty
          ? Language(
              id:
                  widget.item?.language?.id ??
                  math.Random().nextInt(10000).toString(),
              name: _languageNameController.text,
              code: _languageCodeController.text,
            )
          : null;

      switch (widget.bookType) {
        case BookType.novel:
          return Novel(
            id: id,
            title: _titleController.text,
            author: author,
            summary: _summaryController.text,
            coverImageUrl: _coverImageUrlController.text,
            pageCount: int.tryParse(_pageCountController.text) ?? 0,
            currentPage: int.tryParse(_currentPageController.text) ?? 0,
            isReading: _isReading,
            isFinished: _isFinished,
            updatedAt: DateTime.now(),
            language: language,
          );
        case BookType.lightNovel:
          return LightNovel(
            id: id,
            title: _titleController.text,
            author: author,
            summary: _summaryController.text,
            coverImageUrl: _coverImageUrlController.text,
            pageCount: int.tryParse(_pageCountController.text) ?? 0,
            currentPage: int.tryParse(_currentPageController.text) ?? 0,
            isReading: _isReading,
            isFinished: _isFinished,
            updatedAt: DateTime.now(),
            language: language,
          );
        case BookType.comic:
        case BookType.manga:
        case BookType.manhwa:
        case BookType.manhua:
          final genres = _genresController.text
              .split(',')
              .map(
                (e) => Genre(
                  id: math.Random().nextInt(10000).toString(),
                  name: e.trim(),
                ),
              )
              .where((element) => element.name.isNotEmpty)
              .toList();
          return Comic(
            id: id,
            title: _titleController.text,
            author: author,
            summary: _summaryController.text,
            coverImageUrl: _coverImageUrlController.text,
            type: ComicType.values.firstWhere(
              (e) => e.toString().split('.').last == _comicTypeController.text,
              orElse: () => ComicType.comic,
            ),
            genres: genres.isNotEmpty ? genres : null,
            chapters: int.tryParse(_chaptersController.text) ?? 0,
            currentChapter: int.tryParse(_currentChapterController.text) ?? 0,
            status: _statusController.text,
            isReading: _isReading,
            isFinished: _isFinished,
            updatedAt: DateTime.now(),
            language: language,
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
          if (widget.bookType == BookType.novel ||
              widget.bookType == BookType.lightNovel)
            _buildBookFields()
          else if (widget.bookType == BookType.comic ||
              widget.bookType == BookType.manga ||
              widget.bookType == BookType.manhwa ||
              widget.bookType == BookType.manhua)
            _buildComicFields(),

          // Reading status
          _buildReadingStatusFields(),
        ],
      ),
    );
  }

  /// Build common fields for all book types
  Widget _buildCommonFields() {
    return Column(
      children: [
        CustomTextFormField(
          controller: _titleController,
          labelText: 'Title',
          validator: _validateRequired,
        ),
        CustomTextFormField(
          controller: _authorFirstNameController,
          labelText: 'Author First Name',
          validator: _validateRequired,
        ),
        CustomTextFormField(
          controller: _authorLastNameController,
          labelText: 'Author Last Name (Optional)',
        ),
        CustomTextFormField(
          controller: _authorBiographyController,
          labelText: 'Author Biography',
          maxLines: 3,
          validator: _validateRequired,
        ),
        CustomTextFormField(
          controller: _summaryController,
          labelText: 'Summary',
          maxLines: 3,
          validator: _validateRequired,
        ),
        CustomTextFormField(
          controller: _coverImageUrlController,
          labelText: 'Cover Image URL',
        ),
        CustomTextFormField(
          controller: _languageNameController,
          labelText: 'Language Name (e.g., English)',
        ),
        CustomTextFormField(
          controller: _languageCodeController,
          labelText: 'Language Code (e.g., en)',
        ),
      ],
    );
  }

  /// Build Book-specific fields (for Novel and LightNovel)
  Widget _buildBookFields() {
    return Column(
      children: [
        CustomTextFormField(
          controller: _pageCountController,
          labelText: 'Page Count',
          keyboardType: TextInputType.number,
          validator: _validateNumber,
        ),
        CustomTextFormField(
          controller: _currentPageController,
          labelText: 'Current Page',
          keyboardType: TextInputType.number,
          validator: _validateNumber,
        ),
      ],
    );
  }

  /// Build Comic-specific fields (for Comic, Manga, Manhwa, Manhua)
  Widget _buildComicFields() {
    return Column(
      children: [
        CustomTextFormField(
          controller: _comicTypeController,
          labelText: 'Type (e.g., Manga, Manhwa, Manhua)',
          validator: _validateRequired,
        ),
        CustomTextFormField(
          controller: _genresController,
          labelText: 'Genres (comma separated)',
        ),
        CustomTextFormField(
          controller: _chaptersController,
          labelText: 'Total Chapters',
          keyboardType: TextInputType.number,
          validator: _validateNumber,
        ),
        CustomTextFormField(
          controller: _currentChapterController,
          labelText: 'Current Chapter',
          keyboardType: TextInputType.number,
          validator: _validateNumber,
        ),
        CustomTextFormField(
          controller: _statusController,
          labelText: 'Status (Ongoing/Completed)',
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
