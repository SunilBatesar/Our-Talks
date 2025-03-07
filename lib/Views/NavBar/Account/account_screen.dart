import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Res/Services/app_config.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/Utils/utils.dart';
import 'package:ourtalks/Views/NavBar/Account/Widgets/find_app_version.dart';
import 'package:ourtalks/Views/NavBar/Account/Widgets/menu_tile.dart';
import 'package:ourtalks/Views/NavBar/Account/user_profile_image_show_screen.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Controllers/user_controller.dart';
import 'package:ourtalks/view_model/Data/Functions/app_functions.dart';
import 'package:ourtalks/view_model/Data/LocalData/local_data.dart';
import 'package:ourtalks/view_model/Data/Networks/user%20network/auth/auth_datahendler.dart';
import 'package:ourtalks/view_model/Models/account_menu_model.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  final _isbanerShowFull = false.obs;

  // find user from controller
  final _usercontroller = Get.find<UserController>();

  // capital first letter function
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final userdata = _usercontroller.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _capitalizeFirstLetter(userdata!.name),
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
                          imageUrl: userdata.banner?.isNotEmpty == true
                              ? userdata.banner!
                              : AppConfig.defaultBanner,
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
                        if (userdata.userDP!.isNotEmpty) {
                          Get.to(() => UserProfileImageShowScreen(
                                image: userdata.userDP!,
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
                              imageUrl: userdata.userDP?.isNotEmpty == true
                                  ? userdata.userDP!
                                  : AppConfig.defaultDP,
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
                userdata.userName,
                style: cnstSheet.textTheme.fs18Bold
                    .copyWith(color: cnstSheet.colors.white),
              ),
              Gap(3.h),
              Text(
                userdata.about!,
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
                    onTap: () async {
                      await menuTileTapFunction(data);
                    },
                  ).marginOnly(bottom: 10.h);
                },
              ),
              Center(
                child: FindAppVersion(),
              ),
              Gap(5.h),
              Center(
                child: Text(
                  "${LanguageConst.developedby.tr}: ${AppConfig.developedBy}",
                  style: cnstSheet.textTheme.fs12Normal
                      .copyWith(color: cnstSheet.colors.white),
                ),
              ),
              Gap(5.h),
              Center(
                child: Text(
                  LanguageConst.foundbugReportloveanger.tr,
                  style: cnstSheet.textTheme.fs12Normal
                      .copyWith(color: cnstSheet.colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> menuTileTapFunction(AccountMenuModel model) async {
    switch (model.id) {
      case LanguageConst.updateProfile:
        Get.toNamed(cnstSheet.routesName.updateProfileScreen,
            arguments: _usercontroller.user);
      case LanguageConst.settings:
        Get.toNamed(cnstSheet.routesName.settingScreen);
      case LanguageConst.shareApp:
        await AppFunctions.appshare();
      case LanguageConst.termsConditions:
        Get.toNamed(cnstSheet.routesName.termsAndConditionsScreen);
      case LanguageConst.privacyPolicy:
        Get.toNamed(cnstSheet.routesName.privacyPolicyScreen);
      case LanguageConst.helpSupport:
        Get.toNamed(cnstSheet.routesName.helpAndSupportScreen);
      case LanguageConst.logout:
        AppUtils.showPermissionDialog(
            title: LanguageConst.waitLoggingout.tr,
            content: LanguageConst.ohThinklogoutstillrememberpassword.tr,
            submitButnText: LanguageConst.logout.tr,
            onTap: () async {
              await AuthDataHandler.logout();
            });

      default:
        null;
    }
  }
}
