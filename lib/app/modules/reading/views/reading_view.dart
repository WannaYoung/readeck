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
                    child: MarkdownWidget(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                      data: controller.markdown.value,
                      config: MarkdownConfig(
                        configs: [
                          const PConfig(
                            textStyle: TextStyle(
                              height: 1.8,
                              fontSize: 17,
                            ),
                          ),
                          const H1Config(
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const H2Config(
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const H3Config(
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const CodeConfig(
                            style: TextStyle(
                              backgroundColor: Color(0xFFF5F5F5),
                            ),
                          ),
                          const PreConfig(
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                          ),
                          ImgConfig(
                            builder: (url, attributes) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: ExtendedImage.network(
                                    url.toString(),
                                    cache: true,
                                    loadStateChanged:
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
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
        ),
      );
    });
  }
}
