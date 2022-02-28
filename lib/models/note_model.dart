import 'package:hive/hive.dart';
import 'package:note/models/drawn_line.dart';

part 'note_model.g.dart';

@HiveType(typeId: 1)
class Note {
  Note({
    required this.title,
    required this.content,
    required this.colorId,
    required this.imageContents,
  });

  @HiveField(0)
  final String title;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final int colorId;

  @HiveField(3)
  final List<ImageContent> imageContents;
}

@HiveType(typeId: 2)
class ImageContent {
  ImageContent({
    required this.imageType,
    required this.path,
    required this.lines,
  });

  @HiveField(0)
  final ImageType imageType;

  @HiveField(1)
  final String path;

  @HiveField(2)
  final List<DrawnLine?> lines;
}

@HiveType(typeId: 3)
enum ImageType {
  @HiveField(0)
  photo,

  @HiveField(1)
  picture,
}
