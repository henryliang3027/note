import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/models/drawn_line.dart';
import 'package:note/models/note_model.dart';
import 'package:note/patterns/draw_line_manager.dart';
import 'package:note/repositories/file_repostory.dart';
import 'package:note/view/widgets/sketcker.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class NotePainterPage extends StatefulWidget {
  const NotePainterPage({Key? key, required this.imageContent})
      : super(key: key);

  final ImageContent? imageContent;

  @override
  _NotePainterPageState createState() => _NotePainterPageState();
}

class _NotePainterPageState extends State<NotePainterPage> {
  late GlobalKey _globalKey;
  late Color _selectedColor;
  late double _selectedWidth;
  late DrawLineManager _drawLineManager;

  late String? path;
  late List<DrawnLine?> lines;

  @override
  void initState() {
    _globalKey = GlobalKey();
    _selectedColor = Colors.black;
    _selectedWidth = 5.0;

    // path = widget.imageContent != null ? widget.imageContent!.path : null;
    lines = widget.imageContent != null
        ? widget.imageContent!.lines
        : <DrawnLine?>[];

    _drawLineManager = DrawLineManager();
    if (lines.isNotEmpty) {
      _drawLineManager.redos = lines;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade100,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.check, //check icon
            color: Colors.black,
          ),
          onPressed: () async {
            ImageContent? imageContent = await save();
            if (imageContent == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cannot save picture!')));
            } else {
              Navigator.pop(context, imageContent);
            }
          },
        ),
        actions: widget.imageContent == null
            ? null
            : [
                PopupMenuButton(
                  onSelected: (value) => Navigator.pop(
                      context,
                      ImageContent(
                          imageType: ImageType.picture,
                          path: '',
                          lines: _drawLineManager.redos)),
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      child: Text("Remove"),
                      value: 1,
                    ),
                  ],
                ),
              ],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.undo, //undo icon
                color: _drawLineManager.redos.isEmpty
                    ? Colors.grey.shade400
                    : Colors.black,
              ),
              onPressed: _drawLineManager.redos.isEmpty
                  ? null
                  : () {
                      setState(() {
                        _drawLineManager.undo();
                      });
                    },
            ),
            IconButton(
              icon: Icon(
                Icons.redo, //redo icon
                color: _drawLineManager.undos.isEmpty
                    ? Colors.grey.shade400
                    : Colors.black,
              ),
              onPressed: _drawLineManager.undos.isEmpty
                  ? null
                  : () {
                      setState(() {
                        _drawLineManager.redo();
                      });
                    },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          MainCanvas(key: _globalKey, lines: _drawLineManager.redos),
          CurrentCanvas(
            selectedColorHex: _selectedColor.value,
            selectedWidth: _selectedWidth,
            onFinished: (drawnLine) {
              setState(() {
                _drawLineManager.redos.add(drawnLine);
              });
            },
          ),
        ],
      ),
    );
  }

  Future<ImageContent?> save() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData!.buffer.asUint8List();
      String _imageSavePath =
          await RepositoryProvider.of<FileRepository>(context)
              .saveToTemporaryDirectory(pngBytes);

      // if (path != null) {
      //   File(path!).delete();
      // }

      if (_drawLineManager.redos.isEmpty) {
        return ImageContent(
            imageType: ImageType.picture,
            path: _imageSavePath,
            lines: <DrawnLine>[]);
      } else {
        return ImageContent(
            imageType: ImageType.picture,
            path: _imageSavePath,
            lines: _drawLineManager.redos);
      }
    } catch (e) {
      return null;
    }
  }
}

class MainCanvas extends StatefulWidget {
  const MainCanvas({Key? key, required this.lines}) : super(key: key);

  final List<DrawnLine?> lines;

  @override
  State<MainCanvas> createState() => _MainCanvasState();
}

class _MainCanvasState extends State<MainCanvas> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(4.0),
        alignment: Alignment.topLeft,
        child: CustomPaint(
          painter: Sketcher(
            lines: widget.lines,
          ),
        ),
      ),
    );
  }
}

class CurrentCanvas extends StatefulWidget {
  const CurrentCanvas(
      {Key? key,
      required this.selectedColorHex,
      required this.selectedWidth,
      required this.onFinished})
      : super(key: key);

  final int selectedColorHex;
  final double selectedWidth;
  final Function(DrawnLine) onFinished;

  @override
  State<CurrentCanvas> createState() => _CurrentCanvasState();
}

class _CurrentCanvasState extends State<CurrentCanvas> {
  late DrawnLine _currentLine;

  @override
  void initState() {
    _currentLine = DrawnLine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: RepaintBoundary(
        child: Container(
          padding: const EdgeInsets.all(4.0),
          color: Colors.transparent,
          alignment: Alignment.topLeft,
          child: CustomPaint(
            painter: Sketcher(
              lines: [_currentLine],
            ),
          ),
        ),
      ),
    );
  }

  void onPanStart(DragStartDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset point = box.globalToLocal(details.globalPosition);

    _currentLine = DrawnLine(
        path: [Offset(point.dx, point.dy)],
        colorHex: widget.selectedColorHex,
        width: widget.selectedWidth);
  }

  void onPanUpdate(DragUpdateDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset point = box.globalToLocal(details.globalPosition);
    setState(() {
      _currentLine.addPath(point);
    });
  }

  void onPanEnd(DragEndDetails details) {
    print('onPanEnd');
    widget.onFinished(_currentLine);
    _currentLine = DrawnLine();
  }
}
