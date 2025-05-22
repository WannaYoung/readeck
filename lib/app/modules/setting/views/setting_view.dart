import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'.tr, style: TextStyle(fontSize: 20)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLanguageSelector(),
            _divider(),
            _buildThemeSelector(),
            _divider(),
            _buildAccountInfo(),
            _divider(),
            _buildAboutVersion(),
            _divider(),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  /// 分割线
  Widget _divider() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Divider(
          color: Color.fromARGB(80, 180, 180, 180),
          height: 1,
          thickness: 0.8,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  /// 语言选择控件
  Widget _buildLanguageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('语言'.tr,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GetBuilder<SettingController>(
          builder: (controller) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(SettingController.languageOptions.length,
                  (index) {
                final isSelected = controller.selectedLanguageIndex == index;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => controller.updateLanguageIndex(index),
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: isSelected
                              ? Border.all(color: Colors.blue, width: 1.5)
                              : Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          SettingController.languageOptions[index],
                          style: TextStyle(
                            fontSize: 15,
                            color: isSelected ? Colors.black87 : Colors.black26,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }

  /// 主题选择控件
  Widget _buildThemeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('主题'.tr,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GetBuilder<SettingController>(
          builder: (controller) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  List.generate(SettingController.themeColors.length, (index) {
                final isSelected = controller.selectedThemeIndex == index;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => controller.updateThemeIndex(index),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: SettingController.themeColors[index],
                          border: isSelected
                              ? Border.all(color: Colors.blue, width: 1.5)
                              : Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }

  /// 账号信息展示控件
  Widget _buildAccountInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('账号'.tr,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GetBuilder<SettingController>(
          builder: (controller) {
            final user = controller.userProfile?.user;
            if (user == null) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('加载中...', style: TextStyle(color: Colors.grey)),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('${'用户'.tr}：${user.username}',
                      style: TextStyle(fontSize: 15)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('${'邮箱'.tr}：${user.email}',
                      style: TextStyle(fontSize: 15)),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// 关于版本展示控件
  Widget _buildAboutVersion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('关于'.tr,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text('${'版本号'.tr}：0.0.1-202505221',
              style: TextStyle(fontSize: 15)),
        ),
      ],
    );
  }

  /// 退出登录按钮控件
  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () => controller.logout(),
      child: Text(
        '退出登录'.tr,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }
}
