import 'package:flutter/material.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:flutter_markdown/flutter_markdown.dart';

class CustomParagraph extends StatelessWidget {
  final String text;
  const CustomParagraph({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: html2md.convert(text),
      styleSheet:
          MarkdownStyleSheet(h3: const TextStyle(fontWeight: FontWeight.bold)),
      onTapLink: (text, href, title) {
        print(text);
        print(href);
        print(title);
      },
    );
    //return Text(text);
  }
}
