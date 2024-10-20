import 'package:flutter/material.dart';
import 'package:my_simple_note/Pages/Create_Note/create_notes.dart';
import 'package:my_simple_note/Pages/Home/Widget/notes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        centerTitle: true,
      ),

      // Wrapping with Stack to position FloatingActionButton on top
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 3 / 2.5, // Adjust this ratio for item height
              ),
              itemCount: 20, // Replace this with your dynamic count of notes
              itemBuilder: (context, index) {
                return const Notes();
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
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
