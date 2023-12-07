import 'package:dio/dio.dart';
import 'package:residents/services/auth_services.dart';
import 'logger.dart';

class NetworkHelper {
  final String _baseUrl;
  late Dio _dio;
  static const _emptyParam = {'': ''};
  static const _unauthorized = 401;

  NetworkHelper(this._baseUrl) {
    _dio = Dio()
      ..options.baseUrl = _baseUrl
      ..interceptors.add(
        InterceptorsWrapper(onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) {
          options.headers['authorization'] = 'Bearer ${AuthServices().token}';
          logger.i(AuthServices().token);
          handler.next(options);
        }, onError: (DioException e, ErrorInterceptorHandler handler) async {
          handler.reject(e);
        }),
      );
  }

  static String onError(DioException e) {
    if (e.message!.contains('SocketException')) {
      return "Error connecting to network";
    }
    logger.i(e.response);
    logger.i(e.response?.statusCode);
    logger.i(e.requestOptions.path);

    if (e.response?.statusCode == _unauthorized) {
      // Get.offNamed(Routes.AUTH);

      return "Unauthorized";
    }
    return e.message!;
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic> queryParameters = _emptyParam,
  }) async {
    var response = await _dio.get(
      url,
      queryParameters: queryParameters,
    );

    return response;
  }

  Future<Response> post(
    String url, {
    required Map<String, dynamic> data,
    Map<String, dynamic> queryParameters = _emptyParam,
  }) async {
    logger.i(data);
    var response = await _dio.post(
      url,
      data: data,
      queryParameters: queryParameters,
    );
    logger.i(response.data);
    return response;
  }

  Future<Response> put(String url,
      {dynamic data,
      Map<String, dynamic> queryParameters = _emptyParam}) async {
    try {
      final response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
      );
      logger.i(response.data);
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response> uploadFile(String url,
      {required FormData data,
      Map<String, dynamic> queryParameters = _emptyParam,
      Function(int sent, int total)? onSendProgress}) async {
    var response = await _dio.post(url,
        data: data,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress ?? (sent, total) {});

    logger.i(response.data);
    return response;
  }

  Future<Response> delete(String url,
      {Map<String, dynamic> queryParameters = _emptyParam}) async {
    try {
      return await _dio.delete(url, queryParameters: queryParameters);
    } on DioException {
      rethrow;
    }
  }
}

bool isBadStatusCode(int statusCode) {
  if (statusCode <= 200 && statusCode >= 299) return true;
  return false;
}
