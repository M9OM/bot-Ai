import 'package:flutter/cupertino.dart';
import '../chatGptServs/chatGptServ.dart';
import '../models/chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ChatProvider with ChangeNotifier {
  String themeChat = '';

  List<ChatModel> chatList = [
    ChatModel(
        chatIndex: 1,
        msg:
            "👨‍💻 Hey there, I'm Mohammed, and I'm crushing it as a programmer! 💥 Whether it's coding up a storm or debugging like a pro, I'm always at the top of my game. 🚀 Bring on the challenges, because I'm ready to conquer them all! 💪")
  ];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  void changeTheme({required String theme}) async{
     
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    themeChat = prefs.getString('theme')!;
    print(themeChat);
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(await ApiService.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
      ));
    } else {
      chatList.addAll(await ApiService.sendMessage(
        message: msg,
        modelId: chosenModelId,
      ));
    }
    notifyListeners();
  }
}
