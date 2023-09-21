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
  late final String caseTypeID;
  String assignmentId = '';
  String pzInsKey = '';

  createCase(Map classID) async {
    caseTypeID = classID['classID'].toString();

    await CaseActions().createCase(caseTypeID).then((value) {
      setState(() {
        String id = value['ID'];
        List split = id.split(' ');
        assignmentId = split[1];
        pzInsKey = value['nextAssignmentID'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pzInsKey == '') {
      Map args = ModalRoute.of(context)!.settings.arguments as Map;

      createCase(args);
    }

    return Scaffold(
      appBar: AppBar(
        title: pzInsKey != '' ? Text('Case $assignmentId') : const Text(''),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: pzInsKey != ''
              ? Column(
                  children: [
                    FormBuilderWidget(pzInsKey: pzInsKey),
                  ],
                )
              : const Column(
                  children: [CircularProgressIndicator.adaptive()],
                ),
          //  Container(
          //     alignment: Alignment.center,
          //     margin: const EdgeInsets.only(top: 300),
          //     child: const CircularProgressIndicator.adaptive(),
          //   ),
        ),
      ),
    );
  }
}
