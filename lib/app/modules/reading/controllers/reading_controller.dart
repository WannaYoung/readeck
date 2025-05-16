import 'package:get/get.dart';
import '../../../data/providers/bookmark_provider.dart';

class ReadingController extends GetxController {
  final BookmarkProvider provider;
  ReadingController(this.provider);

  final markdown = ''.obs;
  final loading = false.obs;

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
}
