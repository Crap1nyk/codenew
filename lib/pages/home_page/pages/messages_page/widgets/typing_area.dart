import 'package:dmtransport/models/message.modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TypingArea extends StatefulWidget {
  const TypingArea({super.key, this.onSendMessagePressed});

  final void Function(MessageContent)? onSendMessagePressed;

  @override
  State<TypingArea> createState() => _TypingAreaState();
}

class _TypingAreaState extends State<TypingArea> {
  final TextEditingController _textEditingController = TextEditingController();

  void onMessageSendPress() {
    if (_textEditingController.text.isEmpty) return;

    widget.onSendMessagePressed!(MessageContent(
      message: _textEditingController.text.trim(),
      attachmentUrl: "",
    ));

    _textEditingController.clear();
  }

  late final _textBoxFocusNode = FocusNode(
    onKey: (FocusNode node, RawKeyEvent evt) {
      if (!evt.isShiftPressed && evt.logicalKey.keyLabel == 'Enter') {
        if (evt is RawKeyDownEvent) {
          onMessageSendPress();
        }
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                color: Theme.of(context).highlightColor,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextArea(
                      textEditingController: _textEditingController,
                      focusNode: _textBoxFocusNode,
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(Icons.add_rounded),
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          IconButton(
            onPressed: onMessageSendPress,
            icon: const Icon(
              Icons.send_rounded,
            ),
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              fixedSize: const Size(42, 42),
              backgroundColor: Theme.of(context).highlightColor,
            ),
          )
        ],
      ),
    );
  }
}

class TextArea extends StatelessWidget {
  const TextArea({
    super.key,
    required this.textEditingController,
    required this.focusNode,
  });

  final TextEditingController textEditingController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      focusNode: focusNode,
      minLines: 1,
      maxLines: 10,
      decoration: const InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        hintText: "Send a message",
      ),
    );
  }
}
