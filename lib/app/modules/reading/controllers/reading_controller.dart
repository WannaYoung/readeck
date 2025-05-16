import 'package:get/get.dart';
import '../../../data/providers/bookmark_provider.dart';

class ReadingController extends GetxController {
  final BookmarkProvider provider;
  ReadingController(this.provider);

  final markdown = ''.obs;
  final loading = false.obs;
  final showAppBar = true.obs;
  final lastOffset = 0.0.obs; // 滚动偏移

  late String articleId;

  @override
  void onInit() {
    super.onInit();
    articleId = Get.parameters['id'] ?? '';
    if (articleId.isNotEmpty) {
      fetchMarkdown();
    }
  }

  Future<void> fetchMarkdown() async {
    loading.value = true;
    try {
      markdown.value = await provider.getArticleMarkdown(articleId);
      markdown.value = markdown.value.replaceAll('http://', 'https://');
      markdown.value =
          markdown.value.replaceFirst(RegExp(r'^---[\s\S]*?---\s*'), '');
      if (markdown.value.trim().isEmpty) {
        markdown.value = '加载失败';
      }
      markdown.value = markdown.value.replaceAll('。**', '**');
    } catch (e) {
      markdown.value = '加载失败';
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
