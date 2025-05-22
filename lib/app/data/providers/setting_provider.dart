import '../../core/network/api_client.dart';
import '../models/user_profile.dart';
import 'package:dio/dio.dart';

class SettingProvider {
  final _client = ApiClient().dio;

  Future<UserProfile> getUserProfile() async {
    final res = await _client.get(
      '/api/profile',
      options: Options(
        headers: {
          'accept': 'application/json',
        },
      ),
    );
    return UserProfile.fromJson(res.data);
  }
}
