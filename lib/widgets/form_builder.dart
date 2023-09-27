import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_flutter/models/actions/assignment_actions.dart';
import 'package:login_flutter/widgets/widgets.dart';
import 'package:login_flutter/models/services/service.dart';

class FormBuilderWidget extends StatefulWidget {
  final String pzInsKey;

  const FormBuilderWidget({Key? key, required this.pzInsKey}) : super(key: key);

  @override
  State<FormBuilderWidget> createState() => _FormBuilderWidgetState();
}

class _FormBuilderWidgetState extends State<FormBuilderWidget> {
  GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
  List components = [];
  bool _load = false;
  final Map<String, dynamic> dataPagePrompt = {};

  void callback() {
    setState(() {});
  }

  // Obtenemos los campos del formulario del assignment
  void getAssiggnment(String pzInsKey) async {
    // Mostramos loader
    setState(() {
      _load = true;
    });

    await AssignmentActions().getAssignment(pzInsKey).then((value) {
      setState(() {
        components = value["components"];
      });
    });

    // Ocultamos loader
    setState(() {
      _load = false;
    });
  }

  @override
  void initState() {
    getAssiggnment(widget.pzInsKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _load
        ? Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 100),
            child: const CircularProgressIndicator.adaptive(),
          )
        : FormBuilder(
                context: context,
                callback: callback,
                dataPagePrompt: dataPagePrompt)
            .buildForm(components, myFormKey);
  }
}

class FormBuilder {
  final Map<String, String> frmValues = {};
  final BuildContext context;
  final Function callback;
  final Map<String, dynamic> dataPagePrompt;

  FormBuilder(
      {required this.context,
      required this.callback,
      required this.dataPagePrompt});

  Widget buildForm(List components, GlobalKey<FormState> myFormKey) {
    List<Widget> childs = [];
    if (components.isNotEmpty) {
      for (var component in components) {
        childs.add(createWidgets(component) ?? const Text("vacio"));
      }
      childs.add(getSaveButton(myFormKey));
    }
    return Form(key: myFormKey, child: Column(children: childs));
  }

  /// ******  BORRAR ESTA MADRE O SACARLO A  OTRO LADO ***************
  ElevatedButton getSaveButton(GlobalKey<FormState> myFormKey) {
    return ElevatedButton(
        onPressed: () {
          if (!myFormKey.currentState!.validate()) {
            showMessage('Error', 'Complete todos los campos');
            return;
          } else {
            print(frmValues);
          }
        },
        child: const Text("Guardar"));
  }

