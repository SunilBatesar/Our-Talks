import 'package:flutter/material.dart';
import 'package:ourtalks/Res/Services/app_config.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFunctions {
  static bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  // SEND FEEDBACK TO EMAIL
  static Future<void> sendFeedBackToEmail() async {
    final Uri emailUri = Uri(
      scheme: "mailto",
      path: AppConfig.feedbackSendEmail,
      query: Uri.encodeFull(
          "subject=Feedback for My App ${AppConfig.appName}&body=Hello, I would like to provide feedback on ${AppConfig.appName}. Here are my thoughts..."),
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch email client");
    }
  }

  // WHATSAPP
  static Future<void> userOpenWhatsApp() async {
    try {
      final Uri numberUri = Uri.parse(
          "https://wa.me/${AppConfig.whatsAppContactNumber}?text=${Uri.encodeComponent("Hello")}");
      if (await canLaunchUrl(numberUri)) {
        await launchUrl(numberUri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Could not open WhatsApp");
      }
    } catch (e) {
      debugPrint("Error launching WhatsApp: $e");
    }
  }

  // share app
  static Future<void> appshare() async {
    try {
      final String message =
          "Check out ${AppConfig.appName} - a secure and friendly chat app! 💬\n\nDownload it now: ${AppConfig.appPlayStoreLink}";

      await Share.share(
        message,
        subject: "Let's chat on ${AppConfig.appName}!",
      );
    } catch (e) {
      debugPrint("Error sharing app: $e");
    }
  }
}
