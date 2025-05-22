import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pie_menu/pie_menu.dart';
import 'package:readeck/app/routes/app_pages.dart';
import 'package:readeck/app/widgets/alert_dialog.dart';
import '../controllers/home_controller.dart';
import '../../../widgets/article_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = screenWidth * 0.6;
    final scrollController = ScrollController();

    // 上拉加载更多监听
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        if (!controller.isLoadingMore.value && !controller.loading.value) {
          controller.loadMore();
        }
      }
    });

    return PieCanvas(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(theme),
        body: Stack(
          children: [
            _buildArticleList(scrollController),
            _buildSidebarMask(),
            _buildSidebar(sidebarWidth, context),
          ],
        ),
      ),
    );
  }

  /// AppBar
  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      leading: Obx(() => IconButton(
            icon: Icon(
              controller.isSidebarOpen.value ? Icons.close : Icons.menu,
              color: theme.iconTheme.color,
            ),
            onPressed: () => controller.isSidebarOpen.value =
                !controller.isSidebarOpen.value,
          )),
      title: Text(
        'Readeck'.tr,
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.textTheme.titleLarge?.color ?? theme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      centerTitle: false,
      iconTheme: theme.iconTheme,
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
          onPressed: () => Get.toNamed(Routes.SETTING),
        ),
      ],
    );
  }

  /// 文章列表
  Widget _buildArticleList(ScrollController scrollController) {
    return Obx(() {
      if (controller.loading.value && controller.articles.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(
        onRefresh: () => controller.fetchArticles(refresh: true),
        child: ListView.separated(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          itemCount: controller.articles.length + 1,
          separatorBuilder: (_, __) => Divider(
            color: Color.fromARGB(80, 180, 180, 180),
            height: 1,
            thickness: 0.8,
            indent: 20,
            endIndent: 20,
          ),
          itemBuilder: (context, index) {
            if (index == controller.articles.length) {
              if (controller.isLoadingMore.value) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: LoadingAnimationWidget.discreteCircle(
                      color: const Color.fromARGB(255, 67, 67, 67),
                      size: 30,
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }
            final bookmark = controller.articles[index];
            return ArticleCard(
              bookmark: bookmark,
              onTap: () => Get.toNamed(Routes.READING,
                  arguments: {'bookmark': bookmark}),
              onPieAction: (actionIndex) =>
                  _onPieAction(actionIndex, bookmark, context),
            );
          },
        ),
      );
    });
  }

  /// PieMenu操作
  void _onPieAction(int actionIndex, bookmark, BuildContext context) {
    switch (actionIndex) {
      case 0:
        controller.markBookmark(bookmark, !bookmark.isMarked);
        break;
      case 1:
        controller.archiveBookmark(bookmark, !bookmark.isArchived);
        break;
      case 2:
        // 分享
        break;
      case 3:
        showDialog(
          context: context,
          builder: (context) => CustomAlertDialog(
            title: '确认删除'.tr,
            description: '删除后文章无法恢复'.tr,
            confirmButtonText: '删除'.tr,
            confirmButtonColor: const Color.fromARGB(255, 239, 72, 60),
            onConfirm: () => controller.deleteBookmark(bookmark),
          ),
        );
        break;
    }
  }

  /// 侧边栏遮罩
  Widget _buildSidebarMask() {
    return Obx(() => IgnorePointer(
          ignoring: !controller.isSidebarOpen.value,
          child: AnimatedOpacity(
            opacity: controller.isSidebarOpen.value ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: () => controller.isSidebarOpen.value = false,
              child: Container(
                color: Colors.black.withAlpha(150),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ));
  }

  /// 侧边栏
  Widget _buildSidebar(double sidebarWidth, BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() => AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
          top: 0,
          left: controller.isSidebarOpen.value ? 0 : -sidebarWidth,
          width: sidebarWidth,
          height: MediaQuery.of(context).size.height,
          child: Material(
            elevation: 8,
            color: theme.appBarTheme.backgroundColor ??
                theme.scaffoldBackgroundColor,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (var i = 0; i < controller.sidebarItems.length; i++) ...[
                  _sidebarTile(
                    i,
                    controller.sidebarItems[i]['icon'] as IconData,
                    (controller.sidebarItems[i]['title'] as String).tr,
                    controller.onSidebarTap,
                  ),
                  if (i != controller.sidebarItems.length - 1)
                    const Divider(color: Color(0x14000000)),
                ],
              ],
            ),
          ),
        ));
  }

  /// 侧边栏单项
  Widget _sidebarTile(
      int index, IconData icon, String text, Function(int, String) onTap) {
    return SizedBox(
      height: 50,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index, text),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Row(
            children: [
              const SizedBox(width: 20),
              Icon(icon),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
