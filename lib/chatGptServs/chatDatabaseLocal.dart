import 'package:hive/hive.dart';


class ChatDataBase {
  List  chatListData = [];

  final _myBox = Hive.box('ChatListData');
  void createdatabase() {
    chatListData = [];
    
  }

 void loadData() {
  chatListData = _myBox.get('chat1133');
}

  void updateData(){
_myBox.put("chat1133", chatListData);
  }
}
