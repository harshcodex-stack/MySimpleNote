import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_simple_note/Pages/Create_Note/create_notes.dart';
import 'package:my_simple_note/Pages/Home/Widget/notes.dart';
import 'package:my_simple_note/Repository/notes_repository.dart';
import '../../Models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  late Future<List<Note>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _refreshNotes(); // Load notes initially
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
              style: TextStyle(
                  color: Colors.black,
              ),


            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: _refreshNotes,
              icon: const Icon(Icons.refresh_rounded))
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
            child: FutureBuilder(
              future: NotesRepository.getNotes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No notes available"),
                    );
                  }
                  return GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 3 / 2.5,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var note = snapshot.data![index];
                      return  MyNotes(note: note);
                    },
                  );
                }
                // Show loading indicator while waiting for data
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),

          // Positioned FloatingActionButton at the bottom right
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const CreateNotes()));
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              child: const Icon(Icons.note_alt_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
