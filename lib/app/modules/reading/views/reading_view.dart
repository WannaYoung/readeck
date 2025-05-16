import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/markdown_widget.dart';
import '../controllers/reading_controller.dart';

class ReadingView extends GetView<ReadingController> {
  const ReadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: controller.fetchMarkdown,
          child: controller.loading.value
              ? const Center(child: CircularProgressIndicator())
              : MarkdownWidget(
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
                          // letterSpacing: 1.1,
                          fontFamily: 'PingFang SC',
                        ),
                      ),
                      ImgConfig(
                        builder: (url, attributes) => ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(url.toString()),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
