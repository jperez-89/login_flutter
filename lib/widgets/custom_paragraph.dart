import 'package:flutter/material.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:login_flutter/widgets/widgets.dart';

///crea un widget e tercero para mostrar parrafos
///utiliza el paquete flutter_Markdown para rendereizar texto previamente enmarcado
///utiliza el paquete html2md para convertir las etiquetas Html a enmarcado que reconoce flutter:markdown
///utiliza el widget Custom_webView.dart parar abrir en navegador los links del texto
class CustomParagraph extends StatelessWidget {
  final String text;
  const CustomParagraph({super.key, required this.text});

  ///abre el link en el navegador
  openWeb(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CustomWebView(href: url)));
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: html2md.convert(text),
      styleSheet:
          MarkdownStyleSheet(h3: const TextStyle(fontWeight: FontWeight.bold)),
      onTapLink: (text, href, title) {
        openWeb(context, href!);
      },
    );
    //return Text(text);
  }
}
