import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/reading/bindings/reading_binding.dart';
import '../modules/reading/views/reading_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/reading',
      page: () => const ReadingView(),
      binding: ReadingBinding(),
    ),
  ];
}

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          '全部': '全部',
          '未读': '未读',
          '归档': '归档',
          '收藏': '收藏',
          '视频': '视频',
          '高亮': '高亮',
          '标签': '标签',
          '成功': '成功',
          '失败': '失败',
          '已收藏': '已收藏',
          '已取消收藏': '已取消收藏',
          '已归档': '已归档',
          '已取消归档': '已取消归档',
          '已删除': '已删除',
          '删除失败': '删除失败',
          '操作失败': '操作失败',
          '已保存到书签': '已保存到书签',
          '保存失败': '保存失败',
          '检测到剪贴板有链接': '检测到剪贴板有链接',
          '是否保存该链接到书签？': '是否保存该链接到书签？',
          '取消': '取消',
          '保存': '保存',
          'Readeck': 'Readeck',
        },
        'en_US': {
          '全部': 'All',
          '未读': 'Unread',
          '归档': 'Archived',
          '收藏': 'Favorite',
          '视频': 'Video',
          '高亮': 'Highlight',
          '标签': 'Tags',
          '成功': 'Success',
          '失败': 'Failed',
          '已收藏': 'Favorited',
          '已取消收藏': 'Unfavorited',
          '已归档': 'Archived',
          '已取消归档': 'Unarchived',
          '已删除': 'Deleted',
          '删除失败': 'Delete Failed',
          '操作失败': 'Operation Failed',
          '已保存到书签': 'Saved to bookmarks',
          '保存失败': 'Save Failed',
          '检测到剪贴板有链接': 'Link detected in clipboard',
          '是否保存该链接到书签？': 'Save this link to bookmarks?',
          '取消': 'Cancel',
          '保存': 'Save',
          'Readeck': 'Readeck',
        },
      };
}
