import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/AppBar/primary_app_bar.dart';
import 'package:ourtalks/Views/NavBar/Account/user_profile_image_show_screen.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';

class ProfileViewScreen extends StatelessWidget {
  final UserModel model;
  ProfileViewScreen({super.key, required this.model});
  final _isbanerShowFull = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: Text(model.name)),
      body: Padding(
        padding: EdgeInsets.all(15.0.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  width: cnstSheet.services.screenWidth(context),
                  height: cnstSheet.services.screenHeight(context) * 0.2,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: cnstSheet.colors.primary,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _isbanerShowFull.value = !_isbanerShowFull.value;
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: CachedNetworkImage(
                        imageUrl:

                            // userdata.userDP ??
                            model.banner?.isNotEmpty == true
                                ? model.banner!
                                : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkBIy4nua2A6YJPNFdcLDXpuR7bU4NYH53sw&s",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: SizedBox(
                              height: 12.sp,
                              width: 12.sp,
                              child: CircularProgressIndicator(
                                color: cnstSheet.colors.white,
                                strokeWidth: 3,
                              )),
                        ),
                        errorWidget: (context, url, error) =>
                            Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 15.w,
                  child: GestureDetector(
                    onTap: () {
                      if (model.userDP!.isNotEmpty) {
                        Get.to(() => UserProfileImageShowScreen(
                              image: model.userDP!,
                            ));
                      }
                    },
                    child: Obx(() {
                      double imageHeightWidth =
                          _isbanerShowFull.value ? 0 : 80.sp;
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        height: imageHeightWidth,
                        width: imageHeightWidth,
                        padding: EdgeInsets.all(5.sp),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: cnstSheet.colors.primary,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: model.userDP?.isNotEmpty == true
                                ? model.userDP!
                                : "https://i.pinimg.com/736x/fa/74/d4/fa74d45f820e06fa3a178d4a9845c0b9.jpg",
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                  height: 12.sp,
                                  width: 12.sp,
                                  child: CircularProgressIndicator(
                                    color: cnstSheet.colors.white,
                                    strokeWidth: 3,
                                  )),
                            ),
                            errorWidget: (context, url, error) =>
                                Center(child: Icon(Icons.error)),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            Gap(15.sp),
            Text(
              model.userName,
              style: cnstSheet.textTheme.fs18Medium
                  .copyWith(color: cnstSheet.colors.white),
            ),
            Gap(10.sp),
            Text(
              model.about ?? "",
              style: cnstSheet.textTheme.fs15Normal
                  .copyWith(color: cnstSheet.colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
