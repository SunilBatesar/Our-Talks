import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:intl/intl.dart';
import 'package:ourtalks/Res/Services/app_config.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

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

  //  CHAT TIME FORMAT FUNCTION
  static String formatChatTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(Duration(days: 1));
    DateTime yesterday = today.subtract(Duration(days: 1));

    String time = DateFormat('hh:mm a').format(dateTime);

    if (dateTime.isAfter(today) && dateTime.isBefore(tomorrow)) {
      return "Today, $time";
    } else if (dateTime.isAfter(yesterday) && dateTime.isBefore(today)) {
      return "Yesterday, $time";
    } else if (dateTime.isAfter(tomorrow) &&
        dateTime.isBefore(tomorrow.add(Duration(days: 1)))) {
      return "Tomorrow, $time";
    } else {
      // Check if year is current year
      if (dateTime.year == now.year) {
        return DateFormat('dd/MM hh:mm a').format(dateTime); // Hide year
      } else {
        return DateFormat('dd/MM/yyyy hh:mm a')
            .format(dateTime); // Show year for older dates
      }
    }
  }

  // Converts Firebase's dynamic map to properly typed map
  static Map<String, dynamic> convertFirebaseData(dynamic data) {
    if (data is! Map<dynamic, dynamic>) {
      throw const FormatException('Invalid message format');
    }

    final converted = <String, dynamic>{};
    data.forEach((key, value) {
      converted[key.toString()] =
          value is Map ? convertFirebaseData(value) : value;
    });
    return converted;
  }

  // CONVERTS MAP<STRING,DYNAMIC> to TYPE MESSAGE
  static types.Message? parseMessage(Map<String, dynamic> json) {
    try {
      json['createdAt'] ??= DateTime.now().millisecondsSinceEpoch;
      json['id'] ??= const Uuid().v4();

      if (json['author'] is Map) {
        json['author'] = AppFunctions.convertFirebaseData(json['author']);
      }

      switch (json['type']) {
        case 'text':
          return types.TextMessage.fromJson(json);
        case 'image': // Add image case
          return types.ImageMessage.fromJson(json);
        default:
          return null;
      }
    } catch (e) {
      debugPrint("Error parsing message: $e");
      return null;
    }
  }
}
