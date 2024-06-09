import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math';
import 'package:dmtransport/external/file_picker_handle.dart';
import 'package:dmtransport/pages/home_page/pages/about_page/notifications_page.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/load_images_page.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/pdf_preview_page.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/pages/trip_envolope_forms.dart';
import 'package:dmtransport/external/fb_storage.dart';
import 'package:dmtransport/states/app.state.dart';
import 'package:dmtransport/utils/assets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Firstpage(),
    );
  }
}

class Firstpage extends StatefulWidget {
  @override
  _FirstpageState createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  final picker = ImagePicker();
  List<File> images = [];
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _flashOn = false;
  bool filterApplied = false;
  File? originalImg;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner App'),
        centerTitle: true,
        actions: [
          if (images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(
                onPressed: generateAndPrintPDF,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 197, 206, 166),
                  ),
                ),
                child: const Text(
                  'PDF',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          if (images.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Select Image From Camera or Gallery',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color.fromARGB(255, 6, 6, 6), fontSize: 20),
                    ),
                    Text(
                      'Press remove once to remove filter, twice to delete image.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color.fromARGB(255, 6, 6, 6), fontSize: 20),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Stack(
                children: [
                  if (isLoading)
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  else
                    Image.file(images.last),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: (filterApplied)
                        ? Row(
                            children: [
                              FloatingActionButton(
                                onPressed: () {
                                  setState(() {
                                    images.last = originalImg!;
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
            ),
          Align(
            alignment: Alignment(-0.7, 0.7),
            child: FloatingActionButton(
              elevation: 0.0,
              child: Icon(Icons.image),
              backgroundColor: Color.fromARGB(255, 197, 206, 166),
              onPressed: getImageFromGallery,
            ),
          ),
          Align(
            alignment: Alignment(0.7, 0.7),
            child: FloatingActionButton(
              elevation: 0.0,
              child: Icon(Icons.camera),
              backgroundColor: Color.fromARGB(255, 197, 206, 166),
              onPressed: getImageFromCamera,
            ),
          ),
          Align(
            alignment: Alignment(0.0, 0.7),
            child: FloatingActionButton(
              elevation: 0.0,
              child: Icon(Icons.delete),
              backgroundColor: Color.fromARGB(255, 197, 206, 166),
              onPressed: removeImage,
            ),
          ),
          Align(
            alignment: Alignment(0.0, 0.9),
            child: FloatingActionButton(
              elevation: 0.0,
              child: Icon(Icons.upload),
              backgroundColor: Color.fromARGB(255, 197, 206, 166),
              onPressed: generateAndUploadPDF,
            ),
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
          images = [File(croppedFile.path)];
        });
      }
    } else {
      print('No image selected');
    }
  }

  Future<void> getImageFromCamera() async {
    try {
      await _initializeControllerFuture;
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final croppedFile = await cropCustomImg(pickedFile);
        if (croppedFile != null) {
          setState(() {
            images = [File(croppedFile.path)];
          });
        }
      } else {
        print('No image selected');
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
      contrast: 1.5, // Adjust this value to increase contrast (1.0 is no change)
      brightness: 1.3, // Adjust this value to increase brightness (0.0 is no change)
    );

    // Save the processed image
    final processedImage = await _saveImage(adjustedImage);

    setState(() {
      images[images.length - 1] = processedImage;
      filterApplied = true;
    });
  }

  Future<File> _saveImage(img.Image image) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/filtered_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await tempFile.writeAsBytes(img.encodeJpg(image));
    return tempFile;
  }

  Future<void> generateAndPrintPDF() async {
    final pdf = pw.Document();
    for (var image in images) {
      final imageBytes = await image.readAsBytes();
      final pdfImage = pw.MemoryImage(imageBytes);
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pdfImage),
            );
          },
        ),
      );
    }
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/document.pdf');
    await file.writeAsBytes(await pdf.save());
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'document.pdf');
  }

  Future<void> generateAndUploadPDF() async {
    final pdf = pw.Document();
    for (var image in images) {
      final imageBytes = await image.readAsBytes();
      final pdfImage = pw.MemoryImage(imageBytes);
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pdfImage),
            );
          },
        ),
      );
    }
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/document.pdf');
    await file.writeAsBytes(await pdf.save());
    await uploadFile(file);
  }

Future<String?> uploadFile(File file) async {
  try {
    
    // Get reference to the PDF file
    String fileName = 'document_${DateTime.now().millisecondsSinceEpoch}.pdf';
    
    // Upload file to Firebase Storage using FbStorage
    var (uploadTask, uploadRef) = FbStorage.uploadDocument(file, {'fileName': fileName});

    // Wait for upload to complete
    await uploadTask;

    // Get download URL
    String downloadURL = await uploadRef.getDownloadURL();

    return downloadURL;
  } catch (e) {
    print('Error uploading PDF: $e');
    return null;
  }
}
}