  void showMessage(String title, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ), // Titulo de la card
            content: Column(
              mainAxisSize:
                  MainAxisSize.min, // Ajusta la card al texto mas pequenho
              children: [
                Text(message),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Ok'))
            ],
          );
        });
  }

  /********* CREATORS  ******* */

  CustomCaption createCaption(Map<String, dynamic> caption) {
    return CustomCaption(value: caption["value"], fontSize: 20);
  }

  CustomAutoComplete createPxAutoComplete(Map<String, dynamic> pxAutoComplete) {
    List options = [];
    String dataPagePromptName = getDataPagePromptName(pxAutoComplete);
    if (haveParameters(pxAutoComplete)) {
      String parameterName = getDataPageParams(pxAutoComplete);
      if (dataPagePrompt.containsKey(parameterName)) {
        String dataPageID = getDataPageID(pxAutoComplete);
        String dataPageValue = getDataPageValue(pxAutoComplete);
        String urlToGet =
            "$dataPageID?$parameterName=${dataPagePrompt['$parameterName']}";
        if (!dataPagePrompt.containsKey("$dataPagePromptName/list")) {
          Datapages().getDataPage(urlToGet).then((value) {
            Map<String, dynamic> json = jsonDecode(value.body);
            for (var result in json["pxResults"]) {
              options.add({
                "key": result[dataPageValue],
                "value": result[dataPagePromptName]
              });
            }
            dataPagePrompt["$dataPagePromptName/list"] = options;
            callback();
          });
        } else {
          options = dataPagePrompt["$dataPagePromptName/list"];
          dataPagePrompt.remove("$dataPagePromptName/list");
        }
      }
    } else {
      options = getModes(pxAutoComplete, 0)["options"];
    }
    return CustomAutoComplete(
      label: getFieldLabel(pxAutoComplete),
      options: options,
      property: getFieldID(pxAutoComplete),
      frmValues: frmValues,
      dataPagePrompt: dataPagePrompt,
      dataPagePromptName: dataPagePromptName,
      callback: callback,
    );
  }

  Wrap createPxRadioButtom(Map<String, dynamic> pxRadioButton) {
    /** SE REEMPLAZÓ POR LOS DROPDOWN */
    final size = MediaQuery.of(context).size;
    List radioButtons = [];
    int maxElementInRow = getModes(pxRadioButton, 0)["options"].length;
    String orientation = getModes(pxRadioButton, 0)["orientation"];
    if (!frmValues.containsKey(getFieldID(pxRadioButton))) {
      frmValues[getFieldID(pxRadioButton)] = "";
    }

    for (var option in getModes(pxRadioButton, 0)["options"]) {
      radioButtons.add(CustomRadioButton(
        value: option["value"],
        //groupValue: frmValues[getFieldID(pxRadioButton)]!,
        size: size,
        maxElementInRow: maxElementInRow,
        orientation: orientation,
        property: getFieldID(pxRadioButton),
        frmValues: frmValues,
      ));
    }
    return Wrap(
      children: [...radioButtons],
    );
  }

  InputsWidget createCustomInput(
      Map<String, dynamic> pxTextInput, String keyboardType) {
    Map<String, TextInputType> inputType = {
      "TEXT": TextInputType.text,
      "EMAIL": TextInputType.emailAddress,
      "NUMBER": TextInputType.number,
      "PHONE": TextInputType.phone,
      "STREET": TextInputType.streetAddress,
      "URL": TextInputType.url,
      "NONE": TextInputType.none,
    };
    return InputsWidget(
      labelText: getFieldLabel(pxTextInput),
      textAlign: getTextAlign(pxTextInput),
      readOnly: isReadOnly(pxTextInput),
      maxLength: getMaxLenght(pxTextInput),
      toolTip: getToolTip(pxTextInput),
      property: getFieldID(pxTextInput),
      frmValues: frmValues,
      inputType: inputType[keyboardType],
    );
  }

  InputsWidget createPxTextInput(Map<String, dynamic> pxTextInput) {
    return InputsWidget(
      labelText: getFieldLabel(pxTextInput),
      textAlign: getTextAlign(pxTextInput),
      readOnly: isReadOnly(pxTextInput),
      maxLength: getMaxLenght(pxTextInput),
      toolTip: getToolTip(pxTextInput),
      property: getFieldID(pxTextInput),
      frmValues: frmValues,
    );
  }

  InputsWidget createPxInteger(Map<String, dynamic> pxTextInput) {
    return InputsWidget(
      labelText: getFieldLabel(pxTextInput),
      textAlign: getTextAlign(pxTextInput),
      readOnly: isReadOnly(pxTextInput),
      maxLength: getMaxLenght(pxTextInput),
      toolTip: getToolTip(pxTextInput),
      property: getFieldID(pxTextInput),
      frmValues: frmValues,
      inputType: TextInputType.number,
    );
  }

  InputsWidget createPxEmail(Map<String, dynamic> pxTextInput) {
    return InputsWidget(
      labelText: getFieldLabel(pxTextInput),
      textAlign: getTextAlign(pxTextInput),
      readOnly: isReadOnly(pxTextInput),
      maxLength: getMaxLenght(pxTextInput),
      toolTip: getToolTip(pxTextInput),
      property: getFieldID(pxTextInput),
      frmValues: frmValues,
      inputType: TextInputType.emailAddress,
    );
  }

  CustomDatePicker createPxDateTime(Map<String, dynamic> pxDateTime) {
    return CustomDatePicker(
      label: getFieldLabel(pxDateTime),
      textAlign: TextAlign.left,
      enabled: !isDisabled(pxDateTime),
      useFutureDateRange: useFutureDateRange(pxDateTime),
      usePastDateRange: usePastDateRange(pxDateTime),
      futureDateRange: getFutureDateRange(pxDateTime),
      pastDateRange: getPastDateRange(pxDateTime),
      toolTip: getToolTip(pxDateTime),
      property: getFieldID(pxDateTime),
      frmValues: frmValues,
    );
  }

  CustomDropdown createPxDropDown(Map<String, dynamic> pxDropdown) {
    List<DropdownMenuItem<dynamic>> menuItems = [];
    for (var element in getModes(pxDropdown, 0)["options"]) {
      menuItems.add(createMenuItem(element));
    }
    return CustomDropdown(
      label: getFieldLabel(pxDropdown),
      menuItem: menuItems,
      property: getFieldID(pxDropdown),
      frmValues: frmValues,
    );
  }

  DropdownMenuItem createMenuItem(Map<String, dynamic> item) {
    return DropdownMenuItem(value: item["value"], child: Text(item["key"]));
  }

  /********* END CREATORS  ******* */
