import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/bloc/note_bloc.dart';
import 'package:note/repositories/file_repostory.dart';
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
        )
      ],
      child: BlocProvider(
        create: (_) => NoteBloc(noteRepository),
        child: MaterialApp(
          title: 'Notes',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              background: Colors.grey[50],
            ),
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              foregroundColor: Colors.white,
              backgroundColor: Colors.indigo,
            ),
            useMaterial3: true,
          ),
          home: const NotePage(),
        ),
      ),
    );
  }
}
