// // lib/functions/chat_functions.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../chatGptServs/chatDatabaseLocal.dart';
// import '../provider/chatMsg_provider.dart';
// import '../provider/model_provider.dart';
// import '../models/chat_model.dart';

// class ChatFunctions {
//   static Future<void> sendMessage({
//     required BuildContext context,
//     required String message,
//   }) async {
//     final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
//     final chatProvider = Provider.of<ChatProvider>(context, listen: false);
//     final db = ChatDataBase();

//     try {
//       // Add the message to the local chat list
//       db.chatListData.add(ChatModel(msg: message, chatIndex: 0));
//       db.updateData();

//       // Add the message to the chat provider
//       chatProvider.addUserMessage(msg: message);

//       // Send the message and get responses
//       await chatProvider.sendMessageAndGetAnswers(
//         msg: message,
//         chosenModelId: modelsProvider.getCurrentModel,
//       );
//     } catch (error) {
//       debugPrint("Error sending message: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error sending message"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }
