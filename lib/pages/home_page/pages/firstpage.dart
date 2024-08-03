import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import '../../../utils/data.dart';
import 'dashboard/dashboard_router.dart';
import 'dashboard/models/document_upload_page_data.dart';
import 'dashboard/pages/document_type_selector_page.dart';
import 'dashboard/pages/document_upload_page.dart';
import 'dashboard/pages/pdf_preview_page.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({Key? key}) : super(key: key);

  @override
  _FirstpageState createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  final picker = ImagePicker();
  List<File> images = [];
  List<File> savedImages = [];
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _flashOn = false;
  bool filterApplied = false;
  File? originalImg;
  bool isLoading = false;
  bool showSavedImagesGrid = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    loadSavedImages();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const route = "${DashboardRouter.baseRoute}/pdf_preview";

  Future<void> loadSavedImages() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? imagePaths = prefs.getStringList('saved_images');
    if (imagePaths != null) {
      setState(() {
        savedImages = imagePaths.map((path) => File(path)).toList();
      });
    }
  }

  Future<void> saveImagesToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> imagePaths = images.map((file) => file.path).toList();
    prefs.setStringList('saved_images', imagePaths);
  }

  Future<void> clearImagesFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('saved_images');
  }

  @override
  Widget build(BuildContext context) {
    final allImages = [...images, ...savedImages];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        centerTitle: true,
        actions: [
          if (images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(
                onPressed: generateAndPrintPDF,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 197, 206, 166),
                  ),
                ),
                child: const Text(
                  'PDF',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              FloatingActionButton(
                heroTag: 'gallery',
                elevation: 0.0,
                child: const Icon(Icons.image),
                backgroundColor: const Color.fromARGB(255, 197, 206, 166),
                onPressed: getImageFromGallery,
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                heroTag: 'camera',
                elevation: 0.0,
                child: const Icon(Icons.camera),
                backgroundColor: const Color.fromARGB(255, 197, 206, 166),
                onPressed: getImageFromCamera,
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                heroTag: 'delete',
                elevation: 0.0,
                child: const Icon(Icons.delete),
                backgroundColor: const Color.fromARGB(255, 197, 206, 166),
                onPressed: () {
                  removeImage();
                  saveImagesToPreferences();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              FloatingActionButton(
                heroTag: 'upload_file',
                onPressed: () async {
                  if (images.isNotEmpty) {
                    final File? generatedPDF = await generatePDF();
                    if (generatedPDF != null) {
                      Navigator.pushNamed(context, PdfPreviewPage.route, arguments: PdfPreviewPageArgs(file: generatedPDF));
                      print('PDF generated');
                    } else {
                      print('No PDF generated');
                    }
                  }
                },
                backgroundColor: const Color.fromARGB(255, 197, 206, 166),
                child: const Icon(Icons.upload_file, color: Colors.black),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                heroTag: 'open_grid',
                onPressed: () {
                  setState(() {
                    showSavedImagesGrid = !showSavedImagesGrid;
                  });
                },
                backgroundColor: const Color.fromARGB(255, 197, 206, 166),
                child: const Icon(Icons.grid_view, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          if (showSavedImagesGrid)
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: allImages.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      showSavedImagesGrid = false;
                    });
                  },
                  child: Image.file(allImages[index], fit: BoxFit.cover),
                );
              },
            )
          else
            images.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Select Image From Camera or Gallery',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 6, 6, 6),
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Press remove once to remove filter, twice to delete image.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 6, 6, 6),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: images.length,
                    itemBuilder: (BuildContext context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Stack(
                          children: [
                            if (isLoading && index + 1 == images.length)
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            else
                              Image.file(images[index]),
                            if (index + 1 == images.length)
                              Positioned(
                                top: 10,
                                right: 10,
                                child: filterApplied
                                    ? Row(
                                        children: [
                                          FloatingActionButton(
                                            onPressed: () {
                                              setState(() {
                                                images[index] = originalImg!;
                                                filterApplied = false;
                                              });
                                            },
                                            tooltip: 'Remove Filter',
                                            child: const Icon(Icons.replay_rounded),
                                          ),
                                          const SizedBox(width: 20),
                                          FloatingActionButton(
                                            onPressed: () {
                                              setState(() {
                                                filterApplied = false;
                                              });
                                            },
                                            tooltip: 'Save',
                                            child: const Icon(Icons.done_rounded),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          FloatingActionButton(
                                            onPressed: () async {
                                              setState(() => isLoading = true);
                                              await applyEcoFilter(images.last);
                                              setState(() => isLoading = false);
                                            },
                                            tooltip: 'Apply Eco Filter',
                                            child: const Icon(Icons.filter),
                                          ),
                                        ],
                                      ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
        ],
      ),
    );
  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedFile = await cropCustomImg(pickedFile);
      if (croppedFile != null) {
        setState(() {
          images.add(croppedFile);
          originalImg = croppedFile;
        });
        saveImagesToPreferences();
      }
    }
  }

  Future<void> getImageFromCamera() async {
    try {
      await _initializeControllerFuture;

      final image = await _controller.takePicture();
      final croppedFile = await cropCustomImg(image);
      if (croppedFile != null) {
        setState(() {
          images.add(croppedFile);
          originalImg = croppedFile;
        });
        saveImagesToPreferences();
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
    _toggleFlash();
  }

  void removeImage() {
    setState(() {
      if (images.isNotEmpty) {
        images.removeLast();
      } else {
        print('No image to remove');
      }
    });
    saveImagesToPreferences();
  }

  Future<File?> cropCustomImg(XFile img) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: img.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      androidUiSettings: const AndroidUiSettings(lockAspectRatio: false),
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  void _toggleFlash() {
    setState(() {
      _flashOn = !_flashOn;
      _controller.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
    });
  }

  Future<void> applyEcoFilter(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes)!;

    final grayscaleImage = img.grayscale(image);
    final adjustedImage = img.adjustColor(
      grayscaleImage,
      contrast: 1.5,
      brightness: 1.3,
    );

    final processedImage = await _saveImage(adjustedImage);

    setState(() {
      images[images.length - 1] = processedImage;
      filterApplied = true;
    });
  }

  Future<File> _saveImage(img.Image image) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File(
      '${tempDir.path}/filtered_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await tempFile.writeAsBytes(img.encodeJpg(image));
    return tempFile;
  }

  Future<File?> generatePDF() async {
    if (images.isNotEmpty) {
      final pdf = pw.Document();

      for (final imageFile in images) {
        final image = pw.MemoryImage(
          imageFile.readAsBytesSync(),
        );

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(image),
              );
            },
          ),
        );
      }

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/example.pdf");
      await file.writeAsBytes(await pdf.save());

      return file;
    } else {
      print('No images to generate PDF');
      return null;
    }
  }

  Future<void> generateAndPrintPDF() async {
    if (images.isNotEmpty) {
      final pdf = pw.Document();

      for (final imageFile in images) {
        final image = pw.MemoryImage(
          imageFile.readAsBytesSync(),
        );

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(image),
              );
            },
          ),
        );
      }

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/example.pdf");
      await file.writeAsBytes(await pdf.save());

      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
      );
    } else {
      print('No images to generate PDF');
    }
  }
}
