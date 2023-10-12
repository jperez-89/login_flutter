import 'package:flutter/material.dart';
import 'package:login_flutter/theme/app_theme.dart';

class ListTileOptionsWidget extends StatelessWidget {
  final List<dynamic> list;

  const ListTileOptionsWidget({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 1,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, i) => ListTile(
        title: Text(list[i]['name']),
        // title: const Text('options'),
        trailing: Icon(
          Icons.arrow_circle_right_outlined,
          color: Color(AppTheme.primaryColor as int),
        ),
        onTap: () {
          // final game = options[i];
          // print(game);
        },
      ),
    );
  }
}
