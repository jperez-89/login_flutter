import 'package:flutter/material.dart';
import 'package:login_flutter/models/actions/assignment_actions.dart';
import 'package:login_flutter/models/provider/dropdown_provider.dart';
import 'package:login_flutter/theme/app_theme.dart';
import 'package:login_flutter/widgets/widgets.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:provider/provider.dart';

class FormBuilderWidget extends StatefulWidget {
  final String pzInsKey;
  const FormBuilderWidget({Key? key, required this.pzInsKey}) : super(key: key);

  @override
  State<FormBuilderWidget> createState() => _FormBuilderWidgetState();
}

class _FormBuilderWidgetState extends State<FormBuilderWidget> {
  GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
  List components = [];
  String actionID = '';
  String pzInsKey = '';
  final Map<String, dynamic> dataPagePrompt = {};
  final Map<String, String> frmValues = {};
  Map actionsButtons = {}, buttons = {}, data = {};
  List labelButtons = [];
  bool hideButton = false;
  bool load = true;

  /* void callback() {
    dataPagePrompt["$name/list"] = options;
    print(frmValues);
    setState(() {});
  }*/
  void callback() {
    print("dentro del callback");
    setState(() {});
  }

  /// Metodo se utiliza principalmente a la hora de agregar beneficiarios
  void update(List components) {
    setState(() {
      load = true;
    });

    setState(() {
      this.components = components;
      load = false;
    });
  }

