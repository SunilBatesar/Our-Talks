import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ourtalks/main.dart';

class UserMessageTile extends StatelessWidget {
  const UserMessageTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(1000.sp),
              child: CachedNetworkImage(
                imageUrl:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqU4vLfw1UL-mlkkZSzi3q441eQwhFjW8A9g&s",
                height: 50.sp,
                width: 50.sp,
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
            Gap(10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sunil",
                  style: cnstSheet.textTheme.fs20Medium
                      .copyWith(color: cnstSheet.colors.white),
                ),
                Text(
                  "batesar_sunil",
                  style: cnstSheet.textTheme.fs14Normal
                      .copyWith(color: cnstSheet.colors.white.withAlpha(150)),
                ),
              ],
            )
          ],
        ),
        Container(
          padding: EdgeInsets.all(4.sp),
          decoration: BoxDecoration(
              border: Border.all(color: cnstSheet.colors.primary),
              shape: BoxShape.circle),
          child: Text(
            "5",
            style: cnstSheet.textTheme.fs15Normal
                .copyWith(color: cnstSheet.colors.white),
          ),
        )
      ],
    );
  }
}
