import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:ourtalks/Components/AppBar/primary_app_bar.dart';
import 'package:ourtalks/Components/Heading/heading_text_2.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/main.dart';

class UserProfileImageShowScreen extends StatelessWidget {
  final dynamic image;
  const UserProfileImageShowScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CALL HEADING TEXT 2
          HeadingText2(text: LanguageConst.ohWhohandsomeGuyMe.tr)
              .marginAll(10.sp),
          Center(
            child: SizedBox(
              width: cnstSheet.services.screenWidth(context),
              height: cnstSheet.services.screenHeight(context) * 0.5,
              child: _imageShowFunction(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageShowFunction() {
    if (image != null && image is String) {
      return CachedNetworkImage(
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqU4vLfw1UL-mlkkZSzi3q441eQwhFjW8A9g&s",
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: SizedBox(
              height: 35.sp,
              width: 35.sp,
              child: CircularProgressIndicator(
                color: cnstSheet.colors.white,
                strokeWidth: 3,
              )),
        ),
        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      );
    } else if (image != null && image is File) {
      return Image.file(
        image,
        fit: BoxFit.cover,
      );
    } else {
      return Icon(Icons.person, size: 100.sp);
    }
  }
}
