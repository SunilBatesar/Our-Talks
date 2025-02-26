import 'package:flutter/material.dart';
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
          return const Text(
            "Loading version...",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Text(
            "Version: Unknown",
            style: TextStyle(fontSize: 14, color: Colors.red),
          );
        }
        return Text(
          snapshot.data!,
          style: const TextStyle(fontSize: 14, color: Colors.blue),
        );
      },
    );
  }
}
