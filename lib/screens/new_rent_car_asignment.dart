import 'package:flutter/material.dart';
import 'package:login_flutter/models/actions/case_actions.dart';
import 'package:login_flutter/widgets/widgets.dart';

class NewRentCarAsignment extends StatefulWidget {
  const NewRentCarAsignment({Key? key}) : super(key: key);

  @override
  State<NewRentCarAsignment> createState() => _NewRentCarAsignmentState();
}

class _NewRentCarAsignmentState extends State<NewRentCarAsignment> {
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
        title:
            pzInsKey != '' ? Text('Assignmet $assignmentId') : const Text(''),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: pzInsKey != ''
              ? Column(
                  children: [
                    FormBuilderWidget(pzInsKey: pzInsKey),
                  ],
                )
              : const Column(
                  children: [CircularProgressIndicator.adaptive()],
                ),
        ),
      ),
    );
  }
}
