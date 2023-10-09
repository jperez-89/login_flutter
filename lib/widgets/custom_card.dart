import 'package:flutter/material.dart';
import 'package:login_flutter/theme/app_theme.dart';

class CustomCard extends StatefulWidget {
  final List rows;
  final List header;
  const CustomCard({
    Key? key,
    required this.rows,
    required this.header,
  }) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return widget.rows.isNotEmpty
        ? getCards(widget.rows, widget.header)
        : const Text('');
  }

  getCards(List rows, List header) {
    for (var i = 0; i < rows.length; i++) {
      return Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadowColor: AppTheme.primaryColor.withOpacity(0.8),
        elevation: 15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          children: getCardData(header, rows[i]['groups']),
          // [...getCardData(labelHeaders, rows)]
          // const FadeInImage(
          //   placeholder: AssetImage('asset/image/loading.gif'),
          //   image: AssetImage('asset/image/avatar2.jpg'), //NetworkImage(),
          //   width: double.infinity,
          //   height: 100,
          //   fit: BoxFit.scaleDown,
          //   fadeInDuration: Duration(milliseconds: 300),
          // ),
        ),
      );
    }
  }

  List<Widget> getCardData(List header, List groups) {
    List<Widget> container = [];
    String value = '';

    // Metodo para sustrear los label de la card y datos del beneficiario
    for (var x = 0; x < groups.length; x++) {
      if (groups[x]['field']['control']['modes'][0].containsKey('options')) {
        for (var element in groups[x]['field']['control']['modes'][0]
            ['options']) {
          if (element.containsValue(groups[x]['field']['value'])) {
            value = element['value']['annotation']['label'];
          }
        }
      } else {
        value = groups[x]['field']['value'];
      }

      container.add(Container(
        alignment: AlignmentDirectional.topStart,
        padding: const EdgeInsets.only(right: 10, top: 10, bottom: 5, left: 10),
        child: Text('${header[x]['caption']['value']}: $value'),
      ));
    }
    return container;
  }
}
