import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:login_flutter/models/actions/case_actions.dart';
import 'package:login_flutter/theme/app_theme.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  List<dynamic> lst = [];

  getCaseType() async {
    await CaseActions().getCaseType().then((value) {
      Map<String, dynamic> json = jsonDecode(value);
      lst = json['caseTypes'];
      setState(() {});
    });
  }

  @override
  void initState() {
    getCaseType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              child:
                  // Image.asset('image/avatar.jpg')
                  Image(
                image: NetworkImage(
                    'https://img.freepik.com/premium-vector/business-global-economy_24877-41082.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            accountName: Text(
              'Case Types',
              style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            accountEmail: Text(
              'Create new Asignments',
              style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            decoration: BoxDecoration(color: AppTheme.primaryColor),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: lst.length,
              separatorBuilder: (_, __) => const Divider(thickness: 1),
              itemBuilder: (context, int i) {
                return ListTile(
                  title: Text(lst[i]['name']),
                  trailing: const Icon(Icons.arrow_circle_right_outlined),
                  onTap: () {
                    //Navigator.pushNamed(context, '${lst[i]['name']}');

                    Navigator.pushNamed(context, 'NewCase', arguments: {
                      "Title": '${lst[i]['name']}',
                      "caseTypeID": '${lst[i]['ID']}',
                      "content": ""
                    });
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
