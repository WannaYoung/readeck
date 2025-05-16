import '../../core/network/api_client.dart';
import '../models/bookmark.dart';
import 'package:dio/dio.dart';

class BookmarkProvider {
  final _client = ApiClient().dio;

  Future<List<Bookmark>> getBookmarks({int limit = 10, int offset = 0}) async {
    final res = await _client.get('/api/bookmarks', queryParameters: {
      'limit': limit,
      'offset': offset,
      'sort': '-created',
      'read_status': 'all',
    });
    final list = res.data as List<dynamic>? ?? [];
    return list.map((e) => Bookmark.fromJson(e)).toList();
  }

  Future<String> getArticleHtml(String id) async {
    final res = await _client.get(
      '/api/bookmarks/$id/article',
      options: Options(
        headers: {
          'accept': 'text/html',
        },
        responseType: ResponseType.plain,
      ),
    );
    return res.data?.toString() ?? '';
  }

  Future<String> getArticleMarkdown(String id) async {
    final res = await _client.get(
      '/api/bookmarks/$id/article.md',
      options: Options(
        headers: {
          'accept': 'application/epub+zip',
        },
        responseType: ResponseType.plain,
      ),
    );
    return res.data?.toString() ?? '';
  }

  Future<bool> updateBookmarkStatus(String id,
      {bool? isMarked, bool? isArchived}) async {
    final data = <String, dynamic>{};
    if (isMarked != null) data['is_marked'] = isMarked;
    if (isArchived != null) data['is_archived'] = isArchived;
    final res = await _client.patch(
      '/api/bookmarks/$id',
      data: data,
      options: Options(
        headers: {'accept': 'application/json'},
      ),
    );
    return res.statusCode == 200;
  }

  Future<bool> deleteBookmark(String id) async {
    final res = await _client.delete(
      '/api/bookmarks/$id',
      options: Options(
        headers: {'accept': 'application/json'},
      ),
    );
    return res.statusCode == 200;
  }

  Future<bool> addBookmark({required String url}) async {
    final res = await _client.post(
      '/api/bookmarks',
      data: {
        'url': url,
      },
      options: Options(
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
        },
      ),
    );
    return res.statusCode == 200 || res.statusCode == 201;
  }

  Future<List<Bookmark>> getBookmarksWithParams(
      Map<String, dynamic> params) async {
    final res = await _client.get('/api/bookmarks', queryParameters: params);
    final list = res.data as List<dynamic>? ?? [];
    return list.map((e) => Bookmark.fromJson(e)).toList();
  }
}
