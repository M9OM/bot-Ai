class ChatModel {
  final String msg;
  final int chatIndex;

  ChatModel({required this.msg, required this.chatIndex});

  Map<String, dynamic> toJson() => {
        'msg': msg,
        'chatIndex': chatIndex,
      };

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        msg: json['msg'],
        chatIndex: json['chatIndex'],
      );
}