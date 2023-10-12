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
    for (var i = 0; i < rows.length;) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Column(
            children: getData(
              header, rows[i]['groups'],
              //     // const FadeInImage(
              //     //   placeholder: AssetImage('asset/image/loading.gif'),
              //     //   image: AssetImage('asset/image/avatar2.jpg'), //NetworkImage(),
              //     //   width: double.infinity,
              //     //   height: 100,
              //     //   fit: BoxFit.scaleDown,
              //     //   fadeInDuration: Duration(milliseconds: 300),
              //     // ),
            ),
          ),
        ),
      );
    }
  }

  List<Widget> getData(List header, List groups) {
    List<Widget> containerListTile = [];
    List data = [];
    String name = '';

    // Metodo para sustrear los label de la card y datos del beneficiario
    for (var x = 0; x < groups.length; x++) {
      if (groups[x]['field']['control']['modes'][0].containsKey('options')) {
        for (var element in groups[x]['field']['control']['modes'][0]
            ['options']) {
          if (element.containsValue(groups[x]['field']['value'])) {
            data.add(element['value']['annotation']['label']);
          }
        }
      } else {
        data.add(groups[x]['field']['value']);
      }

      // Obtengo el nombre del beneficiario
      if (header[x]['caption'].containsValue('Nombre')) {
        name =
            '${groups[x]['field']['value'].toString()} ${groups[x + 1]['field']['value'].toString()} ${groups[x + 2]['field']['value'].toString()}';
      }
    }

    // Agregamos los datos al contenedor
    containerListTile.add(ListTile(
      title: Text(
        name,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryColor),
      ),
      subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getInformationBeneficiarie(header, data)),
      trailing: IconButton(
          iconSize: 35,
          hoverColor: AppTheme.danger,
          onPressed: () {},
          icon: const Icon(
            Icons.delete_forever_rounded,
            color: AppTheme.danger,
          )),
    ));

    return containerListTile;
  }

  getInformationBeneficiarie(header, data) {
    List<Widget> text = [];

    for (var x = 0; x < data.length; x++) {
      if (!header[x]['caption'].containsValue('Nombre') &&
          !header[x]['caption'].containsValue('Primer apellido') &&
          !header[x]['caption'].containsValue('Segundo apellido')) {
        text.add(Text(
          '${header[x]['caption']['value']}: ${data[x].toString()}',
          style: const TextStyle(fontSize: 15),
        ));
      }
    }

    return text;
  }

// Metodo antiguo, no se utiliza
  List<Widget> getCardData(List header, List groups) {
    List<Widget> listContainer = [];
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

      listContainer.add(Container(
        alignment: AlignmentDirectional.topStart,
        padding:
            const EdgeInsets.only(right: 10, top: 10, bottom: 10, left: 15),
        child: Text('${header[x]['caption']['value']}: $value'),
      ));
    }
    return listContainer;
  }
}
