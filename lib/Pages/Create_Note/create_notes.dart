import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_simple_note/Models/note.dart';
import 'package:my_simple_note/Repository/notes_repository.dart';
import 'package:share_plus/share_plus.dart';

class CreateNotes extends StatefulWidget {
  final Note? note;
  const CreateNotes({super.key, this.note});

  @override
  State<CreateNotes> createState() => _CreateNotesState();
}

class _CreateNotesState extends State<CreateNotes> {
  final _title = TextEditingController();
  final _noteDescription = TextEditingController();


  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  double _fontSize = 16.0;
  Color _fontColor = Colors.black;

  @override
  void initState() {
    if (widget.note != null) {
      _title.text = widget.note!.title;
      _noteDescription.text = widget.note!.noteDescription;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: widget.note == null ? _insertNotes : _updateNotes,
                icon: const Icon(Icons.save),
              ),
              const SizedBox(width: 5),
              if (widget.note != null)
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: _deleteNote,
                ),
              if (widget.note != null)
                const SizedBox(width: 5),
              if (widget.note != null)
                IconButton(
                  icon: const Icon(Icons.share_rounded),
                  color: Colors.lightBlueAccent,
                  onPressed: _shareNote,
                ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(
                hintText: 'Title..',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _noteDescription,
                decoration: InputDecoration(
                  hintText: 'Note..',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                maxLines: 50,
                style: TextStyle(
                  fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                  decoration: _isUnderline
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  fontSize: _fontSize,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : _fontColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildTextFormatBar(),
          ],
        ),
      ),
    );
  }


  Widget _buildTextFormatBar() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color iconColor = isDarkMode ? Colors.white : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            Icons.format_bold,
            color: _isBold ? Colors.blue : iconColor,
          ),
          onPressed: () {
            setState(() {
              _isBold = !_isBold;
            });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.format_italic,
            color: _isItalic ? Colors.blue : iconColor,
          ),
          onPressed: () {
            setState(() {
              _isItalic = !_isItalic;
            });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.format_underline,
            color: _isUnderline ? Colors.blue : iconColor,
          ),
          onPressed: () {
            setState(() {
              _isUnderline = !_isUnderline;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.color_lens),
          color: _fontColor,
          onPressed: _selectFontColor,
        ),
        DropdownButton<double>(
          value: _fontSize,
          dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
          items: <double>[14, 16, 18, 20, 22, 24].map((double value) {
            return DropdownMenuItem<double>(
              value: value,
              child: Text(
                '${value.toInt()}',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            );
          }).toList(),
          onChanged: (newSize) {
            setState(() {
              _fontSize = newSize!;
            });
          },
        ),
      ],
    );
  }



  Future<void> _selectFontColor() async {
    Color selectedColor = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Font Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _fontColor,
              onColorChanged: (color) {
                setState(() {
                  _fontColor = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(_fontColor);
              },
            ),
          ],
        );
      },
    );
    setState(() {
      _fontColor = selectedColor;
    });
  }

  _insertNotes() async {
    if (_title.text.isEmpty || _noteDescription.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and note description cannot be empty.')),
      );
      return;
    }

    final note = Note(
      title: _title.text,
      noteDescription: _noteDescription.text,
      createdAt: DateTime.now(),
      fontSize: _fontSize,
      fontColor: _fontColor,
      isBold: _isBold,
      isItalic: _isItalic,
      isUnderline: _isUnderline,
    );

    await NotesRepository.insert(note: note);
    Navigator.pop(context, true);
  }

  _updateNotes() async {
    if (_title.text.isEmpty || _noteDescription.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and note description cannot be empty.')),
      );
      return;
    }

    final note = Note(
      id: widget.note!.id!,
      title: _title.text,
      noteDescription: _noteDescription.text,
      createdAt: widget.note!.createdAt,
      fontSize: _fontSize,
      fontColor: _fontColor,
      isBold: _isBold,
      isItalic: _isItalic,
      isUnderline: _isUnderline,
    );

    await NotesRepository.update(note: note);
    Navigator.pop(context, true);
  }

  _deleteNote() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await NotesRepository.delete(note: widget.note!);
      Navigator.pop(context, true);
    }
  }


  _shareNote() {
    final noteText = 'Title: ${_title.text}\n\nNote: ${_noteDescription.text}';

    if (noteText.isNotEmpty) {
      Share.share(noteText);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot share an empty note.')),
      );
    }
  }
}
