import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:pie_menu/pie_menu.dart';
import '../data/models/bookmark.dart';

class ArticleCard extends StatelessWidget {
  final Bookmark bookmark;
  final VoidCallback? onTap;
  final Function(int)? onPieAction;

  const ArticleCard({
    super.key,
    required this.bookmark,
    this.onTap,
    this.onPieAction,
  });

  @override
  Widget build(BuildContext context) {
    final pieButtonTheme = PieButtonTheme(
      iconColor: Color(0xFF333333),
      backgroundColor: Color(0xFFEBEBEB),
    );
    final pieButtonThemeHovered = PieButtonTheme(
      iconColor: Colors.white,
      backgroundColor: Color(0xFF555555),
    );
    final favoriteButtonTheme = PieButtonTheme(
      iconColor: Color.fromARGB(255, 255, 255, 255),
      backgroundColor: Color.fromARGB(255, 247, 49, 49),
    );
    final archiveButtonTheme = PieButtonTheme(
      iconColor: Color.fromARGB(255, 255, 255, 255),
      backgroundColor: Color.fromARGB(255, 241, 197, 66),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: PieMenu(
        onToggle: (isOpen) async {
          if (isOpen) {
            await Haptics.vibrate(HapticsType.selection);
          }
        },
        actions: [
          PieAction(
            tooltip: Text(bookmark.isMarked ? '取消收藏'.tr : '收藏'.tr),
            onSelect: () => onPieAction?.call(0),
            buttonTheme:
                bookmark.isMarked ? favoriteButtonTheme : pieButtonTheme,
            buttonThemeHovered: pieButtonThemeHovered,
            child: const Icon(Icons.favorite),
          ),
          PieAction(
            tooltip: Text(bookmark.isArchived ? '取消归档'.tr : '归档'.tr),
            onSelect: () => onPieAction?.call(1),
            buttonTheme:
                bookmark.isArchived ? archiveButtonTheme : pieButtonTheme,
            buttonThemeHovered: pieButtonThemeHovered,
            child: const Icon(Icons.archive),
          ),
          PieAction(
            tooltip: Text('分享'.tr),
            onSelect: () => onPieAction?.call(2),
            buttonTheme: pieButtonTheme,
            buttonThemeHovered: pieButtonThemeHovered,
            child: const Icon(Icons.share),
          ),
          PieAction(
            tooltip: Text('删除'.tr),
            onSelect: () => onPieAction?.call(3),
            buttonTheme: pieButtonTheme,
            buttonThemeHovered: PieButtonTheme(
              iconColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 247, 49, 49),
            ),
            child: const Icon(Icons.delete),
          ),
        ],
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          bookmark.title ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if ((bookmark.description ?? '').isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(bookmark.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13)),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (bookmark.iconUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ExtendedImage.network(
                            cache: true,
                            bookmark.iconUrl!,
                            width: 20,
                            height: 20,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (bookmark.iconUrl != null) const SizedBox(width: 5),
                      if ((bookmark.site ?? '').isNotEmpty)
                        Expanded(
                            child: Text(bookmark.site!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey))),
                      const SizedBox(width: 10),
                      if ((bookmark.created ?? '').isNotEmpty)
                        Text(bookmark.created!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
