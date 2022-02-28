import 'package:note/models/drawn_line.dart';

class DrawLineManager {
  DrawLineManager()
      : undos = <DrawnLine?>[],
        redos = <DrawnLine?>[];

  late List<DrawnLine?> undos;
  late List<DrawnLine?> redos;

  void undo() {
    DrawnLine? line = redos.last;
    redos.removeLast();
    undos.add(line);
  }

  void redo() {
    DrawnLine? line = undos.last;
    undos.removeLast();
    redos.add(line);
  }
}
