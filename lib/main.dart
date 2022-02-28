import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note/app.dart';
import 'package:note/models/drawn_line.dart';
import 'package:note/models/note_model.dart';
import 'package:note/repositories/note_repository.dart';

Future<void> main() async {
  {
    await Hive.initFlutter();
    Hive.registerAdapter<Note>(NoteAdapter());
    Hive.registerAdapter<ImageContent>(ImageContentAdapter());
    Hive.registerAdapter<ImageType>(ImageTypeAdapter());
    Hive.registerAdapter<DrawnLine>(DrawnLineAdapter());
    Hive.registerAdapter<Offset>(OffsetAdapter());
    await Hive.openBox<Note>('Note');
    runApp(App(noteRepository: NoteRepository()));
  }
}