/***** FIELD ATTRIBUTES ********** */

  String getToolTip(Map<String, dynamic> pxTextInput) {
    return getModes(pxTextInput, 0)["tooltip"];
  }

  String getFieldID(Map<String, dynamic> component) {
    return component["fieldID"];
  }

  String getDataPageID(Map<String, dynamic> component) {
    return getModes(component, 0)["dataPageID"];
  }

  String getDataPagePromptName(Map<String, dynamic> component) {
    return getModes(component, 0)["dataPagePrompt"];
  }

  String getDataPageValue(Map<String, dynamic> component) {
    return getModes(component, 0)["dataPageValue"];
  }

  String getDataPageParams(Map<String, dynamic> component) {
    return getModes(component, 0)["dataPageParams"][0]["name"];
  }

  String getFieldLabel(Map<String, dynamic> component) {
    return component["label"];
  }

  int getFutureDateRange(Map<String, dynamic> component) {
    return int.parse(getModes(component, 0)["futureDateRange"]);
  }

  int getPastDateRange(Map<String, dynamic> component) {
    return int.parse(getModes(component, 0)["pastDateRange"]);
  }

  int getMaxLenght(Map<String, dynamic> component) {
    return component["maxLength"] > 0
        ? component["maxLength"]
        : TextField.noMaxLength;
  }

  bool isDisabled(Map<String, dynamic> component) {
    return component["disabled"];
  }

  bool haveParameters(Map<String, dynamic> component) {
    return getModes(component, 0).containsKey("dataPageParams")
        ? getModes(component, 0)["dataPageParams"].length > 0
        : false;
  }

  bool isReadOnly(Map<String, dynamic> component) {
    return component["readOnly"];
  }

  bool useFutureDateRange(Map<String, dynamic> component) {
    return getModes(component, 0)["useFutureDateRange"];
  }

  bool usePastDateRange(Map<String, dynamic> component) {
    return getModes(component, 0)["usePastDateRange"];
  }

  bool isVisible(Map<String, dynamic> component) {
    return component["visible"];
  }

  TextAlign getTextAlign(Map<String, dynamic> component) {
    String align = getModes(
        component, 0)["textAlign"]; //devuelve un String Left, Center o Right
    Map<String, TextAlign> textAlign = {
      "Left": TextAlign.left,
      "Center": TextAlign.center,
      "Right": TextAlign.right
    };
    return textAlign[align] ??
        TextAlign
            .left; //si textAlign[align] es null devuelva TextAlign.left por defecto*/
  }

  Map<String, dynamic> getControl(Map<String, dynamic> component) {
    return component["control"];
  }

  String getComponentType(Map<String, dynamic> component) {
    String type = component.keys.first;
    switch (type) {
      case "field":
        type = (isVisible(component[type]))
            ? getFieldType(component[type])
            : "visible false";
        break;
      default:
    }
    return type;
  }

  String getFieldType(Map<String, dynamic> component) {
    return component["control"]["type"];
  }

  Map<String, dynamic> getModes(Map<String, dynamic> component, int index) {
    List<dynamic> modes = getControl(component)["modes"];
    return (index <= modes.length)
        ? modes[index]
        : {
            "OutOfRange": "Resquest modes $index",
            "fromComponent": getControl(component),
            "modesLength": getControl(component)["modes"]
          };
  }

/***** END FIELD ATTRIBUTES ********** */

/* ************* SWITCH ******************/

  Widget? createWidgets(Map<String, dynamic> component) {
    Widget widget;
    String typeComponent = getComponentType(component);

    switch (typeComponent) {
      case "visible false":
        widget = Container(
          width: 0,
          height: 0,
        );
        break;
      case "caption":
        widget = createCaption(component["caption"]);
        break;
      case "pxDateTime":
        widget = createPxDateTime(component["field"]);
        break;
      case "pxDropdown":
        widget = createPxDropDown(component["field"]);
        break;
      case "pxRadioButtons":
        //widget = createPxRadioButtom(component["field"]);
        widget = createPxDropDown(component["field"]);
        break;
      case "pxTextInput":
        //widget = createPxTextInput(component["field"]);
        widget = createCustomInput(component["field"], "TEXT");
        break;
      case "pxInteger":
        //widget = createPxInteger(component["field"]);
        widget = createCustomInput(component["field"], "NUMBER");
        break;
      case "pxPhone":
        //widget = createPxInteger(component["field"]);
        widget = createCustomInput(component["field"], "PHONE");
        break;
      case "pxEmail":
        // widget = createPxEmail(component["field"]);
        widget = createCustomInput(component["field"], "EMAIL");
        break;
      case "pxAutoComplete":
        // widget = createPxEmail(component["field"]);
        widget = createPxAutoComplete(component["field"]);
        break;
      default:
        widget = Text("Widget aun no soportado: $typeComponent");
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: widget,
    );
  }
}
