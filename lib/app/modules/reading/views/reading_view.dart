import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:markdown_widget/markdown_widget.dart';
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
                      IconButton(
                        icon: const Icon(Icons.favorite_border_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.archive_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.text_increase_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert_outlined),
                        onPressed: () {},
                      ),
                    ],
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          )),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      return RefreshIndicator(
        onRefresh: controller.fetchMarkdown,
        child: controller.loading.value
            ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                    color: const Color.fromARGB(255, 67, 67, 67), size: 40))
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification is ScrollUpdateNotification) {
                    controller.handleScroll(notification.metrics.pixels);
                  }
                  return false;
                },
                child: SafeArea(
                  top: controller.showAppBar.value,
                  bottom: false,
                  child: MarkdownWidget(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                    data: controller.markdown.value,
                    config: MarkdownConfig(
                      configs: [
                        H1Config(
                          style: const TextStyle(
                            fontSize: 24,
                            height: 1.3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PConfig(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            height: 1.8,
                          ),
                        ),
                        ImgConfig(
                          builder: (url, attributes) => GestureDetector(
                              onTap: () {
                                print(url);
                              },
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: ExtendedImage.network(url.toString(),
                                      cache: true, loadStateChanged:
                                          (ExtendedImageState state) {
                                    if (state.extendedImageLoadState ==
                                        LoadState.loading) {
                                      return Container(
                                        height: 100,
                                        alignment: Alignment.center,
                                        child: LoadingAnimationWidget
                                            .discreteCircle(
                                                color: const Color.fromARGB(
                                                    255, 67, 67, 67),
                                                size: 30),
                                      );
                                    }
                                    if (state.extendedImageLoadState ==
                                        LoadState.failed) {
                                      return Container(
                                        color: Colors.grey[200],
                                        height: 60,
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.broken_image,
                                            size: 30, color: Colors.grey),
                                      );
                                    }
                                    return null;
                                  }))),
                        ),
                        LinkConfig(
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      );
    });
  }
}
