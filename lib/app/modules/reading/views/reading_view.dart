import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:readeck/app/data/markdown_config.dart';
import '../controllers/reading_controller.dart';

class ReadingView extends GetView<ReadingController> {
  const ReadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize:
          Size.fromHeight(controller.showAppBar.value ? kToolbarHeight : 0),
      child: Obx(() => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => SizeTransition(
              sizeFactor: animation,
              axis: Axis.vertical,
              child: child,
            ),
            child: controller.showAppBar.value
                ? AppBar(
                    key: const ValueKey('appbar'),
                    actions: [
                      Obx(() => IconButton(
                            icon: controller.article.value.isMarked
                                ? const Icon(Icons.favorite)
                                : const Icon(Icons.favorite_border_outlined),
                            color: controller.article.value.isMarked
                                ? const Color.fromARGB(255, 251, 84, 72)
                                : null,
                            onPressed: controller.clickFavorite,
                          )),
                      Obx(() => IconButton(
                            icon: controller.article.value.isArchived
                                ? const Icon(Icons.archive)
                                : const Icon(Icons.archive_outlined),
                            color: controller.article.value.isArchived
                                ? const Color.fromARGB(255, 247, 176, 69)
                                : null,
                            onPressed: controller.clickArchive,
                          )),
                      const SizedBox(width: 10),
                    ],
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          )),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.loading.value && !controller.isReady.value) {
        return Center(
          child: LoadingAnimationWidget.discreteCircle(
            color: const Color.fromARGB(255, 67, 67, 67),
            size: 40,
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: controller.fetchMarkdown,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollUpdateNotification) {
              controller.handleScroll(notification.metrics.pixels);
            }
            return false;
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: controller.isReady.value
                ? SafeArea(
                    key: const ValueKey('content'),
                    top: controller.showAppBar.value,
                    bottom: false,
                    child: _buildMarkdown(),
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
        ),
      );
    });
  }

  Widget _buildMarkdown() {
    return MarkdownWidget(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      data: controller.markdown.value,
      config: defaultMarkdownConfig,
    );
  }
}
