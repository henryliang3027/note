import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:note/bloc/note_bloc.dart';
import 'package:note/models/drawn_line.dart';
import 'package:note/models/note_model.dart';
import 'package:note/repositories/file_repostory.dart';
import 'package:note/view/note_painter_page.dart';
import 'package:note/view/photo_edit_page.dart';
import 'widgets/color_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'dart:io';

class NoteEditPage extends StatefulWidget {
  const NoteEditPage({
    Key? key,
    required this.isEdit,
    required this.note,
    required this.index,
  }) : super(key: key);

  final bool isEdit;
  final Note? note;
  final int? index;

  @override
  _NoteEditPageState createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _title, _content;
  late int _colorId;
  late List<ImageContent> _imageContents;

  @override
  void initState() {
    _title = widget.note != null ? widget.note!.title : '';
    _content = widget.note != null ? widget.note!.content : '';
    _colorId = widget.note != null ? widget.note!.colorId : 0;

    _imageContents = widget.note != null
        ? widget.note!.imageContents.map((ImageContent e) {
            return ImageContent(
                imageType: e.imageType,
                path: e.path,
                lines: List.from(e.lines));
          }).toList()
        : <ImageContent>[];
    _titleController = TextEditingController(text: _title);
    _contentController = TextEditingController(text: _content);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[_colorId],
      appBar: AppBar(
        //title: const Text('Edit Note'),
        backgroundColor: colors[_colorId],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.check,
            color: Colors.black,
          ),
          onPressed: () {
            if (widget.isEdit) {
              BlocProvider.of<NoteBloc>(context).add(UpdateNoteEvent(
                  widget.index!,
                  Note(
                    title: _titleController.text,
                    content: _contentController.text,
                    colorId: _colorId,
                    imageContents: _imageContents,
                  )));
            } else {
              BlocProvider.of<NoteBloc>(context).add(AddNoteEvent(Note(
                title: _titleController.text,
                content: _contentController.text,
                colorId: _colorId,
                imageContents: _imageContents,
              )));
            }

            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              MdiIcons.paletteOutline,
              color: Colors.black,
            ),
            onPressed: () {
              showModalBottomSheet(
                barrierColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return ColorPicker(
                    onSelectedIndexChanged: (newSelectedIndex) {
                      setState(() {
                        _colorId = newSelectedIndex;
                      });
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...[
                      for (ImageContent imageContent in _imageContents)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: RawMaterialButton(
                            child: Image.file(
                              File(imageContent.path),
                              fit: BoxFit.contain,
                            ),
                            elevation: 0.0,
                            constraints:
                                const BoxConstraints(), //removes empty spaces around of icon
                            shape:
                                const BeveledRectangleBorder(), //circular button
                            fillColor: Colors.transparent, //background color
                            onPressed: () async {
                              if (imageContent.imageType == ImageType.photo) {
                                final int value = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PhotoEditPage(
                                          path: imageContent.path),
                                    ));

                                print('value: $value');
                                if (value == 1) {
                                  setState(() {
                                    _imageContents.remove(imageContent);
                                    File(imageContent.path).delete();
                                  });
                                }
                              } else if (imageContent.imageType ==
                                  ImageType.picture) {
                                final ImageContent newimageContent =
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NotePainterPage(
                                              imageContent: imageContent),
                                        ));

                                //print('value: $value');
                                if (newimageContent != null) {
                                  //if user press system back icon
                                  if (newimageContent.path == '') {
                                    //if user press remove
                                    setState(() {
                                      _imageContents.remove(imageContent);
                                      File(imageContent.path).delete();
                                    });
                                  } else {
                                    // if user does note do anything or modify lines
                                    setState(() {
                                      int index =
                                          _imageContents.indexOf(imageContent);
                                      _imageContents[index] = newimageContent;
                                    });
                                  }
                                }
                              } else {
                                throw Exception('Image Type is not support');
                              }
                            }, //do your action
                          ),
                        ),
                    ],
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Add title',
                        alignLabelWithHint: true,
                      ),
                      controller: _titleController,
                    ),
                    TextFormField(
                      maxLines: 50,
                      decoration: const InputDecoration(
                        hintText: 'Add content',
                        alignLabelWithHint: true,
                      ),
                      controller: _contentController,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              height: 40.0,
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RawMaterialButton(
                    child: const Icon(Icons.camera_alt_outlined),
                    elevation: 0.0,
                    constraints:
                        const BoxConstraints(), //removes empty spaces around of icon
                    shape: const BeveledRectangleBorder(), //circular button
                    fillColor: Colors.transparent, //background color
                    onPressed: () async {
                      List<Media>? res = await ImagesPicker.openCamera(
                        // pickType: PickType.video,
                        pickType: PickType.image,
                        quality: 0.8,
                        maxSize: 800,
                        maxTime: 15,
                      );
                      if (res != null) {
                        ImageContent imageContent = ImageContent(
                          imageType: ImageType.photo,
                          path: res[0].path,
                          lines: <DrawLine>[],
                        );
                        setState(() {
                          _imageContents.add(imageContent);
                        });
                      }
                    }, //do //do your action
                  ),
                  RawMaterialButton(
                    child: const Icon(Icons.photo_outlined),
                    elevation: 0.0,
                    constraints:
                        const BoxConstraints(), //removes empty spaces around of icon
                    shape: const BeveledRectangleBorder(), //circular button
                    fillColor: Colors.transparent, //background color
                    onPressed: () async {
                      List<Media>? res = await ImagesPicker.pick(
                        count: 1,
                        pickType: PickType.image,
                        language: Language.System,
                        maxTime: 30,
                      );
                      print(res);
                      if (res != null) {
                        String newFilePath =
                            await RepositoryProvider.of<FileRepository>(context)
                                .copyToTemporaryDirectory(res[0].path);

                        ImageContent imageContent = ImageContent(
                          imageType: ImageType.photo,
                          path: newFilePath,
                          lines: <DrawLine>[],
                        );
                        setState(() {
                          _imageContents.add(imageContent);
                        });
                      }
                    }, //do your action
                  ),
                  RawMaterialButton(
                    child: const Icon(MdiIcons.drawPen),
                    elevation: 0.0,
                    constraints:
                        const BoxConstraints(), //removes empty spaces around of icon
                    shape: const BeveledRectangleBorder(), //circular button
                    fillColor: Colors.transparent, //background color
                    onPressed: () async {
                      final ImageContent imageContent = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotePainterPage(
                            imageContent: null,
                          ),
                        ),
                      );

                      if (imageContent != null) {
                        setState(() {
                          _imageContents.add(imageContent);
                        });
                      }
                    }, //do your action
                  ),
                  RawMaterialButton(
                    child: const Icon(Icons.mic_none_outlined),
                    elevation: 0.0,
                    constraints:
                        const BoxConstraints(), //removes empty spaces around of icon
                    shape: const BeveledRectangleBorder(), //circular button
                    fillColor: Colors.transparent, //background color
                    onPressed: () {}, //do your action
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
