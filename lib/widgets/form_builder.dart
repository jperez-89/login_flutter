import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:login_flutter/models/actions/assignment_actions.dart';
import 'package:login_flutter/models/services/datapages_services.dart';
import 'package:login_flutter/theme/app_theme.dart';
import 'package:login_flutter/widgets/widgets.dart';

class FormBuilderWidget extends StatefulWidget {
  final String pzInsKey;

  const FormBuilderWidget({Key? key, required this.pzInsKey}) : super(key: key);

  @override
  State<FormBuilderWidget> createState() => _FormBuilderWidgetState();
}

class _FormBuilderWidgetState extends State<FormBuilderWidget> {
  GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
  List components = [];
  String actionID = '', btnSubmit = '';
  final Map<String, dynamic> dataPagePrompt = {};
  Map actionsButtons = {}, buttons = {}, data = {};
  bool hideButton = false;

  void callback() {
    setState(() {});
  }

  // Obtenemos los campos del formulario del assignment
  getAssiggnment(String pzInsKey) async {
    await AssignmentActions().getAssignment(pzInsKey).then((value) {
      setState(() {
        components = value["components"];
        actionID = value["actionID"];
        actionsButtons = value["actionsButtons"];
        data = value["data"]['content'];

        /** VALIDAR LAS FECHAS PARA DESHABILITAR EL BOTON DE SAVE EN CASO QUE EL ASSIGNMETN TENGA DATOS ALMACENADOS */
        // DateTime create = value["data"]['createTime'];
        // DateTime update = value["data"]['lastUpdateTime'];

        // print(create);
        // print(update);

        // value["data"]['createTime'] != value["data"]['lastUpdateTime']
        //     ? hideButton = true
        //     : null;
        // print(hideButton);

        // String edad = data['content']['Age'];
        // print(actionsButtons['secondary']);

        buttons = {
          'btnCancel': actionsButtons['secondary'][0]['name'],
          'btnSave': actionsButtons['secondary'][1]['links']['open']['title'],
          'btnSubmit': actionsButtons['main'][0]['name'],
        };
      });
    });
  }

  @override
  void initState() {
    getAssiggnment(widget.pzInsKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
            context: context,
            callback: callback,
            dataPagePrompt: dataPagePrompt)
        .buildForm(
            components, myFormKey, widget.pzInsKey, actionID, buttons, data);
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

  Widget buildForm(List components, GlobalKey<FormState> myFormKey,
      String assignmentID, String actionID, Map buttons, Map data) {
    List<Widget> childs = [];

    if (components.isNotEmpty) {
      for (var component in components) {
        childs.add(createWidgets(component, data) ?? const Text("vacio"));
      }
      childs.add(getSaveButton(myFormKey, assignmentID, actionID, buttons));
    }

    return Card(
      shadowColor: AppTheme.black,
      margin: const EdgeInsets.all(0),
      elevation: 10,
      child: Form(key: myFormKey, child: Column(children: childs)),
    );
  }

  getSaveButton(GlobalKey<FormState> myFormKey, String assignmentID,
      String actionID, Map buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Boton Cancelar <=====
        ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppTheme.cancel)),
            onPressed: () {
              Navigator.popAndPushNamed(
                context,
                'dashboard',
              );
            },
            child: Text(buttons['btnCancel'])),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Boton Save <=====
            ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(AppTheme.secondaryColor)),
                onPressed: () {
                  if (!myFormKey.currentState!.validate()) {
                    showMessage('Error', 'Complete todos los campos');
                    return;
                  } else {
                    Navigator.pushNamed(context, 'newAssigment', arguments: {
                      'option': 'SaveData',
                      'assignmentID': assignmentID,
                      'actionID': actionID,
                      'data': frmValues
                    });
                  }
                },
                child: Text(buttons['btnSave'])),
            const SizedBox(
              width: 10,
            ),
            // Boton Submit <=====
            ElevatedButton(
                onPressed: () {
                  if (!myFormKey.currentState!.validate()) {
                    showMessage('Error', 'Complete todos los campos');
                    return;
                  } else {
                    Navigator.pushNamed(context, 'newAssigment', arguments: {
                      'option': 'Submit',
                      'assignmentID': assignmentID,
                      'actionID': actionID,
                      'data': frmValues
                    });
                  }
                },
                child: Text(buttons['btnSubmit'])),
          ],
        )
      ],
    );
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

  /// ******* CREATORS  *******
  CustomCaption createCaption(Map<String, dynamic> caption) {
    return CustomCaption(value: caption["value"], fontSize: 18);
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
            "$dataPageID?$parameterName=${dataPagePrompt[parameterName]}";
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
      Map<String, dynamic> pxTextInput, String keyboardType, Map? data) {
    Map<String, TextInputType> inputType = {
      "TEXT": TextInputType.text,
      "EMAIL": TextInputType.emailAddress,
      "NUMBER": TextInputType.number,
      "PHONE": TextInputType.phone,
      "STREET": TextInputType.streetAddress,
      "URL": TextInputType.url,
      "NONE": TextInputType.none,
    };
    return data != null
        ? InputsWidget(
            labelText: getFieldLabel(pxTextInput),
            textAlign: getTextAlign(pxTextInput),
            readOnly: isReadOnly(pxTextInput),
            maxLength: getMaxLenght(pxTextInput),
            toolTip: getToolTip(pxTextInput),
            property: getFieldID(pxTextInput),
            frmValues: frmValues,
            inputType: inputType[keyboardType],
            disabled: isDisabled(pxTextInput) ? false : true,
            required: isRequired(pxTextInput),
            initialValue: data.containsKey(getFieldID(pxTextInput))
                ? data[getFieldID(pxTextInput)]
                : null,
          )
        : InputsWidget(
            labelText: getFieldLabel(pxTextInput),
            textAlign: getTextAlign(pxTextInput),
            readOnly: isReadOnly(pxTextInput),
            maxLength: getMaxLenght(pxTextInput),
            toolTip: getToolTip(pxTextInput),
            property: getFieldID(pxTextInput),
            frmValues: frmValues,
            inputType: inputType[keyboardType],
            disabled: isDisabled(pxTextInput) ? false : true,
            required: isRequired(pxTextInput),
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
      disabled: isDisabled(pxTextInput),
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
      disabled: isDisabled(pxTextInput),
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
      disabled: isDisabled(pxTextInput),
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

  /// *** FIELD ATTRIBUTES **********
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

  bool isRequired(Map<String, dynamic> component) {
    return component["required"];
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

  /// *** END FIELD ATTRIBUTES **********

/* ************* SWITCH ******************/
  Widget? createWidgets(Map<String, dynamic> component, Map data) {
    Widget widget;
    String typeComponent = getComponentType(component);

    switch (typeComponent) {
      case "visible false":
        widget = const SizedBox(
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
        widget = createCustomInput(component["field"], "TEXT", data);
        break;
      case "pxInteger":
        //widget = createPxInteger(component["field"]);
        widget = createCustomInput(component["field"], "NUMBER", data);
        break;
      case "pxPhone":
        //widget = createPxInteger(component["field"]);
        widget = createCustomInput(component["field"], "PHONE", data);
        break;
      case "pxEmail":
        // widget = createPxEmail(component["field"]);
        widget = createCustomInput(component["field"], "EMAIL", data);
        break;
      case "pxAutoComplete":
        // widget = createPxEmail(component["field"]);
        widget = createPxAutoComplete(component["field"]);
        break;
      default:
        widget = Text("Widget aun no soportado: $typeComponent");
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 15),
      child: widget,
    );
  }
}
