import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class Buble extends StatelessWidget {
  const Buble({
    Key? key,
    required this.isMe,
    required this.text,
  }) : super(key: key);

  final bool isMe;
  final String text;

  @override
  Widget build(BuildContext context) {
    Color meColor = const Color.fromARGB(255, 46, 46, 46);
    LinearGradient aiColor =
        const LinearGradient(colors: [Colors.indigo, Colors.indigo]);
    AlignmentGeometry meAlignment = Alignment.topRight;
    AlignmentGeometry aiAlignment = Alignment.topLeft;
    EdgeInsetsGeometry padding = const EdgeInsets.all(15);
    BorderRadiusGeometry borderRadius_ = BorderRadius.circular(30);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Align(
        alignment: isMe ? meAlignment : aiAlignment,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: isMe

              // user buble

              ? Container(
                  padding: padding,
                  decoration: BoxDecoration(
                    color: meColor,
                    borderRadius: borderRadius_,
                  ),
                  child: Text(text),
                )
              :

              // Ropot buble
              Row(
                  children: [
                    Image.asset(
                      'assets/image/ailogo.png',
                      width: 35,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        padding: padding,
                        decoration: BoxDecoration(
                          gradient: aiColor,
                          borderRadius: borderRadius_,
                        ),
                        child: Text(text),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
