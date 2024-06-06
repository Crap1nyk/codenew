enum MessageStatus { sent, seen, sending, unseen }

enum MessageType { sent, recieved }

class MessageContent {
  final String message;
  final String attachmentUrl;

  MessageContent({
    required this.message,
    required this.attachmentUrl,
  });

  factory MessageContent.fromJson(Map<String, dynamic> json) {
    return MessageContent(
      message: json["message"],
      attachmentUrl: json["attachmentUrl"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "attachmentUrl": attachmentUrl,
    };
  }
}

class MessageModel {
  final String id;
  final DateTime dateTime;
  final MessageContent content;
  MessageStatus status;
  final MessageType type;
  final String sendername;

  MessageModel({
    required this.status,
    required this.dateTime,
    required this.content,
    required this.id,
    required this.type,
    required this.sendername,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json["id"],
      dateTime: DateTime.parse(json["dateTime"] ?? DateTime.now().toString()),
      content: MessageContent.fromJson(json["content"].cast<String, dynamic>()),
      status: MessageStatus.values[json["status"]],
      type: MessageType.values[json["type"]],
      sendername: json["sendername"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "dateTime": dateTime.toString(),
      "content": content.toJson(),
      "status": status.index,
      "type": type.index,
      "sendername": sendername,
    };
  }

  get message => content.message;
  bool get recieved => type == MessageType.recieved;

  Map<String, dynamic> get json => toJson();

  Map<String, dynamic> toAdminJson(String phone) {
    return {...json, "contactId": phone, "type": MessageType.recieved.index};
  }
}
