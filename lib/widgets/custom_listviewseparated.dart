import 'package:flutter/material.dart';
import 'package:login_flutter/theme/app_theme.dart';

class CustomListViewSeparated extends StatelessWidget {
  final List<dynamic> list;
  final bool service;

  const CustomListViewSeparated({
    super.key,
    required this.list,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: service ? list.length : 1,
      separatorBuilder: (_, __) => const Divider(thickness: 1),
      itemBuilder: (context, int i) {
        return service
            ? ListTile(
                title: Text(list[i]['name']),
                trailing: Icon(
                  Icons.arrow_circle_right_outlined,
                  color: Color(AppTheme.primaryColor as int),
                ),
                onTap: () {
                  String classID = list[i]['ID'];
                  String name = list[i]['name'];
                  Navigator.pushNamed(context, 'newAssigment', arguments: {
                    'option': 'newCase',
                    "classID": classID,
                    "name": name
                  });
                },
              )
            : const ListTile(
                title: Text('Servicio no disponible'),
              );
      },
    );

    // ListView.separated(
    //   itemCount: list.length,
    //   separatorBuilder: (_, __) => const Divider(),
    //   itemBuilder: (context, i) => ListTile(
    //     title: Text(list[i]['name']),
    //     trailing: Icon(
    //       Icons.arrow_circle_right_outlined,
    //       color: Color(AppTheme.primaryColor as int),
    //     ),
    //     onTap: () {
    //       // final game = options[i];
    //       // print(game);
    //     },
    //   ),
    // );
  }
}
