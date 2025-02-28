import 'package:flutter/material.dart';
import 'package:ourtalks/main.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FindAppVersion extends StatelessWidget {
  const FindAppVersion({super.key});

  Future<String> _getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return "Version: ${packageInfo.version} (${packageInfo.buildNumber})";
    } catch (e) {
      return "Version: error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getAppVersion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            "Loading version...",
            style: cnstSheet.textTheme.fs14Normal
                .copyWith(color: cnstSheet.colors.gray),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return Text(
            "Version: Unknown",
            style: cnstSheet.textTheme.fs14Normal
                .copyWith(color: cnstSheet.colors.red),
          );
        }
        return Text(
          snapshot.data!,
          style: cnstSheet.textTheme.fs14Normal
              .copyWith(color: cnstSheet.colors.primary),
        );
      },
    );
  }
}
