import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:ourtalks/Components/AppBar/primary_app_bar.dart';
import 'package:ourtalks/Components/Heading/heading_text_2.dart';
import 'package:ourtalks/Res/i18n/language_const.dart';
import 'package:ourtalks/main.dart';
import 'package:ourtalks/view_model/Models/commons_model.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TERMS DATA LIST
    final List<TitleAndSubTitleModel> termsList = [
      TitleAndSubTitleModel(
          title: LanguageConst.termsAcceptance.tr,
          subTiltle: LanguageConst.termsAcceptanceDesc.tr),
      TitleAndSubTitleModel(
          title: LanguageConst.termsUserResponsibilities.tr,
          subTiltle: LanguageConst.termsUserResponsibilitiesDesc.tr),
      TitleAndSubTitleModel(
          title: LanguageConst.termsPrivacy.tr,
          subTiltle: LanguageConst.termsPrivacyDesc.tr),
      TitleAndSubTitleModel(
          title: LanguageConst.termsContent.tr,
          subTiltle: LanguageConst.termsContentDesc.tr),
      TitleAndSubTitleModel(
          title: LanguageConst.termsTermination.tr,
          subTiltle: LanguageConst.termsTerminationDesc.tr),
      TitleAndSubTitleModel(
          title: LanguageConst.termsLiability.tr,
          subTiltle: LanguageConst.termsLiabilityDesc.tr),
      TitleAndSubTitleModel(
          title: LanguageConst.termsChanges.tr,
          subTiltle: LanguageConst.termsChangesDesc.tr),
      TitleAndSubTitleModel(
          title: LanguageConst.termsGoverningLaw.tr,
          subTiltle: LanguageConst.termsGoverningLawDesc.tr),
      TitleAndSubTitleModel(
          title: LanguageConst.termsDisputeResolution.tr,
          subTiltle: LanguageConst.termsDisputeResolutionDesc.tr),
      TitleAndSubTitleModel(
          title: LanguageConst.termsContact.tr,
          subTiltle: LanguageConst.termsContactDesc.tr),
    ];
    return Scaffold(
      appBar: PrimaryAppBar(title: Text(LanguageConst.termsConditions.tr)),
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
              ListView.builder(
                itemCount: termsList.length,
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      iconColor: cnstSheet.colors.primary,
                      collapsedIconColor:
                          cnstSheet.colors.primary.withAlpha(150),
                      title: Text(
                        termsList[index].title,
                        style: cnstSheet.textTheme.fs16Medium
                            .copyWith(color: cnstSheet.colors.white),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.sp).copyWith(top: 0),
                          child: Text(
                            termsList[index].subTiltle,
                            style: cnstSheet.textTheme.fs14Normal
                                .copyWith(color: cnstSheet.colors.white),
                          ),
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
