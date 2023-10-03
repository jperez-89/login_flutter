import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CustomParagraph extends StatelessWidget {
  final String text;
  const CustomParagraph({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    /*return SingleChildScrollView(
      child: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(text: text, style: TextStyle(color: Colors.black))),
    );*/
    return Text(text);
    /*return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 100),
      child: Markdown(data: text),
    );*/
  }
}
