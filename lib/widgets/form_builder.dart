import 'package:flutter/material.dart';
import 'package:login_flutter/models/actions/assignment_actions.dart';
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
  bool _load = false;

  // Obtenemos los campos del formulario del assignment
  void getAssiggnment(String pzInsKey) async {
    // Mostramos loader
    setState(() {
      _load = true;
    });

    await AssignmentActions().getAssignment(pzInsKey).then((value) {
      setState(() {
        components = value;
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
        : FormBuilder().buildForm(components, myFormKey);
  }
}

class FormBuilder {
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
            return;
          }
        },
        child: const Text("Guardar"));
  }

  /// ********* BORRAR ESTA MADRE O SACARLO A  OTRO LADO ************

  CustomCaption createCaption(Map<String, dynamic> caption) {
    return CustomCaption(value: caption["value"], fontSize: 20);
  }

  InputsWidget createPxTextInput(Map<String, dynamic> pxTextInput) {
    return InputsWidget(
      labelText: getFieldLabel(pxTextInput),
      obscureText:
          false, //temporal no recuerdo donde estaba este valor en el json
      textAlign: getTextAlign(pxTextInput),
      readOnly: isReadOnly(pxTextInput),
      maxLength: getMaxLenght(pxTextInput),
      toolTip: getToolTip(pxTextInput),
      property: getFieldID(pxTextInput),
      frmValues: const {},
    );
  }

  CustomDatePicker createPxDateTime(Map<String, dynamic> pxDateTime) {
    return CustomDatePicker(
      label: getFieldLabel(pxDateTime),
      textAlign: getTextAlign(pxDateTime),
      enabled: !isDisabled(pxDateTime),
      useFutureDateRange: useFutureDateRange(pxDateTime),
      usePastDateRange: usePastDateRange(pxDateTime),
      futureDateRange: getFutureDateRange(pxDateTime),
      pastDateRange: getPastDateRange(pxDateTime),
      toolTip: getToolTip(pxDateTime),
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
    );
  }

/* ************************************ PREGUNTAR CUAL TOOLTIP TOMAR **************************** */
  String getToolTip(Map<String, dynamic> pxTextInput) {
    /* ************************************ PREGUNTAR CUAL TOOLTIP TOMAR **************************** */
    return pxTextInput["control"]["modes"][0]["tooltip"];
  }

/* ************************************ PREGUNTAR CUAL TOOLTIP TOMAR **************************** */
  String getFieldID(Map<String, dynamic> component) {
    return component["fieldID"];
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

  bool isReadOnly(Map<String, dynamic> component) {
    return component["readOnly"];
  }

  bool useFutureDateRange(Map<String, dynamic> component) {
    return getModes(component, 0)["useFutureDateRange"];
  }

  bool usePastDateRange(Map<String, dynamic> component) {
    return getModes(component, 0)["usePastDateRange"];
  }

  bool isCaption(Map<String, dynamic> component) {
    return (component.keys.toString().replaceAll(RegExp(r'[()]'), '') ==
        "caption");
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

  DropdownMenuItem createMenuItem(Map<String, dynamic> item) {
    return DropdownMenuItem(value: item["value"], child: Text(item["key"]));
  }

/* ************* SWITCH ******************/

  Widget? createWidgets(Map<String, dynamic> component) {
    Widget widget;
    String typeComponent = (isCaption(component))
        ? "caption"
        : component["field"]["control"][
            "type"]; //*********************actualizar esta linea con los getControl()************
    switch (typeComponent) {
      case "pxTextInput":
        widget = createPxTextInput(component["field"]);
        break;
      case "pxDateTime":
        widget = createPxDateTime(component["field"]);
        break;
      case "pxDropdown":
        widget = createPxDropDown(component["field"]);
        break;
      case "caption":
        widget = createCaption(component["caption"]);
        break;
      default:
        widget = Text("Widget aun no soportado: $typeComponent");
    }
    return widget;
  }
}
