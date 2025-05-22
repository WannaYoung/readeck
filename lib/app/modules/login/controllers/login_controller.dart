import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/providers/auth_provider.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final AuthProvider provider;
  LoginController(this.provider);

  final serverController =
      TextEditingController(text: 'https://wyread.tocmcc.cn');
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final box = GetStorage();

  void login() async {
    final server = serverController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text;
    if (server.isEmpty || username.isEmpty || password.isEmpty) {
      Get.snackbar('错误'.tr, '请填写完整信息'.tr);
      return;
    }
    box.write('server', server);
    try {
      final res = await provider.login(
        application: 'readeck',
        username: username,
        password: password,
      );
      if (res != null && res['token'] != null && res['id'] != null) {
        box.write('token', res['token']);
        box.write('id', res['id']);
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('登录失败'.tr, '无效响应'.tr);
      }
    } catch (e) {
      Get.snackbar('登录失败'.tr, e.toString());
    }
  }

  @override
  void onClose() {
    serverController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
