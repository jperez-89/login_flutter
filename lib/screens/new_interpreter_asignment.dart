import 'package:flutter/material.dart';
import 'package:login_flutter/models/actions/case_actions.dart';
import 'package:login_flutter/widgets/widgets.dart';

class NewInterpreterAsignment extends StatefulWidget {
  const NewInterpreterAsignment({Key? key}) : super(key: key);

  @override
  State<NewInterpreterAsignment> createState() =>
      _NewInterpreterAsignmentState();
}

class _NewInterpreterAsignmentState extends State<NewInterpreterAsignment> {
  Map parametros = {};
  bool exitCondition = false;
  Widget x = const Text("");
  String id = "";

  void obtenerParametros() {
    parametros = ModalRoute.of(context)!.settings.arguments as Map;
    setPzInsKey();
  }

  void setPzInsKey() {
    if (!exitCondition) {
      CaseActions()
          .getNextAssignmentID(parametros["caseTypeID"], parametros["content"])
          .then((value) {
        exitCondition = true;
        id = CaseActions().getCaseID(value);
        x = FormBuilderWidget(pzInsKey: value);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    obtenerParametros();
    return Scaffold(
        appBar: AppBar(
          title: Text(parametros["Title"] + id),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                x,
              ],
            ),
          ),
        ));
  }
}
