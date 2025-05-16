import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: PieMenu(
        actions: [
          PieAction(
            tooltip: const Text('收藏'),
            onSelect: () => onPieAction?.call(0),
            buttonTheme: pieButtonTheme,
            buttonThemeHovered: pieButtonThemeHovered,
            child: const Icon(Icons.favorite), // Can be any widget
          ),
          PieAction(
            tooltip: const Text('归档'),
            onSelect: () => onPieAction?.call(1),
            buttonTheme: pieButtonTheme,
            buttonThemeHovered: pieButtonThemeHovered,
            child: const Icon(Icons.archive), // Can be any widget
          ),
          PieAction(
            tooltip: const Text('分享'),
            onSelect: () => onPieAction?.call(2),
            buttonTheme: pieButtonTheme,
            buttonThemeHovered: pieButtonThemeHovered,
            child: const Icon(Icons.share), // Can be any widget
          ),
          PieAction(
            tooltip: const Text('删除'),
            onSelect: () => onPieAction?.call(3),
            buttonTheme: pieButtonTheme,
            buttonThemeHovered: PieButtonTheme(
              iconColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 247, 49, 49),
            ),
            child: const Icon(Icons.delete), // Can be any widget
          ),
        ],
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
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
                          bookmark.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black),
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
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black87)),
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
                        Text(bookmark.site!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      const Spacer(),
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
