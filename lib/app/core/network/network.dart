import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  late Dio dio;

  NetworkService._internal() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://wyread.tocmcc.cn',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = GetStorage().read('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        // 可扩展全局错误处理
        return handler.next(e);
      },
    ));
  }

  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters}) {
    return dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) {
    return dio.post<T>(path, data: data);
  }

  Future<Response> login({
    required String application,
    required String username,
    required String password,
    List<String>? roles,
  }) {
    return dio.post(
      '/api/auth',
      data: {
        'application': application,
        'username': username,
        'password': password,
        if (roles != null) 'roles': roles,
      },
      options: Options(
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
        },
      ),
    );
  }

  Future<Response<List<dynamic>>> getBookmarks({
    int limit = 10,
    int offset = 0,
    String sort = '-created',
    String readStatus = 'all',
  }) {
    return dio.get<List<dynamic>>(
      '/api/bookmarks',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        'sort': sort,
        'read_status': readStatus,
      },
      options: Options(
        headers: {
          'accept': 'application/json',
        },
      ),
    );
  }

  // 可扩展 put、delete 等方法
}
