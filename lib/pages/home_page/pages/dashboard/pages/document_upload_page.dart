import 'package:dmtransport/api/api.dart';
import 'package:dmtransport/external/fb_storage.dart';
import 'package:dmtransport/pages/home_page/home_page.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/dashboard_router.dart';
import 'package:dmtransport/pages/home_page/pages/dashboard/models/document_upload_page_data.dart';
import 'package:dmtransport/states/app.state.dart';
import 'package:dmtransport/utils/utils.dart';
import 'package:document_scanner/document_scanner.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentUploadPage extends StatefulWidget {
  const DocumentUploadPage({super.key});

  static const String route = "${DashboardRouter.baseRoute}/doc_upload";

  @override
  State<DocumentUploadPage> createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends State<DocumentUploadPage> {
  bool uploading = false;

  void onUploadingChange(bool value) {
    setState(() {
      uploading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload"),
        automaticallyImplyLeading: !uploading,
      ),
      body: DocUploadPageBody(
        onUploadingChange: onUploadingChange,
      ),
    );
  }
}

class DocUploadPageBody extends StatefulWidget {
  const DocUploadPageBody({
    super.key,
    required this.onUploadingChange,
  });

  final void Function(bool) onUploadingChange;

  @override
  State<DocUploadPageBody> createState() => _DocUploadPageBodyState();
}

class _DocUploadPageBodyState extends State<DocUploadPageBody> {
  final TextEditingController _textEditingController = TextEditingController();
  bool uploading = false;
  bool uploadSuccess = false;
  double progress = 0.0;

  late DocumentUploadPageData _documentUploadPageData;
  late Reference _uploadRef;
  late UploadTask _uploadTask;

  void _onProgress(double value) {
    setState(() {
      progress = value;
    });
  }

  void _onSuccess() {
    var appState = Provider.of<AppStateNotifier>(context, listen: false);

    _uploadRef.getDownloadURL().then((url) async {
      Api.uploadDocument(
        appState.user.name,
        appState.user.image,
        url,
        _uploadRef.fullPath,
        _documentUploadPageData.documentType,
        _textEditingController.text,
        appState.user.email,
        appState.user.category,
        appState.loginToken,
      ).then((value) {
        DocumentScanner.clearScan();

        var snackBar = SnackBar(
          content: Text(
            'File Successfully Uploaded',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.green),
          ),
        );

        appState.addDocument(
          sanitizeDate(DateTime.now()),
          value!,
        );

        setState(() {
          uploadSuccess = true;
          uploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.of(context).popUntil(
          ModalRoute.withName(HomePage.id),
        );
      }).onError((error, stackTrace) {
        debugPrint("Api error for upload: $error");
        _showErrorSnackBar(error.toString());
      });
    });
  }

  void _onError(String? msg) {
    uploading = false;
    debugPrint("Error while uploading $msg");
  }

  void _showErrorSnackBar(String msg) {
    var snackBar = SnackBar(
      content: Text(
        msg,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.red),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onCancel() {
    _showErrorSnackBar('File Upload Canceled');
  }

  void _upload() {
    var appState = Provider.of<AppStateNotifier>(context, listen: false);
    var (uploadTask, uploadRef) = FbStorage.uploadDocument(
      _documentUploadPageData.document,
      {
        "document_type": _documentUploadPageData.documentType,
        "uploaded_by": appState.user.name
      },
    );

    setState(() {
      _uploadTask = uploadTask;
      _uploadRef = uploadRef;
    });

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
          debugPrint("uploading $progress");
          _onProgress(progress);
          break;
        case TaskState.canceled:
          _onCancel();
          break;
        case TaskState.success:
          _onSuccess();
          break;
        default:
          break;
      }
    }).onError((error, stackTrace) {
      _onError(error.toString());
    });
  }

  void onUploadPress() {
    setState(() {
      uploading = true;
      widget.onUploadingChange(true);
    });

    _upload();
  }

  void onUploadCancelPressed() {
    setState(() {
      uploading = false;
      widget.onUploadingChange(false);
    });

    _uploadTask.cancel();
    _onCancel();
  }

  @override
  Widget build(BuildContext context) {
    _documentUploadPageData =
        ModalRoute.of(context)!.settings.arguments as DocumentUploadPageData;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DocumentInfo(data: _documentUploadPageData),
          const SizedBox(
            height: 24.0,
          ),
          NoteTextBox(
            textEditingController: _textEditingController,
            enabled: !uploading,
          ),
          const SizedBox(
            height: 24,
          ),
          !uploading
              ? UploadButton(onPress: () => onUploadPress())
              : Uploading(
                  progress: progress,
                  onUploadCancelPressed: onUploadCancelPressed,
                ),
        ],
      ),
    );
  }
}

class Uploading extends StatelessWidget {
  const Uploading({
    super.key,
    required this.progress,
    required this.onUploadCancelPressed,
  });

  final double progress;
  final void Function() onUploadCancelPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Uploading your document. Please wait.",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(
          height: 4.0,
        ),
        Text(
          "You can't navigate back while document is uploading.",
          style: Theme.of(context).textTheme.titleSmall,
          softWrap: true,
        ),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5.0,
              ),
            ),
            const SizedBox(width: 8.0),
            Text("${(progress * 100).toStringAsPrecision(3)} %"),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              onPressed: onUploadCancelPressed,
              icon: const Icon(Icons.cancel_rounded),
              label: const Text("Cancel"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                surfaceTintColor: Colors.red,
                side: const BorderSide(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class UploadButton extends StatelessWidget {
  const UploadButton({
    super.key,
    required this.onPress,
  });

  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: onPress,
          child: const Row(
            children: [
              Icon(Icons.upload_rounded),
              SizedBox(height: 8.0),
              Text("Upload"),
            ],
          ),
        ),
      ],
    );
  }
}

class NoteTextBox extends StatelessWidget {
  const NoteTextBox({
    super.key,
    required TextEditingController textEditingController,
    required this.enabled,
  }) : _textEditingController = textEditingController;

  final TextEditingController _textEditingController;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      minLines: 1,
      maxLines: 10,
      enabled: enabled,
      decoration: InputDecoration(
        label: Text(
          "Note",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        hintText: "Enter a note",
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: const Color.fromARGB(255, 245, 245, 245),
      ),
    );
  }
}

class DocumentInfo extends StatelessWidget {
  const DocumentInfo({
    super.key,
    required this.data,
  });

  final DocumentUploadPageData data;
  @override
  Widget build(BuildContext context) {
    String docName = data.document.path.split("/").last;
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Document Name",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Tooltip(
                message: docName,
                child: Text(
                  docName,
                  style: Theme.of(context).textTheme.bodyMedium,
                  // softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          children: [
            Text(
              "Document Type",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              data.documentType,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
