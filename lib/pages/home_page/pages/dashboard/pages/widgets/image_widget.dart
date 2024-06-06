import 'dart:io';

import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget(
      {super.key,
      required this.image,
      required this.onDeletePressed,
      required this.id});

  final int id;
  final File image;
  final Function(int) onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.file(image),
          ),
        ),
        Positioned(
          top: -12,
          right: -16,
          child: IconButton(
            icon: const Icon(
              Icons.delete_rounded,
              color: Colors.red,
            ),
            onPressed: () => onDeletePressed(id),
          ),
        )
      ],
    );
  }
}
