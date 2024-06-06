import 'dart:io';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/widgets/images_widget.dart';
import 'package:flutter/material.dart';

class LoadImagesPageBody extends StatelessWidget {
  const LoadImagesPageBody({
    super.key,
    required this.selectedImages,
    required this.onImageDeleted,
  });

  final List<File> selectedImages;
  final Function(int) onImageDeleted;

  @override
  Widget build(BuildContext context) {
    return selectedImages.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ImagesWidget(
                    images: selectedImages,
                    onImageDeleted: onImageDeleted,
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: Text(
              "No Images Selected",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
  }
}
