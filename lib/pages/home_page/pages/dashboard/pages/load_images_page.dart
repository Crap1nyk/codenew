import 'dart:io';
import 'package:dmtransport/external/pdf.handle.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/pdf_preview_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../dashboard_router.dart';
import 'widgets/load_images_page_body.dart';

class LoadImagesPage extends StatefulWidget {
  const LoadImagesPage({super.key});
  static const route = "${DashboardRouter.baseRoute}/load_images";

  @override
  State<LoadImagesPage> createState() => _LoadImagesPageState();
}

class _LoadImagesPageState extends State<LoadImagesPage> {
  final List<File> _selectedImages = [];
  final _picker = ImagePicker();

  void _pickFromGallery() {
    _picker
        .pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    )
        .then((pickedFiles) {
      setState(
        () {
          if (pickedFiles.isNotEmpty) {
            for (var i = 0; i < pickedFiles.length; i++) {
              _selectedImages.add(File(pickedFiles[i].path));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nothing is selected')));
          }
        },
      );
    });
  }

  void _pickFromCamera() {
    _picker.pickImage(source: ImageSource.camera).then((pickedFile) {
      setState(
        () {
          if (pickedFile != null) {
            _selectedImages.add(File(pickedFile.path));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nothing is selected')));
          }
        },
      );
    });
  }

  void _onImageDeleted(int idx) {
    setState(() {
      _selectedImages.removeAt(idx);
    });
  }

  void _onUploadPressed(BuildContext context) {
    PdfHandle.imagesToPdf(_selectedImages).then(
      (file) => Navigator.of(context).pushNamed(
        PdfPreviewPage.route,
        arguments: PdfPreviewPageArgs(file: file, docType: "load_image"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Images"),
        actions: _selectedImages.isNotEmpty
            ? [
                IconButton(
                  onPressed: () => _onUploadPressed(context),
                  icon: const Icon(Icons.upload_rounded),
                ),
              ]
            : null,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "Capture from camera",
            onPressed: _pickFromCamera,
            label: const Text("Camera"),
            icon: const Icon(Icons.camera_alt_rounded),
          ),
          const SizedBox(
            height: 16,
          ),
          FloatingActionButton.extended(
            heroTag: "Pick from gallery",
            onPressed: _pickFromGallery,
            label: const Text("Gallery"),
            icon: const Icon(Icons.image_rounded),
          ),
        ],
      ),
      body: LoadImagesPageBody(
        selectedImages: _selectedImages,
        onImageDeleted: _onImageDeleted,
      ),
    );
  }
}
