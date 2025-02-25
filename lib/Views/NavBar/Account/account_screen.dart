import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Views/NavBar/Account/Widgets/menu_tile.dart';
import 'package:ourtalks/Views/NavBar/Account/user_profile_image_show_screen.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Data/LocalData/local_data.dart';
import 'package:ourtalks/view_model/Data/Networks/auth_datahendler.dart';
import 'package:ourtalks/view_model/Models/account_menu_model.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  final _isbanerShowFull = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sunil",
          style: cnstSheet.textTheme.appNameStyle15
              .copyWith(color: cnstSheet.colors.primary),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0.sp).copyWith(top: 0),
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
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkBIy4nua2A6YJPNFdcLDXpuR7bU4NYH53sw&s",
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
                        Get.to(() => UserProfileImageShowScreen(
                              image: "",
                            ));
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
                              imageUrl:
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqU4vLfw1UL-mlkkZSzi3q441eQwhFjW8A9g&s",
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
              Gap(10.h),
              Text(
                "batesar_sunil",
                style: cnstSheet.textTheme.fs18Bold
                    .copyWith(color: cnstSheet.colors.white),
              ),
              Gap(3.h),
              Text(
                "Ram Ram Tau \n Jatt",
                style: cnstSheet.textTheme.fs16Medium
                    .copyWith(color: cnstSheet.colors.white),
              ),
              Gap(10.h),
              ...List.generate(
                LocalData.accountMenuDataList.length,
                (index) {
                  final data = LocalData.accountMenuDataList[index];
                  return MenuTile(
                    model: data,
                    onTap: () {
                      menuTileTapFunction(data);
                    },
                  ).marginOnly(bottom: 10.h);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void menuTileTapFunction(AccountMenuModel model) {
    switch (model.id) {
      case LanguageConst.updateProfile:
        Get.toNamed(cnstSheet.routesName.updateProfileScreen);
      case LanguageConst.theme:
        Get.toNamed(cnstSheet.routesName.themeScreen);
      case LanguageConst.language:
        Get.toNamed(cnstSheet.routesName.languageScreen);
      case LanguageConst.logout:
        AuthDataHandler.logout();

      default:
        null;
    }
  }
}
