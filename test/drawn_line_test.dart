import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note/models/drawn_line.dart';

void main() {
  test('test fking drawnline serilization', () async {
    await Hive.initFlutter();
    Hive.registerAdapter<DrawnLine>(DrawnLineAdapter());
    Hive.registerAdapter<Offset>(OffsetAdapter());
    final box = await Hive.openBox<DrawnLine>('DL');
    box.add(DrawnLine([const Offset(8, 7)], 122, 3));
    expect(box.values.length, 1);
    for (final line in box.values) {
      expect(line.path, contains(const Offset(8, 7)));
    }
    for (final p in box.values) {
      for (final pp in p.path) {
        print(pp);
      }
    }
  });
}
