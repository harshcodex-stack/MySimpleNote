import 'package:flutter/material.dart';

class CreateNotes extends StatefulWidget {
  const CreateNotes({super.key});

  @override
  State<CreateNotes> createState() => _CreateNotesState();
}

class _CreateNotesState extends State<CreateNotes> {

  final _title = TextEditingController();
  final _noteDescription = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note..'),
        actions: [
          IconButton(
              onPressed: (){}, 
              icon: const Icon(Icons.save)
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
              ),
            ),
            const SizedBox(height: 16,),
            Expanded(
              child: TextField(
                controller: _noteDescription,
                decoration: InputDecoration(
                    hintText: 'Note..',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                ),
                maxLines: 50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
