import 'package:flutter/material.dart';
import 'package:login_flutter/theme/app_theme.dart';
import 'package:login_flutter/widgets/widgets.dart';

class CustomDrawer extends StatefulWidget {
  final List<dynamic> lst;
  final bool service;
  const CustomDrawer({super.key, required this.lst, required this.service});

  @override
  State<CustomDrawer> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<CustomDrawer> {
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            accountEmail: Text(
              'Create new Asignments',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
            decoration: BoxDecoration(color: AppTheme.primaryColor),
          ),
          Expanded(
            child: CustomListViewSeparated(
              list: widget.lst,
              service: widget.service,
            ),
          )
        ],
      ),
    );
  }
}
