import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static const String _downloadUrlKey = 'DownloadURL';
  static const String _apiUrlKey = 'APIURL';
  static const String _communityCodeKey = 'COMMUNITY_CODE';

  // Store URLs and Community Code
  static Future<bool> storeUrls({
    required String downloadUrl,
    required String apiUrl,
    required String communityCode,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_downloadUrlKey, downloadUrl);
      await prefs.setString(_apiUrlKey, apiUrl);
      await prefs.setString(_communityCodeKey, communityCode);
      return true;
    } catch (e) {
      print('Error storing URLs and community code: $e');
      return false;
    }
  }

  // Get Download URL
  static Future<String?> getDownloadUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_downloadUrlKey);
    } catch (e) {
      print('Error getting download URL: $e');
      return null;
    }
  }

  // Get API URL
  static Future<String?> getApiUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_apiUrlKey);
    } catch (e) {
      print('Error getting API URL: $e');
      return null;
    }
  }

  // Get Community Code
  static Future<String?> getCommunityCode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_communityCodeKey);
    } catch (e) {
      print('Error getting community code: $e');
      return null;
    }
  }

  // Delete URLs and Community Code
  static Future<bool> deleteUrls() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_downloadUrlKey);
      await prefs.remove(_apiUrlKey);
      await prefs.remove(_communityCodeKey);
      return true;
    } catch (e) {
      print('Error deleting URLs and community code: $e');
      return false;
    }
  }

  // Check if URLs and Community Code exist
  static Future<bool> urlsExist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_downloadUrlKey) && 
             prefs.containsKey(_apiUrlKey) &&
             prefs.containsKey(_communityCodeKey);
    } catch (e) {
      print('Error checking URLs and community code existence: $e');
      return false;
    }
  }
}
