import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login_flutter/models/actions/datapage_actions.dart';

/// crea un widget del tipo Autocomplete
/// los valores a buscar se reciben en una lista de mapas
/// Variables
/// @options -> es la lista con los valores que deben de mostrarse, tambien contiene lo valores que deben almacenarse
///             ejemplo: {key:Toyota,value:TY}
/// @property -> es el identificador de este campo dentro del frmValues
/// @frmValues -> almacena todos los valores guardados en el formulario actual
/// @autoCompleteParamsList -> es una lista que almacena los parametros de todos los autocomplete del formulario actual
/// @dataPagePromptName -> es el nombre que tiene la columna de la datapage donde se encuentra el valor para almacenar "value"
/// @callback -> metodo que se utiliza para redibujar todo el frmbuilder
/// @label -> La etiqueta del campo
/// @initialValue -> valor inicial al renderizar el widget
///
///
class CustomAutoComplete extends StatefulWidget {
  final List options;
  final String property;
  final Map<String, dynamic> frmValues;
  final Map<String, dynamic> autoCompleteParamsList;
  final String dataPagePromptName;
  final Function callback;
  final String label;
  final String? initialValue;

  const CustomAutoComplete(
      {super.key,
      required this.options,
      required this.property,
      required this.frmValues,
      required this.autoCompleteParamsList,
      required this.dataPagePromptName,
      required this.callback,
      required this.label,
      this.initialValue});

  @override
  State<CustomAutoComplete> createState() => _CustomAutoCompleteState();
}

class _CustomAutoCompleteState extends State<CustomAutoComplete> {
  ///@valuesToShow lista que almacena los valores que muestran al usuario "key"
  ///@valuesToSave lista que almacena los valores que se almacenan "value"
  late List<String> valuesToShow;
  late List<String> valuesToSave;

  void extractValues() {
    valuesToShow = [];
    valuesToSave = [];
    for (var map in widget.options) {
      valuesToShow.add(map["key"]);

      ///Honda, Nissan, Hyundai
      valuesToSave.add(map["value"]);

      ///H, NS, HY
    }
  }

  String getInitialValue() {
    ///si se setea un valor inicial que no esta en la lista puede dar error
    String salida = "";
    if (widget.initialValue != null) {
      salida = (valuesToShow.isNotEmpty)
          ? valuesToShow[valuesToSave.indexOf(widget.initialValue!)]
          : "";
    }
    return salida;
  }

  ///Se encarga de buscar cual o cuales autocomplete son dependientes (hijos) de este
  ///y hacer obtene la lista de opciones del(os) hijo(s)
  ///@dataSelected -> representa el valor seleccionado en el autocomplete
  ///****SE DEBE MEJORA LA BUSQUEDA, RECOMIENDO UTILIZAR LA POPIEDAD REFERENCE DEL JSON */
  ///
  void fillData(String dataSelected) {
    if (widget.autoCompleteParamsList.containsKey(widget.dataPagePromptName)) {
      List options = [];
      String myDataPromptName = widget.dataPagePromptName;

      Map<String, dynamic> dependentChild =
          widget.autoCompleteParamsList[myDataPromptName];

      String urlToGet = dependentChild["Endpoint"] + dataSelected;
      DataPageActions().getDataPage(urlToGet).then((value) {
        Map<String, dynamic> json = jsonDecode(value.body);

        for (var result in json["pxResults"]) {
          options.add({
            "key": result[dependentChild["dataPageValue"]],
            "value": result[dependentChild["dataPagePromptName"]]
          });
        }
        widget.autoCompleteParamsList["${widget.dataPagePromptName}/list"] =
            options;
        widget.callback();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    extractValues();
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: getInitialValue()),
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          onEditingComplete: onFieldSubmitted,
          decoration: InputDecoration(
            label: Text(widget.label),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text == "") {
          return [];
        }
        return valuesToShow.where((String element) {
          return element
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String item) {
        widget.frmValues[widget.property] =
            valuesToSave[valuesToShow.indexOf(item)];

        fillData(widget.frmValues[widget.property]);
        //widget.callback();
      },
    );
  }
}
