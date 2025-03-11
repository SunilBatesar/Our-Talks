import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ourtalks/Components/BottomSheets/image_pick_bottom_sheet.dart';
import 'package:ourtalks/Components/Container/primary_container.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Data/LocalData/local_data.dart';
import 'package:ourtalks/view_model/Models/account_menu_model.dart';

Future<void> chatBottomSheetFunction({required Function(File) file}) async {
  bool hasPermission = await requestPermissions();
  if (hasPermission) {
    Get.bottomSheet(ChatBottomSheet(
      file: file,
    ));
  }
}

class ChatBottomSheet extends StatelessWidget {
  final Function(File) file;
  const ChatBottomSheet({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0.sp),
      child: PrimaryContainer(
          padding: EdgeInsets.all(15.0.sp),
          color: cnstSheet.colors.black,
          child: GridView.builder(
            itemCount: LocalData.chatBottomSheetLocalData.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.6,
                crossAxisSpacing: 5.w,
                mainAxisSpacing: 5.w),
            itemBuilder: (context, index) {
              final data = LocalData.chatBottomSheetLocalData[index];
              return TextButton.icon(
                onPressed: () {
                  _onTapFunction(data);
                },
                label: Text(
                  data.title.tr,
                  style: cnstSheet.textTheme.fs18Medium
                      .copyWith(color: cnstSheet.colors.white),
                ),
                icon: Icon(
                  data.icon,
                  size: 24.sp,
                  color: cnstSheet.colors.white,
                ),
              );
            },
          )),
    );
  }

  Future _onTapFunction(AccountMenuModel model) async {
    switch (model.id) {
      case LanguageConst.camera:
        // IMAGE PICK TO CAMERA
        final imagePath = await pickImage(ImageSource.camera);
        file(File(imagePath));

        Get.back();
      case LanguageConst.gallery:
        // IMAGE PICK TO GALLERY
        final imagePath = await pickImage(ImageSource.gallery);
        file(File(imagePath));

        Get.back();
      default:
        null;
    }
  }
}
