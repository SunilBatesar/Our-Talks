import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ourtalks/view_model/Controllers/loading_controller.dart';

class CloudinaryFunctions {
  static final _loadingController = Get.find<LoadingController>();
  static const _cloudName = 'dwlkcrsdw';
  static const _upload = "upload";
  final _url = 'https://api.cloudinary.com/v1_1/$_cloudName/';
  final _uploadPreset =
      'userimage'; // Set up an unsigned upload preset in Cloudinary

  Future<String?> uploadImageToCloudinary(File imageFile, String folder) async {
    final url = Uri.parse("$_url$_upload");

    try {
      _loadingController.showLoading();
      var request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = _uploadPreset
        ..fields['folder'] = folder // Specify the folder (userdp or userbanner)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedData = json.decode(responseData);
        _loadingController.hideLoading();
        return decodedData['secure_url'];
      } else {
        _loadingController.hideLoading();
        debugPrint('-----------------------');
        debugPrint('Failed to upload image: ${response.reasonPhrase}');
        debugPrint('Upload failed with status: ${response.statusCode}');
        debugPrint('-----------------------');
        return null;
      }
    } catch (e) {
      _loadingController.hideLoading();
      debugPrint('-----------------------');
      debugPrint('Error uploading image: $e');
      debugPrint('-----------------------');
      return null;
    }
  }

  Future<String?> replaceImageInCloudinary(
      File imageFile, String publicId, String folder) async {
    final url = Uri.parse('$_url$_upload');

    try {
      debugPrint('Starting image replacement...');
      debugPrint('Replacing image with public_id: $folder/$publicId');

      var request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = _uploadPreset
        ..fields['public_id'] = '$folder/$publicId'
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ));

      var response = await request.send();
      final responseData = await response.stream.bytesToString();
      final decodedData = json.decode(responseData);

      debugPrint('Full response data: $decodedData');

      if (response.statusCode == 200) {
        debugPrint('Image replaced successfully!');
        debugPrint('Secure URL: ${decodedData['secure_url']}');
        return decodedData['secure_url'];
      } else {
        debugPrint('Failed to replace image: ${response.reasonPhrase}');
        debugPrint('Upload failed with status: ${response.statusCode}');
        debugPrint('Response data: $responseData');
        return null;
      }
    } catch (e) {
      debugPrint('Error replacing image: $e');
      return null;
    }
  }
}
