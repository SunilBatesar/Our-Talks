import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ourtalks/view_model/Controllers/loading_controller.dart';

class CloudinaryFunctions {
  static final _loadingController = Get.find<LoadingController>();
  static const _cloudName = 'dwlkcrsdw';
  static const _upload = "upload";
  static const _apiKey = '159913318993972'; // Add your API key
  static const _apiSecret =
      '6a39msxJlwo-coDHRfmLWMfAJIs'; // Add your API secret

  final _url = 'https://api.cloudinary.com/v1_1/$_cloudName/';

  // *****************
  // upload new image

  Future<String?> uploadImageToCloudinary(
    File imageFile, {
    String? publicId,
    String? folder,
  }) async {
    final url = Uri.parse('$_url$_upload');
    final timestamp =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

    // Prepare parameters for signing
    final params = <String, String>{
      'timestamp': timestamp,
      if (publicId != null && publicId.isNotEmpty) 'public_id': publicId,
      if (folder != null && folder.isNotEmpty) 'folder': folder,
    };

    // Generate signature
    final sortedParams = params.keys.toList()..sort();
    final paramsToSign = sortedParams.map((k) => '$k=${params[k]}').join('&');
    final signature =
        sha1.convert(utf8.encode(paramsToSign + _apiSecret)).toString();

    try {
      _loadingController.showLoading();
      debugPrint('Starting image upload...');

      final request = http.MultipartRequest('POST', url)
        ..fields.addAll({
          'api_key': _apiKey,
          'timestamp': timestamp,
          'signature': signature,
          ...params,
        })
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final decodedData = json.decode(responseData);

      if (response.statusCode == 200) {
        debugPrint('Upload success: ${decodedData['secure_url']}');
        return decodedData['secure_url'];
      } else {
        debugPrint('''
      Upload failed (${response.statusCode}):
      ${decodedData['error']['message']}
      ''');
        return null;
      }
    } catch (e) {
      debugPrint('Upload exception: $e');
      return null;
    } finally {
      _loadingController.hideLoading();
    }
  }

  // ***********************
  // update image

  Future<String?> replaceImageInCloudinary(
    File imageFile, {
    required String publicId,
    String?
        folder, // Keep the parameter if needed elsewhere, but don't use it in params
  }) async {
    final url = Uri.parse('$_url$_upload');
    final timestamp =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

    // Prepare parameters for signing (REMOVE FOLDER FROM PARAMS)
    final params = <String, String>{
      'timestamp': timestamp,
      'public_id': publicId,
      'overwrite': 'true', // Ensure overwrite is enabled
    };

    // Generate signature
    final sortedParams = params.keys.toList()..sort();
    final paramsToSign = sortedParams.map((k) => '$k=${params[k]}').join('&');
    final signature =
        sha1.convert(utf8.encode(paramsToSign + _apiSecret)).toString();

    try {
      _loadingController.showLoading();
      debugPrint('Attempting to replace image: $publicId');

      final request = http.MultipartRequest('POST', url)
        ..fields.addAll({
          'api_key': _apiKey,
          'timestamp': timestamp,
          'signature': signature,
          ...params,
        })
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final decodedData = json.decode(responseData);

      if (response.statusCode == 200) {
        debugPrint('Replace successful: ${decodedData['secure_url']}');
        return decodedData['secure_url'];
      } else {
        debugPrint('''
      Replace failed (${response.statusCode}):
      ${decodedData['error']['message']}
      ''');
        return null;
      }
    } catch (e) {
      debugPrint('Replace exception: $e');
      return null;
    } finally {
      _loadingController.hideLoading();
    }
  }

  // ***********************
// delete image

  Future<bool> deleteImageFromCloudinary(String publicId) async {
    final url = Uri.parse('${_url}image/destroy');
    final timestamp =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

    // Prepare parameters for signing
    final params = <String, String>{
      'public_id': publicId,
      'timestamp': timestamp,
    };

    // Generate signature
    final sortedParams = params.keys.toList()..sort();
    final paramsToSign = sortedParams.map((k) => '$k=${params[k]}').join('&');
    final signature =
        sha1.convert(utf8.encode(paramsToSign + _apiSecret)).toString();

    try {
      _loadingController.showLoading();
      debugPrint('Attempting to delete image: $publicId');

      final response = await http.post(
        url,
        body: {
          'api_key': _apiKey,
          'public_id': publicId,
          'timestamp': timestamp,
          'signature': signature,
        },
      );

      final decodedData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (decodedData['result'] == 'ok') {
          debugPrint('Deletion successful for: $publicId');
          return true;
        } else {
          debugPrint('Deletion failed: ${decodedData['error']['message']}');
          return false;
        }
      } else {
        debugPrint('''
      Deletion failed (${response.statusCode}):
      ${decodedData['error']['message']}
      ''');
        return false;
      }
    } catch (e) {
      debugPrint('Deletion exception: $e');
      return false;
    } finally {
      _loadingController.hideLoading();
    }
  }
}
