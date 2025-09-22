import 'package:flutter/material.dart';
import 'package:web_flut/models/book.dart';
import 'package:web_flut/models/comic.dart';
import 'package:web_flut/models/library_item.dart';

class LibraryItemForm extends StatefulWidget {
  final LibraryItem? item;
  final bool isKomik;
  const LibraryItemForm({super.key, this.item, required this.isKomik});

  @override
  State<LibraryItemForm> createState() => LibraryItemFormState();
}

class LibraryItemFormState extends State<LibraryItemForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _summaryController;
  late TextEditingController _countController;
  late TextEditingController _coverController;
  late TextEditingController _genreController;
  late TextEditingController _typeController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item?.title);
    _authorController = TextEditingController(text: (widget.item is Book) ? (widget.item as Book).author : (widget.item is Comic) ? (widget.item as Comic).author : '');
    _summaryController = TextEditingController(text: (widget.item is Book) ? (widget.item as Book).summary : (widget.item is Comic) ? (widget.item as Comic).summary : '');
    _countController = TextEditingController(text: (widget.item is Book) ? (widget.item as Book).pageCount.toString() : (widget.item is Comic) ? (widget.item as Comic).chapters.toString() : '');
    _coverController = TextEditingController(text: (widget.item is Book) ? (widget.item as Book).coverImageUrl : (widget.item is Comic) ? (widget.item as Comic).coverImageUrl : '');
    _genreController = TextEditingController(text: (widget.item is Comic) ? (widget.item as Comic).genre : '');
    _typeController = TextEditingController(text: (widget.item is Comic) ? (widget.item as Comic).type : '');
    _statusController = TextEditingController(text: (widget.item is Comic) ? (widget.item as Comic).status : '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _summaryController.dispose();
    _countController.dispose();
    _coverController.dispose();
    _genreController.dispose();
    _typeController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  LibraryItem? saveAndGetItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.isKomik) {
        return Comic(
          id: widget.item?.id ?? 'new',
          title: _titleController.text,
          author: _authorController.text,
          type: _typeController.text,
          genre: _genreController.text,
          summary: _summaryController.text,
          chapters: int.tryParse(_countController.text) ?? 0,
          currentChapter: 0,
          coverImageUrl: _coverController.text,
          status: _statusController.text,
          isReading: false,
          isFinished: false,
          insertedAt: DateTime.now(),
        );
      } else {
        return Book(
          id: widget.item?.id ?? 'new',
          title: _titleController.text,
          author: _authorController.text,
          summary: _summaryController.text,
          pageCount: int.tryParse(_countController.text) ?? 0,
          coverImageUrl: _coverController.text,
          currentPage: 0,
          isReading: false,
          isFinished: false,
          insertedAt: DateTime.now(),
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
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            controller: _authorController,
            decoration: const InputDecoration(labelText: 'Author'),
            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            controller: _summaryController,
            decoration: const InputDecoration(labelText: 'Summary'),
            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            controller: _countController,
            decoration: InputDecoration(labelText: widget.isKomik ? 'Chapters' : 'Page Count'),
            keyboardType: TextInputType.number,
            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            controller: _coverController,
            decoration: const InputDecoration(labelText: 'Cover Image URL'),
          ),
          if (widget.isKomik) ...[
            TextFormField(
              controller: _genreController,
              decoration: const InputDecoration(labelText: 'Genre'),
            ),
            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Type (Manga/Manhwa/Manhua)'),
            ),
            TextFormField(
              controller: _statusController,
              decoration: const InputDecoration(labelText: 'Status (Ongoing/Completed)'),
            ),
          ],
        ],
      ),
    );
  }
}