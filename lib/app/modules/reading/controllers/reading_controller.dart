import 'package:get/get.dart';
import 'package:readeck/app/data/models/bookmark.dart';
import 'package:readeck/app/modules/home/controllers/home_controller.dart';
import '../../../data/providers/bookmark_provider.dart';

class ReadingController extends GetxController {
  final BookmarkProvider provider;
  ReadingController(this.provider);

  final markdown = ''.obs;
  final loading = false.obs;
  final showAppBar = true.obs;
  final lastOffset = 0.0.obs; // 滚动偏移
  final isReady = false.obs;
  final article = Bookmark().obs;

  late String articleId;

  @override
  void onInit() {
    super.onInit();
    article.value = Get.arguments['bookmark'] as Bookmark;
    articleId = article.value.id ?? '';
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

  void clickFavorite() {
    final homeController = Get.find<HomeController>();
    homeController
        .markBookmark(article.value, !article.value.isMarked)
        .then((_) {
      article.update((val) {
        val?.isMarked = !article.value.isMarked;
      });
    });
  }

  void clickArchive() {
    final homeController = Get.find<HomeController>();
    homeController
        .archiveBookmark(article.value, !article.value.isArchived)
        .then((_) {
      article.update((val) {
        val?.isArchived = !article.value.isArchived;
      });
    });
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
