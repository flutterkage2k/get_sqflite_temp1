import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_sqflite_temp1/add_note_screen.dart';
import 'package:get_sqflite_temp1/database/database.dart';
import 'package:get_sqflite_temp1/models/note_model.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Note>> _noteList;

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _updateNoteList();
  }

  _updateNoteList() {
    _noteList = DatabaseHelper.instance.getNoteList();
  }

  Widget _buildNote(Note note) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          ListTile(
              title: Text(
                note.title!,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                ),
              ),
              subtitle: Text(
                '${_dateFormatter.format(note.date!)}',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                ),
              ),
              onTap: () {
                Get.to(() => AddNoteScreen());
              }),
          Divider(
            height: 5.0,
            color: Colors.deepPurple,
            thickness: 2.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Get.to(() => AddNoteScreen());
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: _noteList,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final int completeNoteCount = snapshot.data!
                .where((Note note) => note.status == 1)
                .toList()
                .length;
            return ListView.builder(
              itemCount: int.parse(snapshot.data!.length.toString()) + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '$completeNoteCount of ${snapshot.data.length}',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }
                return _buildNote(snapshot.data![index - 1]);
              },
            );
          }),
    );
  }
}
