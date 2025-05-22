import 'package:get/get.dart';
import '../../../data/providers/bookmark_provider.dart';

class ReadingController extends GetxController {
  final BookmarkProvider provider;
  ReadingController(this.provider);

  final markdown = ''.obs;
  final loading = false.obs;
  final showAppBar = true.obs;
  final lastOffset = 0.0.obs; // 滚动偏移
  final isReady = false.obs; // 是否准备好显示内容

  late String articleId;

  @override
  void onInit() {
    super.onInit();
    articleId = Get.parameters['id'] ?? '';
    if (articleId.isNotEmpty) {
      // 延迟一帧再加载，让页面先显示出来
      Future.microtask(() => fetchMarkdown());
    }
  }

  Future<void> fetchMarkdown() async {
    if (loading.value) return;
    loading.value = true;
    try {
      // 先显示加载动画
      isReady.value = false;

      // 异步加载内容
      final content = await provider.getArticleMarkdown(articleId);

      // 处理内容
      String processedContent = content
          .replaceAll('http://', 'https://')
          .replaceFirst(RegExp(r'^---[\s\S]*?---\s*'), '')
          .replaceAll('。**', '**');

      if (processedContent.trim().isEmpty) {
        processedContent = '加载失败';
      }

      // 更新内容
      markdown.value = processedContent;

      // 延迟一帧再显示内容，让过渡更平滑
      await Future.delayed(const Duration(milliseconds: 50));
      isReady.value = true;
    } catch (e) {
      markdown.value = '加载失败';
      isReady.value = true;
    } finally {
      loading.value = false;
    }
  }

  /// 滚动监听，控制AppBar显隐
  void handleScroll(double offset) {
    double delta = offset - lastOffset.value;
    if (delta > 1 && showAppBar.value) {
      showAppBar.value = false;
    } else if (delta < -1 && !showAppBar.value) {
      showAppBar.value = true;
    }
    lastOffset.value = offset;
  }
}
