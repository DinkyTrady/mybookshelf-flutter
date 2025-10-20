import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:web_flut/components/custom_text_form_field.dart';
import 'package:web_flut/data/default_data.dart';
import 'package:web_flut/models/books/base_book.dart';
import 'package:web_flut/models/books/comic.dart';
import 'package:web_flut/models/books/book_type.dart';
import 'package:web_flut/models/books/novel.dart';
import 'package:web_flut/models/genre.dart';
import 'package:web_flut/models/language.dart';
import 'package:web_flut/models/users/author.dart';
import 'dart:math' as math;

class BookForm extends StatefulWidget {
  final BaseBook? item;
  final BookType bookType;

  const BookForm({super.key, this.item, required this.bookType});

  @override
  State<BookForm> createState() => BookFormState();
}

class BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _authorFirstNameController;
  late TextEditingController _authorLastNameController;
  late TextEditingController _authorBiographyController;
  late TextEditingController _summaryController;
  late TextEditingController _coverImageUrlController;

  Language? _selectedLanguage;
  List<Genre> _selectedGenres = [];
  BookType? _selectedComicType;

  late TextEditingController _pageCountController;
  late TextEditingController _currentPageController;

  late TextEditingController _chaptersController;
  late TextEditingController _currentChapterController;
  late TextEditingController _statusController;

  bool _isReading = false;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
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

    try {
      _selectedLanguage = widget.item?.language != null
          ? defaultLanguages
              .firstWhere((lang) => lang.id == widget.item!.language!.id)
          : defaultLanguages[1];
    } catch (e) {
      _selectedLanguage = defaultLanguages[1]; // Default to English on error
    }

    _selectedGenres = widget.item?.genres ?? [];

    if (widget.item is Novel) {
      final book = widget.item as Novel;
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

    if (widget.item is Comic) {
      final comic = widget.item as Comic;
      _selectedComicType = comic.type;
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
      switch (widget.bookType) {
        case BookType.manga:
          _selectedComicType = BookType.manga;
          break;
        case BookType.manhwa:
          _selectedComicType = BookType.manhwa;
          break;
        case BookType.manhua:
          _selectedComicType = BookType.manhua;
          break;
        default:
          _selectedComicType = BookType.comic;
      }
      _chaptersController = TextEditingController(text: '0');
      _currentChapterController = TextEditingController(text: '0');
      _statusController = TextEditingController(text: 'Ongoing');
    }

    _isReading = widget.item?.isReading ?? false;
    _isFinished = widget.item?.isFinished ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorFirstNameController.dispose();
    _authorLastNameController.dispose();
    _authorBiographyController.dispose();
    _summaryController.dispose();
    _coverImageUrlController.dispose();
    _pageCountController.dispose();
    _currentPageController.dispose();
    _chaptersController.dispose();
    _currentChapterController.dispose();
    _statusController.dispose();
    super.dispose();
  }

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
        dateOfBirth: widget.item?.author.dateOfBirth ?? DateTime.now(),
      );

      switch (widget.bookType) {
        case BookType.novel:
        case BookType.lightNovel:
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
            language: _selectedLanguage,
            genres: _selectedGenres.isNotEmpty ? _selectedGenres : null,
            type: widget.bookType == BookType.lightNovel
                ? BookType.lightNovel
                : BookType.novel,
          );
        case BookType.comic:
        case BookType.manga:
        case BookType.manhwa:
        case BookType.manhua:
          return Comic(
            id: id,
            title: _titleController.text,
            author: author,
            summary: _summaryController.text,
            coverImageUrl: _coverImageUrlController.text,
            type: _selectedComicType ?? BookType.comic,
            genres: _selectedGenres.isNotEmpty ? _selectedGenres : null,
            chapters: int.tryParse(_chaptersController.text) ?? 0,
            currentChapter: int.tryParse(_currentChapterController.text) ?? 0,
            status: _statusController.text,
            isReading: _isReading,
            isFinished: _isFinished,
            updatedAt: DateTime.now(),
            language: _selectedLanguage,
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
          _buildCommonFields(),
          if (widget.bookType == BookType.novel ||
              widget.bookType == BookType.lightNovel)
            _buildBookFields()
          else if (widget.bookType == BookType.comic ||
              widget.bookType == BookType.manga ||
              widget.bookType == BookType.manhwa ||
              widget.bookType == BookType.manhua)
            _buildComicFields(),
          _buildReadingStatusFields(),
        ]
            .map((widget) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: widget))
            .toList(),
      ),
    );
  }

  Widget _buildCommonFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          controller: _titleController,
          labelText: 'Title',
          validator: _validateRequired,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: _authorFirstNameController,
          labelText: 'Author First Name',
          validator: _validateRequired,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: _authorLastNameController,
          labelText: 'Author Last Name (Optional)',
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: _summaryController,
          labelText: 'Summary',
          maxLines: 3,
          validator: _validateRequired,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: _coverImageUrlController,
          labelText: 'Cover Image URL',
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<Language>(
          initialValue: _selectedLanguage,
          decoration: InputDecoration(
            labelText: 'Language',
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: defaultLanguages.map((Language language) {
            return DropdownMenuItem<Language>(
              value: language,
              child: Text(language.name),
            );
          }).toList(),
          onChanged: (Language? newValue) {
            setState(() {
              _selectedLanguage = newValue;
            });
          },
          validator: (value) =>
              value == null ? 'Please select a language' : null,
        ),
      ],
    );
  }

  Widget _buildBookFields() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildGenreSelector(),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: _pageCountController,
          labelText: 'Page Count',
          keyboardType: TextInputType.number,
          validator: _validateNumber,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: _currentPageController,
          labelText: 'Current Page',
          keyboardType: TextInputType.number,
          validator: _validateNumber,
        ),
      ],
    );
  }

  Widget _buildComicFields() {
    return Column(
      children: [
        const SizedBox(height: 16),
        DropdownButtonFormField<BookType>(
          initialValue: _selectedComicType,
          decoration: InputDecoration(
            labelText: 'Type',
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: BookType.values.map((BookType type) {
            return DropdownMenuItem<BookType>(
              value: type,
              child: Text(type.name[0].toUpperCase() + type.name.substring(1)),
            );
          }).toList(),
          onChanged: (BookType? newValue) {
            setState(() {
              _selectedComicType = newValue;
            });
          },
          validator: (value) => value == null ? 'Please select a type' : null,
        ),
        const SizedBox(height: 16),
        _buildGenreSelector(),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: _chaptersController,
          labelText: 'Total Chapters',
          keyboardType: TextInputType.number,
          validator: _validateNumber,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: _currentChapterController,
          labelText: 'Current Chapter',
          keyboardType: TextInputType.number,
          validator: _validateNumber,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: _statusController,
          labelText: 'Status (Ongoing/Completed)',
          validator: _validateRequired,
        ),
      ],
    );
  }

  Widget _buildGenreSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Genres', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        GFMultiSelect<String>(
          items: defaultGenres.map((g) => g.name).toList(),
          onSelect: (selectedNames) {
            setState(() {
              _selectedGenres = defaultGenres
                  .where((genre) => selectedNames.contains(genre.name))
                  .toList();
            });
          },
          initialSelectedItemsIndex: _selectedGenres.map((g) => defaultGenres.indexWhere((dg) => dg.id == g.id)).where((i) => i != -1).toList(),
          dropdownTitleTileText: 'Select Genres',
          dropdownTitleTileColor: Theme.of(context).scaffoldBackgroundColor,
          dropdownTitleTileMargin: const EdgeInsets.all(0),
          dropdownTitleTilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          dropdownUnderlineBorder: const BorderSide(color: Colors.transparent),
          dropdownTitleTileBorder: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
            width: 1,
          ),
          dropdownTitleTileBorderRadius: BorderRadius.circular(12),
          expandedIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          collapsedIcon: const Icon(Icons.keyboard_arrow_up, color: Colors.black54),
          submitButton: const Text('OK'),
          cancelButton: const Text('Cancel'),
          dropdownBgColor: Theme.of(context).scaffoldBackgroundColor,
          activeBgColor: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.2).round()),
          activeBorderColor: Theme.of(context).colorScheme.primary,
          type: GFCheckboxType.basic,
          activeIcon: const Icon(Icons.check, color: Colors.white, size: 15),
          inactiveIcon: null,
        ),
      ],
    );
  }

  Widget _buildReadingStatusFields() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Currently Reading'),
          value: _isReading,
          onChanged: (value) {
            setState(() {
              _isReading = value;
              if (_isReading) {
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
              if (_isFinished) {
                _isReading = false;
              }
            });
          },
        ),
      ],
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

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
