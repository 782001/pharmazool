import 'package:dio/dio.dart';

class DioHelper {
  static Dio dio = Dio();
  static init() {
    dio = Dio(BaseOptions(
        baseUrl: 'http://amc007-001-site8.etempurl.com',
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          'Host': '<calculated when request is sent>',
          'Content-Length': '<calculated when request is sent>'
        }));
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
  }) async {
    return await dio.post('http://amc007-001-site8.etempurl.com/api/$url',
        queryParameters: query, data: data);
  }

  static Future<Response> deletedata({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
  }) async {
    return await dio.delete('http://amc007-001-site8.etempurl.com/api/$url',
        queryParameters: query, data: data);
  }

  static Future<Response> updatedata({
    required String url,
    Map<String, dynamic>? query,
    required var data,
  }) async {
    return await dio.put('http://amc007-001-site8.etempurl.com/api/$url',
        queryParameters: query, data: data);
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    return await dio.get(
      'http://amc007-001-site8.etempurl.com/api/$url',
      queryParameters: query,
    );
  }
}