  // Obtenemos los campos del formulario del assignment **********
  getAssiggnment(String pzInsKey) async {
    setState(() {
      load = true;
    });

    await AssignmentActions().getAssignment(pzInsKey).then((value) {
      setState(() {
        components = value["components"];
        actionID = value["actionID"];
        labelButtons = value["labelButtons"];
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
// PGFL-32_Implementar_dropdown_anidados
          'btnCancel': actionsButtons['secondary'][0]['name'],
          'btnSave': actionsButtons['secondary'][2]['links']['open']['title'],
          'btnSubmit': actionsButtons['main'][0]['name'],

  //        'labelBtn_Save': labelButtons[0],
    //      'labelBtn_Cancel': labelButtons[1],
      //    'labelBtn_Submit': labelButtons[2],

        };

        load = false;
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
    // PGFL-32_Implementar_dropdown_anidados
    /*return FormBuilder(
            context: context,
            frmValues: frmValues,
            callback: callback,
            commonParamsList: dataPagePrompt)
        .buildForm(
            components, myFormKey, widget.pzInsKey, actionID, buttons, data);*/
    return ChangeNotifierProvider(
      create: (_) => DropdownProvider(),
      child: FormBuilder(
              context: context,
              frmValues: frmValues,
              callback: callback,
              commonParamsList: dataPagePrompt)
          .buildForm(
              components, myFormKey, widget.pzInsKey, actionID, buttons, data),
    );

//    return (load)
//        ? Container(
//            alignment: Alignment.center,
//            margin: const EdgeInsets.only(top: 300),
//            child: const CircularProgressIndicator.adaptive(),
//          )
//        : FormBuilder(
 //               context: context,
  //              frmValues: frmValues,
    //            callback: callback,
      //          commonParamsList: dataPagePrompt,
      //          update: update)
       //     .buildForm(components, myFormKey, widget.pzInsKey, actionID,
        //        buttons, data);

  }
}

class FormBuilder {
  final Map<String, String> frmValues;
  final BuildContext context;
  final Function callback;
  final Map<String, dynamic> commonParamsList;
  final Function update;

  FormBuilder(
      {required this.update,
      required this.context,
      required this.callback,
      required this.frmValues,
      required this.commonParamsList});

  /// crea el forrmulario a partir de la lista de componentes extraida del json de PEGA
  Widget buildForm(List components, GlobalKey<FormState> myFormKey,
      String assignmentID, String actionID, Map buttons, Map data) {
    List<Widget> childs = [];

    if (components.isNotEmpty) {
      for (var component in components) {
        childs.add(
            createWidgets(component, data, assignmentID, myFormKey, actionID) ??
                const Text("vacio"));
      }
      childs.add(createFormButtons(myFormKey, assignmentID, actionID, buttons));
    }

    return Form(key: myFormKey, child: Column(children: childs));
  }

  createFormButtons(GlobalKey<FormState> myFormKey, String assignmentID,
      String actionID, Map buttons) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Row(
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
              child: Text(buttons['labelBtn_Cancel'])),
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
                      showMessage(
                          'Error', 'Complete todos los campos', context);
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
                  child: Text(buttons['labelBtn_Save'])),
              const SizedBox(
                width: 10,
              ),
              // Boton Submit <=====
              ElevatedButton(
                  onPressed: () {
                    if (!myFormKey.currentState!.validate()) {
                      showMessage(
                          'Error', 'Complete todos los campos', context);
                      return;
                    } else {
                      Navigator.pushNamed(context, 'newAssigment', arguments: {
                        'option': 'SubmitData',
                        'assignmentID': assignmentID,
                        'actionID': actionID,
                        'data': frmValues
                      });
                    }
                  },
                  child: Text(buttons['labelBtn_Submit'])),
            ],
          )
        ],
      ),
    );
  }

  void showMessage(String title, String message, context) {
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

  /// Creacion de los diferentes campos *******
  CustomCaption createCaption(Map<String, dynamic> caption) {
    return CustomCaption(value: caption["value"], fontSize: 18);
  }

  CustomAutoComplete createPxAutoComplete(
      Map<String, dynamic> pxAutoComplete, Map? data) {
    List options = getModes(pxAutoComplete, 0)["options"];
    String dataPagePromptName = getDataPagePromptName(pxAutoComplete);
    if (haveParameters(pxAutoComplete)) {
      String parameterName = getDataPageParams(pxAutoComplete);
      String dataPageID = getDataPageID(pxAutoComplete);
      String dataPageValue = getDataPageValue(pxAutoComplete);
      String urlToGet = "$dataPageID?$parameterName=";
      commonParamsList[parameterName] = {
        "dataPagePromptName": dataPagePromptName,
        "dataPageValue": dataPageValue,
        "Endpoint": urlToGet
      };
      if (commonParamsList.containsKey("$parameterName/list")) {
        options = commonParamsList["$parameterName/list"];
      }
    }
    return CustomAutoComplete(
      initialValue: (data != null) ? data[getFieldID(pxAutoComplete)] : null,
      label: getFieldLabel(pxAutoComplete),
      options: options,
      property: getFieldID(pxAutoComplete),
      frmValues: frmValues,
      autoCompleteParamsList: commonParamsList,
      dataPagePromptName: dataPagePromptName,
      callback: callback,
    );
  }

  Wrap createPxRadioButtom(Map<String, dynamic> pxRadioButton) {
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

  CustomInputs createCustomInput(
      Map<String, dynamic> pxTextInput, String keyboardType, Map? data) {
    Map<String, TextInputType> inputType = {
      "TEXT": TextInputType.text,
      "EMAIL": TextInputType.emailAddress,
      "NUMBER": TextInputType.number,
      "PHONE": TextInputType.phone,
      "STREET": TextInputType.streetAddress,
      "URL": TextInputType.url,
      "NONE": TextInputType.none,
      "CURRENCY": TextInputType.number,
      "TEXTAREA": TextInputType.multiline,
    };
    return data != null
        ? CustomInputs(
            maxLines: (keyboardType == "TEXTAREA") ? 5 : 1,
            inputFormatters: (keyboardType == "CURRENCY")
                ? [getCurrencyData(pxTextInput)]
                : [],
            labelText: getFieldLabel(pxTextInput),
            textAlign: getTextAlign(pxTextInput),
            readOnly: isReadOnly(pxTextInput),
            maxLength: getMaxLenght(pxTextInput),
            toolTip: getToolTip(pxTextInput),
            property: getFieldID(pxTextInput),
            frmValues: frmValues,
            inputType: inputType[keyboardType],
            // disabled: isDisabled(pxTextInput),
            isRequired: isRequired(pxTextInput),
            initialValue: data.containsKey(getFieldID(pxTextInput))
                ? data[getFieldID(pxTextInput)]
                : null,
          )
        : CustomInputs(
            inputFormatters: (keyboardType == "CURRENCY")
                ? [getCurrencyData(pxTextInput)]
                : [],
            labelText: getFieldLabel(pxTextInput),
            textAlign: getTextAlign(pxTextInput),
            readOnly: isReadOnly(pxTextInput),
            maxLength: getMaxLenght(pxTextInput),
            toolTip: getToolTip(pxTextInput),
            property: getFieldID(pxTextInput),
            frmValues: frmValues,
            inputType: inputType[keyboardType],
            //disabled: isDisabled(pxTextInput),
            isRequired: isRequired(pxTextInput),
          );
  }

  CustomCheckBox createPxCheckbox(Map<String, dynamic> pxCheckbox, Map? data) {
    return CustomCheckBox(
      initialValue: (data != null),
      label: getControl(pxCheckbox)["label"],
      frmValues: frmValues,
      property: getFieldID(pxCheckbox),
    );
  }

  CustomParagraph createCustomParagraph(Map<String, dynamic> paragraph) {
    return CustomParagraph(text: getFieldValue(paragraph));
  }

  CustomDisplayText createPxDisplayText(Map<String, dynamic> pxDisplayText) {
    return CustomDisplayText(
        title: getFieldLabel(pxDisplayText),
        value: getFieldValue(pxDisplayText));
  }

  CustomInputs createPxTextInput(Map<String, dynamic> pxTextInput) {
    return CustomInputs(
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

  CustomInputs createPxInteger(Map<String, dynamic> pxTextInput) {
    return CustomInputs(
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

  CustomInputs createPxEmail(Map<String, dynamic> pxTextInput) {
    return CustomInputs(
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

  CustomDatePicker createPxDateTime(
      Map<String, dynamic> pxDateTime, Map? data) {
    return CustomDatePicker(
      initialValue: (data != null) ? data[getFieldID(pxDateTime)] : null,
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

  CustomDropdown createPxDropDown(Map<String, dynamic> pxDropdown, Map data) {
    List menuItems = getModes(pxDropdown, 0)["options"];
    String reference = getReference(pxDropdown);

    if (haveParameters(pxDropdown) && data[getFieldID(pxDropdown)] == null) {
      if (!commonParamsList.containsKey(reference)) {
        commonParamsList[reference] = {
          "parameters": getParameters(pxDropdown),
          "dataPageName": getDataPageID(pxDropdown),
          "dataPagePromptName": getDataPagePromptName(pxDropdown),
          "dataPageValue": getDataPageValue(pxDropdown),
        };
      }
      if (commonParamsList.containsKey("$reference/list")) {
        menuItems = commonParamsList["$reference/list"];
      }
    }

    return CustomDropdown(
      placeholder: getPlaceHolder(pxDropdown),
      // ignore: unnecessary_null_comparison
      initialValue: (data != null) ? data[getFieldID(pxDropdown)] : null,
      label: getFieldLabel(pxDropdown),
      menuItem: menuItems,
      property: getFieldID(pxDropdown),
      frmValues: frmValues,
      dropdownList: commonParamsList,
      reference: reference,
      callback: callback,
    );
  }

// PGFL-32_Implementar_dropdown_anidados
  /********* END CREATORS  ******* */

   /* DropdownMenuItem createMenuItem(Map<String, dynamic> item) {
    return DropdownMenuItem(value: item["key"], child: Text(item["value"])); */
  }


  CustomButton createButton(
      GlobalKey<FormState> myFormKey,
      Map<String, dynamic> pxButton,
      Map<String, String> frmValues,
      String pzInsKey,
      String actionID) {
    return CustomButton(
      pzInsKey: pzInsKey,
      frmValues: frmValues,
      label: getFieldLabel(pxButton['control']),
      actionSets: pxButton['control']['actionSets'][0]['actions'],
      myFormKey: myFormKey,
      actionID: actionID,
      update: update,
    );
  }

  CustomDatatable createDataTable(Map<String, dynamic> table, Map? data) {
    return CustomDatatable(
      rows: table['rows'],
      header: table['header']['groups'],
    );
  }

  CustomCard createCard(Map<String, dynamic> table, Map? data) {
    return CustomCard(rows: table['rows'], header: table['header']['groups']);
  }

  /// Fin

  /// Obtencion de atributos **********
  String getToolTip(Map<String, dynamic> pxTextInput) {
    return getModes(pxTextInput, 0)["tooltip"];
  }

  String getFieldID(Map<String, dynamic> component) {
    return component["fieldID"];
  }

  String getPlaceHolder(Map<String, dynamic> component) {
    final String placeholder;
    if (getModes(component, 0).containsKey('placeholder')) {
      placeholder = getModes(component, 0)['placeholder'];
    } else {
      placeholder = 'Seleccione una opción';
    }

    return placeholder;
  }

  String getFieldValue(Map<String, dynamic> component) {
    return component["value"];
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

  String getReference(Map<String, dynamic> component) {
    return component["reference"];
  }

  List getParameters(Map<String, dynamic> component) {
    List parameters = [];
    for (var i = 0; i < getModes(component, 0)["dataPageParams"].length; i++) {
      parameters.add({
        "name": getParameterName(component, i),
        "reference": getParameterReference(component, i),
        "data": "",
      });
    }
    return parameters;
  }

  String getParameterName(Map<String, dynamic> component, int index) {
    return getModes(component, 0)["dataPageParams"][index]["name"];
  }

  String getParameterReference(Map<String, dynamic> component, int index) {
    return getModes(component, 0)["dataPageParams"][index]["valueReference"]
            ["reference"]
        .replaceAll(".", "");
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
    return getControl(component)["type"];
  }

  CurrencyTextInputFormatter getCurrencyData(Map<String, dynamic> component) {
    return CurrencyTextInputFormatter(
        decimalDigits: (getModes(component, 1)["decimalPlaces"] == "") ? 0 : 2,
        enableNegative: false,
        symbol: (getModes(component, 1)["symbolValue"] == "")
            ? "CRC"
            : getModes(component, 1)["symbolValue"]);
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

  /// Fin

  /// Metodo principal que genera el llamado de la creacion de los diferentes campos **********
  Widget? createWidgets(Map<String, dynamic> component, Map data,
      String assignmentID, GlobalKey<FormState> myFormKey, String actinoID) {
    Widget widget;
    String typeComponent = getComponentType(component);

    switch (typeComponent) {
      case "visible false":
      case 'pxRichTextEditor':
        widget = const SizedBox(
          width: 0,
          height: 0,
        );
        break;
      case 'pxTable':
        widget = createCard(component["pxTable"], data);
        break;
      case 'pxButton':
        widget = createButton(
            myFormKey, component["field"], frmValues, assignmentID, actinoID);
        break;
      case "caption":
        widget = createCaption(component["caption"]);
        break;
      case "pxDateTime":
        widget = createPxDateTime(component["field"], data);
        break;
      case "pxDropdown":
        widget = createPxDropDown(component["field"], data);
        break;
      case "pxRadioButtons":
        widget = createPxDropDown(component["field"], data);
        break;
      case "pxTextInput":
        widget = createCustomInput(component["field"], "TEXT", data);
        break;
      case "pxInteger":
        widget = createCustomInput(component["field"], "NUMBER", data);
        break;
      case "pxCurrency":
        widget = createCustomInput(component["field"], "CURRENCY", data);
        break;
      case "pxPhone":
        widget = createCustomInput(component["field"], "PHONE", data);
        break;
      case "pxEmail":
        widget = createCustomInput(component["field"], "EMAIL", data);
        break;
      case "pxAutoComplete":
        widget = createPxAutoComplete(component["field"], data);
        break;
      case "pxTextArea":
        widget = createCustomInput(component["field"], "TEXTAREA", data);
        break;
      case "pxDisplayText":
        widget = createPxDisplayText(component["field"]);
        break;
      case "paragraph":
        widget = createCustomParagraph(component["paragraph"]);
        break;
      case "pxCheckbox":
        widget = createPxCheckbox(component["field"], data);
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
