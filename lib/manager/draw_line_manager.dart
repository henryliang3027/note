import 'package:note/models/drawn_line.dart';

class DrawLineManager {
  DrawLineManager()
      : undos = <DrawLine?>[],
        redos = <DrawLine?>[];

  late List<DrawLine?> undos;
  late List<DrawLine?> redos;

  void undo() {
    DrawLine? line = redos.last;
    redos.removeLast();
    undos.add(line);
  }

  void redo() {
    DrawLine? line = undos.last;
    undos.removeLast();
    redos.add(line);
  }
}
