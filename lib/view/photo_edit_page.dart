import 'dart:io';

import 'package:flutter/material.dart';

class PhotoEditPage extends StatelessWidget {
  const PhotoEditPage({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Photo'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context, 0);
          },
        ),
        actions: [
          PopupMenuButton(
            onSelected: (value) => Navigator.pop(context, value),
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text("Remove"),
                value: 1,
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(
          child: Image.file(
            File(path),
            fit: BoxFit.contain,
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
