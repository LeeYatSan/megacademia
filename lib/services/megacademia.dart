import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import '../config.dart';
import '../factory.dart';


part 'megacademia.g.dart';

@JsonSerializable()
@immutable
class MaApiResponse {
  static const int codeResponseError = -2;
  static const int codeRequestError = -1;
  static const int codeOk = 0;

  final int code;
  final String message;
  final Map<String, dynamic> data;

  MaApiResponse({
    this.code = codeOk,
    this.message = "",
    this.data,
  });

  factory MaApiResponse.fromJson(Map<String, dynamic> json) =>
      _$MaApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MaApiResponseToJson(this);
}

class MaService {
  final _client = Dio();
  final _logger = MaFactory().getLogger('Maservice');

  MaService(PersistCookieJar cookieJar) {
    _client.options.baseUrl = MaConfig.maApiBaseUrl;
    _client.interceptors.add(CookieManager(cookieJar));
  }

  Future<MaApiResponse> request(
      String method,
      String path, {
        dynamic data,
      }) async {
    if (MaConfig.isLogApi) {
      _logger.fine('request: $method $path');
    }

    var response = Response();
    try {
      response = await _client.request(
        path,
        data: data,
        options: Options(method: method),
      );
    } catch (e) {
      _logger.severe('DioError: ${e.type} ${e.message}');
      return MaApiResponse(
        code: MaApiResponse.codeRequestError,
        message: 'DioError: ${e.type} ${e.message}',
      );
    }

    if (MaConfig.isLogApi) {
      _logger.fine('response: ${response.statusCode} ${response.data}');
    }

    if (response.statusCode == HttpStatus.ok) {
      return MaApiResponse(
        code: MaApiResponse.codeOk,
        message: response.statusCode.toString(),
        data: response.data
      );
    } else {
      return MaApiResponse(
        code: MaApiResponse.codeResponseError,
        message: response.statusCode.toString(),
      );
    }
  }

  Future<MaApiResponse> get(String path, {Map<String, dynamic> data}) async {
    return request('GET', path, data: data);
  }

  Future<MaApiResponse> post(String path, {Map<String, dynamic> data}) async {
    return request('POST', path, data: data);
  }

  Future<MaApiResponse> postForm(String path, {FormData data}) async {
    return request('POST', path, data: data);
  }
}
