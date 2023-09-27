import 'package:flutter/material.dart';
import 'package:login_flutter/theme/app_theme.dart';

class DrawerWidget extends StatefulWidget {
  final List<dynamic> lst;
  final bool service;
  const DrawerWidget({super.key, required this.lst, required this.service});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
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
              itemCount: widget.service ? widget.lst.length : 1,
              separatorBuilder: (_, __) => const Divider(thickness: 1),
              itemBuilder: (context, int i) {
                return widget.service
                    ? ListTile(
                        title: Text(widget.lst[i]['name']),
                        trailing: const Icon(Icons.arrow_circle_right_outlined),
                        onTap: () {
                          String classID = widget.lst[i]['ID'];
                          String name = widget.lst[i]['name'];
                          Navigator.pushNamed(context, 'newAssigment',
                              arguments: {
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
            ),
          )
        ],
      ),
    );
  }
}
