import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeMenu extends StatelessWidget {
  final void Function(int index)? onTap;

  const HomeMenu({
    super.key,
    this.onTap,
  });

  static const List<String> _titles = ["筛选", "设置"];
  static const List<IconData> _icons = [
    Icons.filter_list,
    Icons.settings,
    Icons.exit_to_app,
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
      itemCount: _titles.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(_icons[index]),
          title: Text(
            _titles[index],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            Get.back();
            onTap?.call(index);
          },
        );
      },
    );
  }
}
