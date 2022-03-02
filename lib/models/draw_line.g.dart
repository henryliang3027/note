// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draw_line.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DrawLineAdapter extends TypeAdapter<DrawLine> {
  @override
  final int typeId = 4;

  @override
  DrawLine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DrawLine(
      path: (fields[0] as List).cast<Offset>(),
      colorHex: fields[1] as int,
      width: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DrawLine obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.colorHex)
      ..writeByte(3)
      ..write(obj.width);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawLineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
