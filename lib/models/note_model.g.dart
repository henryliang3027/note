// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 1;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      title: fields[0] as String,
      content: fields[1] as String,
      colorId: fields[2] as int,
      imageContents: (fields[3] as List).cast<ImageContent>(),
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.colorId)
      ..writeByte(3)
      ..write(obj.imageContents);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImageContentAdapter extends TypeAdapter<ImageContent> {
  @override
  final int typeId = 2;

  @override
  ImageContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageContent(
      imageType: fields[0] as ImageType,
      path: fields[1] as String,
      lines: (fields[2] as List).cast<DrawnLine?>(),
    );
  }

  @override
  void write(BinaryWriter writer, ImageContent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.imageType)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.lines);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImageTypeAdapter extends TypeAdapter<ImageType> {
  @override
  final int typeId = 3;

  @override
  ImageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ImageType.photo;
      case 1:
        return ImageType.picture;
      default:
        return ImageType.photo;
    }
  }

  @override
  void write(BinaryWriter writer, ImageType obj) {
    switch (obj) {
      case ImageType.photo:
        writer.writeByte(0);
        break;
      case ImageType.picture:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
