import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ourtalks/Components/AppBar/primary_app_bar.dart';
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
        imageUrl: image,
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
