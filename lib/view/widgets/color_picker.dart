import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({Key? key, required this.onSelectedIndexChanged})
      : super(key: key);

  final ValueChanged<int> onSelectedIndexChanged;

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = 0;
    print('initState:_selectedIndex : $_selectedIndex');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          left: 10.0,
          right: 10.0,
        ),
        child: GridView.count(
          crossAxisCount: 4,
          children: List.generate(
            colors.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    print('selectedIndex $_selectedIndex');
                    widget.onSelectedIndexChanged(index);
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8.0),
                      border: index == _selectedIndex
                          ? Border.all(
                              width: 4.0,
                              color: Colors.orange,
                            )
                          : null,
                      color: colors[index],
                    ),
                    height: 10,
                    width: 10,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

const List<Color> colors = [
  Color.fromARGB(255, 255, 255, 255),
  Color.fromARGB(255, 230, 238, 155),
  Color.fromARGB(255, 128, 222, 234),
  Color.fromARGB(255, 207, 147, 217),
  Color.fromARGB(255, 255, 171, 145),
  Color.fromARGB(255, 255, 204, 128),
  Color.fromARGB(255, 196, 187, 240),
  Color.fromARGB(255, 255, 215, 23),
  Color.fromARGB(255, 255, 199, 199),
  Color.fromARGB(255, 204, 246, 200),
  Color.fromARGB(255, 255, 174, 0),
  Color.fromARGB(255, 21, 255, 0),
  Color.fromARGB(255, 255, 238, 0),
  Color.fromARGB(255, 0, 238, 255),
  Color.fromARGB(255, 0, 102, 255),
  Color.fromARGB(255, 225, 0, 255),
  Color.fromARGB(255, 255, 132, 163),
];
