import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:note/bloc/note_bloc.dart';
import 'package:note/models/note_model.dart';
import 'package:note/view/note_edit_page.dart';
import 'package:note/view/widgets/color_picker.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late List<int> _selectedNotes;

  @override
  void initState() {
    print('initState');
    _selectedNotes = <int>[];
    BlocProvider.of<NoteBloc>(context).add(GetNotesEvent());
    super.initState();
  }

  Future<bool?> showConfirmRemoveDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Remove',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        content: const Text('Do you want to remove selected nodes?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build _selectedNotes ${_selectedNotes.length}');
    return Scaffold(
      appBar: AppBar(
        title: _selectedNotes.isNotEmpty
            ? Text('${_selectedNotes.length} selected')
            : const Text('Notes'),
        leading: _selectedNotes.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  setState(
                    () {
                      _selectedNotes.clear();
                    },
                  );
                },
              )
            : null,
        actions: <Widget>[
          BlocBuilder<NoteBloc, NoteState>(
            builder: (context, state) {
              if (state.status == NoteStatus.success) {
                if (_selectedNotes.isNotEmpty) {
                  return IconButton(
                    onPressed: () {
                      _selectedNotes.clear();
                      setState(
                        () {
                          for (int i = 0; i < state.notes.length; i++) {
                            _selectedNotes.add(i);
                          }
                        },
                      );
                    },
                    icon: const Icon(Icons.select_all),
                  );
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            },
          )
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          switch (state.status) {
            case NoteStatus.initial:
              return const Center(
                child: Text('Welcome!!!!!!'),
              );
            case NoteStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case NoteStatus.success:
              return _NoteList(
                notes: state.notes,
                selectedNotes: _selectedNotes,
                onSelectedNotesChanged: (selectedNotes) {
                  setState(
                    () {
                      print('selectedNotes length ${selectedNotes.length}');
                      _selectedNotes = selectedNotes;
                    },
                  );
                },
              );
            case NoteStatus.empty:
              return Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.note_add,
                          size: 200,
                          color: Colors.black12,
                        ),
                      ),
                      TextSpan(
                        text: "\n Add some notes",
                        style: TextStyle(color: Colors.black12, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              );
          }
        },
      ),
      floatingActionButtonLocation:
          _selectedNotes.isEmpty ? FloatingActionButtonLocation.endFloat : null,
      floatingActionButton: _selectedNotes.isEmpty
          ? FloatingActionButton(
              shape: const CircleBorder(
                side: BorderSide.none,
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const NoteEditPage(
                            isEdit: false,
                            note: null,
                            index: null,
                          )),
                    ));
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: _selectedNotes.isEmpty
          ? null
          : _RemoveModeBottomAppBar(
              selectedNotes: _selectedNotes,
              onRemoveSelectedNotes: () async {
                bool? isConfirm = await showConfirmRemoveDialog();

                if (isConfirm != null) {
                  if (isConfirm) {
                    List<int> _tempSelectedNotes =
                        List<int>.from(_selectedNotes);
                    BlocProvider.of<NoteBloc>(context)
                        .add(RemoveNoteEvent(_tempSelectedNotes));
                    setState(() {
                      _selectedNotes.clear();
                    });
                  }
                }
              },
            ),
    );
  }
}

class _NoteList extends StatelessWidget {
  const _NoteList({
    Key? key,
    required this.notes,
    required this.selectedNotes,
    required this.onSelectedNotesChanged,
  }) : super(key: key);

  final List<Note> notes;
  final List<int> selectedNotes;
  final ValueChanged<List<int>> onSelectedNotesChanged;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return Card(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
              border: selectedNotes.contains(index)
                  ? Border.all(
                      width: 4.0,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
            ),
            child: ListTile(
              tileColor: colors[notes[index].colorId],
              title: Text(notes[index].title),
              subtitle: Text(notes[index].content),
              onTap: () {
                if (selectedNotes.isEmpty) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => NoteEditPage(
                              isEdit: true,
                              note: notes[index],
                              index: index,
                            )),
                      ));
                } else {
                  selectedNotes.contains(index)
                      ? selectedNotes.remove(index)
                      : selectedNotes.add(index);
                  onSelectedNotesChanged(selectedNotes);
                }
              },
              onLongPress: () {
                selectedNotes.contains(index) ? null : selectedNotes.add(index);
                onSelectedNotesChanged(selectedNotes);
              },
            ),
          ),
        );
      },
    );
  }
}

class _RemoveModeBottomAppBar extends StatelessWidget {
  const _RemoveModeBottomAppBar(
      {Key? key,
      required this.selectedNotes,
      required this.onRemoveSelectedNotes})
      : super(key: key);

  final List<int> selectedNotes;
  final VoidCallback onRemoveSelectedNotes;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Theme.of(context).colorScheme.primary,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              tooltip: 'Remove',
              icon: const Icon(MdiIcons.trashCan),
              onPressed: () {
                onRemoveSelectedNotes();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.blue,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Add Todo list',
              icon: const Icon(MdiIcons.checkboxMarked),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Add drawing',
              icon: const Icon(MdiIcons.drawPen),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Add photo',
              icon: const Icon(Icons.photo),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
