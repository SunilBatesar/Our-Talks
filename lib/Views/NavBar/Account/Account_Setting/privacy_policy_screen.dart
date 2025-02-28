import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ourtalks/Components/AppBar/primary_app_bar.dart';
import 'package:ourtalks/Components/Heading/heading_text_2.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Models/commons_model.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final _privacyPolicyDataList = <TitleAndSubTitleModel>[].obs;
  @override
  void initState() {
    super.initState();
    _initializePrivacyPolicyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: Text(LanguageConst.privacyPolicy.tr)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0.sp),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: HeadingText2(
                      text: LanguageConst.onlybravedaretoenter.tr)),
              Gap(15.h),
              Obx(
                () => ListView.builder(
                  itemCount: _privacyPolicyDataList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: BorderSide(
                              color: cnstSheet.colors.primary.withAlpha(200))),
                      child: ExpansionTile(
                        iconColor: cnstSheet.colors.primary,
                        collapsedIconColor:
                            cnstSheet.colors.primary.withAlpha(150),
                        title: Text(
                          _privacyPolicyDataList[index].title,
                          style: cnstSheet.textTheme.fs16Medium
                              .copyWith(color: cnstSheet.colors.white),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.sp).copyWith(top: 0),
                            child: Text(
                              _privacyPolicyDataList[index].subTiltle,
                              style: cnstSheet.textTheme.fs14Normal
                                  .copyWith(color: cnstSheet.colors.white),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _initializePrivacyPolicyData() {
    _privacyPolicyDataList.clear();
    _privacyPolicyDataList.addAll([
      // Effective Date
      TitleAndSubTitleModel(
          title: LanguageConst.privacyEffectiveDate.tr,
          subTiltle:
              "${LanguageConst.privacyIntro.tr}\n\n${LanguageConst.privacyConsent.tr}"),
      // Information Collection and Use
      TitleAndSubTitleModel(
          title: LanguageConst.privacyInfoCollection.tr,
          subTiltle: LanguageConst.privacyInfoCollectionDesc.tr),
      // Log Data
      TitleAndSubTitleModel(
          title: LanguageConst.privacyLogData.tr,
          subTiltle: LanguageConst.privacyLogDataDesc.tr),
      // Cookies and Tracking Technologies
      TitleAndSubTitleModel(
          title: LanguageConst.privacyCookiesTracking.tr,
          subTiltle:
              "${LanguageConst.privacyCookies.tr}: ${LanguageConst.privacyCookiesDesc.tr}\n\n${LanguageConst.privacyAnalytics.tr}: ${LanguageConst.privacyAnalyticsDesc.tr}\n\n${LanguageConst.privacyOptOut.tr}: ${LanguageConst.privacyOptOutDesc.tr}"),
      // How We Use Data
      TitleAndSubTitleModel(
          title: LanguageConst.privacyDataUsage.tr,
          subTiltle:
              "${LanguageConst.privacyServiceProvision.tr}: ${LanguageConst.privacyServiceProvisionDesc.tr}\n\n${LanguageConst.privacyAppImprovement.tr}: ${LanguageConst.privacyAppImprovementDesc.tr}\n\n${LanguageConst.privacySecurity.tr}: ${LanguageConst.privacySecurityDesc.tr}"),
      // Data Sharing and Disclosure
      TitleAndSubTitleModel(
          title: LanguageConst.privacyDataSharing.tr,
          subTiltle:
              "${LanguageConst.privacyNoSelling.tr}: ${LanguageConst.privacyNoSellingDesc.tr}\n\n${LanguageConst.privacyServiceProviders.tr}: ${LanguageConst.privacyServiceProvidersDesc.tr}\n\n${LanguageConst.privacyLegalCompliance.tr}: ${LanguageConst.privacyLegalComplianceDesc.tr}"),
      // Data Security
      TitleAndSubTitleModel(
          title: LanguageConst.privacyDataSecurity.tr,
          subTiltle: LanguageConst.privacyDataSecurityDesc.tr),
      // Your Rights
      TitleAndSubTitleModel(
          title: LanguageConst.privacyUserRights.tr,
          subTiltle:
              "${LanguageConst.privacyAccessUpdate.tr}: ${LanguageConst.privacyAccessUpdateDesc.tr}\n\n${LanguageConst.privacyDataDeletion.tr}: ${LanguageConst.privacyDataDeletionDesc.tr}"),
      // Policy Updates
      TitleAndSubTitleModel(
          title: LanguageConst.privacyPolicyUpdates.tr,
          subTiltle: LanguageConst.privacyPolicyUpdatesDesc.tr),
      // Contact Us
      TitleAndSubTitleModel(
          title: LanguageConst.privacyContact.tr,
          subTiltle: LanguageConst.privacyContactDesc.tr),
    ]);
  }
}
