import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_simple_note/Pages/Create_Note/create_notes.dart';
import 'package:my_simple_note/Pages/Home/Widget/notes.dart';
import 'package:my_simple_note/Repository/notes_repository.dart';
import '../../Models/note.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;

  const HomePage({super.key, required this.onThemeChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Note>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  void _refreshNotes() {
    setState(() {
      _notesFuture = NotesRepository.getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              scale: 12,
            ),
            const SizedBox(width: 10),
            const Text(
              'My Notes',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Switch(
            value: Theme
                .of(context)
                .brightness == Brightness.dark,
            onChanged: (value) {
              widget.onThemeChanged(value);
            },
          ),
        ],
        backgroundColor: Colors.deepPurple[100],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: const Image(
                image: AssetImage('assets/body.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: RefreshIndicator(
              onRefresh: () async {
                _refreshNotes();
                await _notesFuture;
              },
              child: FutureBuilder<List<Note>>(
                future: _notesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("No notes available"),
                      );
                    }
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 3 / 2.5,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var note = snapshot.data![index];
                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CreateNotes(note: note)),
                            );
                            if (result == true) {
                              _refreshNotes();
                            }
                          },
                          child: MyNotes(note: note),
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateNotes()),
                );
                if (result == true) {
                  _refreshNotes();
                }
              },
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .primary,
              foregroundColor: Colors.white,
              child: const Icon(Icons.note_alt_rounded),
            ),
          ),
        ],
      ),
    );
  }
}

