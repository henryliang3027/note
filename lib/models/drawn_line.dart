import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'drawn_line.g.dart';

@HiveType(typeId: 4)
class DrawLine {
  @HiveField(0)
  final List<Offset> path;

  @HiveField(1)
  final int colorHex;

  @HiveField(3)
  final double width;

  DrawLine(
      {this.path = const <Offset>[],
      this.colorHex = 0x00000000,
      this.width = 0.5});

  void addPath(Offset point) {
    path.add(point);
  }
}

class OffsetAdapter extends TypeAdapter<Offset> {
  @override
  final typeId = 5;

  @override
  Offset read(BinaryReader reader) {
    final pointRaw = reader.read();
    final raws = pointRaw.split('@');
    if (raws.isEmpty) throw Exception();
    final x = double.tryParse(raws.first);
    final y = double.tryParse(raws.last);
    if (x == null || y == null) throw Exception();
    return Offset(x, y);
  }

  @override
  void write(BinaryWriter writer, Offset obj) {
    writer.write('${obj.dx}@${obj.dy}');
  }
}
