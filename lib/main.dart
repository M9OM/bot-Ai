import 'package:aichat/provider/chatMsg_provider.dart';
import 'package:aichat/provider/model_provider.dart';
import 'package:aichat/screens/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'models/chat_model.dart';

Future<void> main() async {
  //   await Hive.initFlutter();

  // var box = await Hive.openBox('ChatListData');
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
            theme: ThemeData(
              iconTheme: const IconThemeData(color: Colors.white),
              
          primaryColor: Colors.black, // Set primary color to black
          textTheme: const TextTheme(
            bodyText1: TextStyle(color: Colors.white,fontFamily: 'Orbitron'), // Set body text color to black
            bodyText2: TextStyle(color: Colors.white,fontFamily: 'Orbitron'), 
            // Set body text color to black
            // Add more text styles here as needed
          ),

          
        ),
    
        home:  const ChatScreen(),
      ),
    );
  }
}
