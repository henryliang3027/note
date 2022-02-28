import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/bloc/note_bloc.dart';
import 'package:note/repositories/note_repository.dart';
import 'package:note/view/note_page.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.noteRepository}) : super(key: key);

  final NoteRepository noteRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: noteRepository,
      child: BlocProvider(
        create: (_) => NoteBloc(noteRepository),
        child: MaterialApp(
          title: 'Notes',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: const NotePage(),
        ),
      ),
    );
  }
}
