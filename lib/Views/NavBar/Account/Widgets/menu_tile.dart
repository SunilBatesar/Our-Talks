import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Models/account_menu_model.dart';

class MenuTile extends StatelessWidget {
  final AccountMenuModel model;
  final Function onTap;
  const MenuTile({
    super.key,
    required this.model,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      contentPadding: EdgeInsets.all(0),
      leading: Icon(
        model.icon,
        size: 24.sp,
        color: cnstSheet.colors.primary,
      ),
      title: Text(
        model.title.tr,
        style: cnstSheet.textTheme.fs18Medium
            .copyWith(color: cnstSheet.colors.white),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 20.sp,
        color: cnstSheet.colors.primary.withAlpha(150),
      ),
    );
  }
}
