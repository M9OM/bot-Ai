import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/chatMsg_provider.dart';
import '../../provider/model_provider.dart';
import 'widget/buble/buble.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

import 'widget/buble/color/color.dart';

class Message {
  final String text;
  final bool isMe;

  Message({
    required this.text,
    required this.isMe,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _message = [];
  bool _isTyping = false;
  final TextEditingController _textController = TextEditingController();
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final player = AudioPlayer();

  void playSound() async {
    await player.play(AssetSource('image/newmsg.mp3'));
  }
  
Future<String> getTheme() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('theme') ?? 'black'; // Returning a default theme if 'theme' is not found
}
  @override
  void initState() {
getTheme();
    super.initState();
    _listScrollController = ScrollController();
    _textController;
    // db = ChatDataBase();
    // db.loadData();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    _textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // void saveItem(List<ChatModel> textMsg) {
  //   setState(() {
  //     db.chatListData.addAll(textMsg);
  //     db.updateData();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                if (getTheme() == 'blue') {
                  setState(() {
                    // themeChat = 'black';
                  });
                  chatProvider.changeTheme(theme: 'black');
                } else {
                                      // themeChat = 'blue';

                  chatProvider.changeTheme(theme: 'blue');
                }
              },
              child: Icon(
                getTheme() == 'blue'
                    ? Icons.circle_sharp
                    : Icons.cable_rounded,
              )),
          backgroundColor: getTheme() == 'blue'
              ? appBarColorBlue
              : appBarColorBlack,
        ),
        body: Container(
          decoration: BoxDecoration(
            // image: DecorationImage(image: AssetImage('assets/image/chat.png'),fit: BoxFit.cover),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              // ignore: unrelated_type_equality_checks
              colors: getTheme() == 'blue'
                  ? blueBackground
                  : blackBackground,
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: AnimatedList(
                  reverse: true,
                  key: _listKey,
                  controller: _listScrollController,
                  initialItemCount: chatProvider.getChatList.length,
                  itemBuilder: (context, index, animation) {
                    final reversedIndex =
                        chatProvider.getChatList.length - 1 - index;

                    return SizeTransition(
                      sizeFactor: animation,
                      axis: Axis.vertical,
                      child: Buble(
                        text: chatProvider.getChatList[reversedIndex].msg,
                        isMe:
                            chatProvider.getChatList[reversedIndex].chatIndex !=
                                1,
                      ),
                    );
                  },
                ),
              ),
              if (_isTyping)
                Lottie.asset(
                  'assets/image/loading1.json',
                  width: 80,
                ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        maxLines: 4,
                        minLines: 1,
                        style: const TextStyle(color: Colors.white),
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          
                          labelStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Orbitron'
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 35, 46, 110),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.indigoAccent,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    InkWell(
                      onTap: () {
                        playSound();
                        sendMessageFCT(
                          modelsProvider: modelsProvider,
                          chatProvider: chatProvider,
                        );
                        _textController.clear();
                      },
                      child: const Icon(Icons.send_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendMessageFCT({
    required ModelsProvider modelsProvider,
    required ChatProvider chatProvider,
  }) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You can't send multiple messages at a time"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please type a message"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = _textController.text;
      setState(() {
        _isTyping = true;
        _listKey.currentState
            ?.insertItem(0, duration: const Duration(milliseconds: 300));
        chatProvider.addUserMessage(msg: msg);

        // saveItem(chatProvider.getChatList);
        _textController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
        msg: msg,
        chosenModelId: modelsProvider.getCurrentModel,
      );
      _listKey.currentState
          ?.insertItem(0, duration: const Duration(milliseconds: 300));
    } catch (error) {
      debugPrint("error $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        playSound();
        scrollListToEND();

        // saveItem(chatProvider.getChatList);
        _isTyping = false;
      });
    }
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
      _listScrollController.position.minScrollExtent,
      duration: const Duration(microseconds: 1000),
      curve: Curves.easeOut,
    );
  }
}

// class ChatDataBase {
//   List<ChatModel> chatListData = [];
//   final _myBox = Hive.box('ChatListData');

//   void loadData() {
//     chatListData = _myBox.get('chat') ?? [];
//   }

//   void updateData() {
//     _myBox.put('chat', chatListData);
//   }
// }
