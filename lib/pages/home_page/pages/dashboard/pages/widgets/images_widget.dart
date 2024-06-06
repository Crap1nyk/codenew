import 'dart:io';

import 'package:dmtransport/pages/home_page/pages/dashboard/pages/widgets/image_widget.dart';
import 'package:flutter/material.dart';

class ImagesWidget extends StatefulWidget {
  const ImagesWidget({
    super.key,
    required this.images,
    required this.onImageDeleted,
  });

  final List<File> images;
  final Function(int) onImageDeleted;

  @override
  State<ImagesWidget> createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      crossAxisCount: 3,
      children: widget.images
          .map(
            (image) => ImageWidget(
              id: widget.images.indexOf(image),
              image: image,
              onDeletePressed: widget.onImageDeleted,
            ),
          )
          .toList(),
    );
  }
}
