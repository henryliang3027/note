import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/bloc/note_bloc.dart';
import 'package:note/repositories/file_repository.dart';
import 'package:note/repositories/note_repository.dart';
import 'package:note/view/note_page.dart';

class App extends StatelessWidget {
  const App(
      {Key? key, required this.noteRepository, required this.fileRepository})
      : super(key: key);

  final NoteRepository noteRepository;
  final FileRepository fileRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NoteRepository>(
          create: (context) => noteRepository,
        ),
        RepositoryProvider<FileRepository>(
          create: (context) => fileRepository,
        ),
      ],
      child: BlocProvider(
        create: (_) => NoteBloc(noteRepository),
        child: MaterialApp(
          title: 'Notes',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const NotePage(),
        ),
      ),
    );
  }
}
