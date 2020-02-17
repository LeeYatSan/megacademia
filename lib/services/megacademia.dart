import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  final _clientNoBase = Dio();
  final _logger = MaFactory().getLogger('Maservice');

  MaService(PersistCookieJar cookieJar) {
    _client.options.baseUrl = MaConfig.maApiBaseUrl;
    _client.interceptors.add(CookieManager(cookieJar));
    _clientNoBase.interceptors.add(CookieManager(cookieJar));
  }

  Future<MaApiResponse> request(
      String method,
      String path, {
        dynamic data,
        dynamic headers,
        Map<String, dynamic> queryParameters,
      }) async {
    if (MaConfig.isLogApi) {
      _logger.fine('request: $method ${MaConfig.maApiBaseUrl}$path');
    }

    var response = Response();
    try {
      response = await _client.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method, headers: headers),
      );
    } catch (e) {
      _logger.severe('DioError: ${e.type} ${e.message}');
      return MaApiResponse(
        code: MaApiResponse.codeRequestError,
        message: 'DioError: ${e.type} ${e.message}',
      );
    }finally{
      if (MaConfig.isLogApi) {
        _logger.fine('response: ${response.statusCode} ${response.data}');
      }
    }

    if (response.statusCode == HttpStatus.ok) {
      try{
        return MaApiResponse(
            code: MaApiResponse.codeOk,
            message: response.statusCode.toString(),
            data: response.data
        );
      }
      catch(e){
        return MaApiResponse(
            code: MaApiResponse.codeOk,
            message: response.statusCode.toString(),
            data:{'' : response.data}
        );
      }
    } else {
      return MaApiResponse(
        code: MaApiResponse.codeResponseError,
        message: response.statusCode.toString(),
      );
    }
  }

  Future<MaApiResponse> requestNoBase(
      String method,
      String path, {
        dynamic data,
        dynamic headers,
        Map<String, dynamic> queryParameters,
      }) async {
    if (MaConfig.isLogApi) {
      _logger.fine('request: $method $path');
    }

    var response = Response();
    try {
      response = await _clientNoBase.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method, headers: headers),
      );
    } catch (e) {
      _logger.severe('DioError: ${e.type} ${e.message}');
      return MaApiResponse(
        code: MaApiResponse.codeRequestError,
        message: 'DioError: ${e.type} ${e.message}',
      );
    }finally{
      if (MaConfig.isLogApi) {
        _logger.fine('response: ${response.statusCode} ${response.data}');
      }
    }

    if (response.statusCode == HttpStatus.ok) {
      try{
        return MaApiResponse(
            code: MaApiResponse.codeOk,
            message: response.statusCode.toString(),
            data: response.data
        );
      }
      catch(e){
        return MaApiResponse(
            code: MaApiResponse.codeOk,
            message: response.statusCode.toString(),
            data:{'' : response.data}
        );
      }
    } else {
      return MaApiResponse(
        code: MaApiResponse.codeResponseError,
        message: response.statusCode.toString(),
      );
    }
  }

  Future<MaApiResponse> get(String path, {Map<String, dynamic> data,
    Map<String, dynamic> headers, Map<String, dynamic> queryParameters}) async {
    return request('GET', path, data: data, headers: headers,
        queryParameters: queryParameters);
  }

  Future<MaApiResponse> post(String path, {Map<String, dynamic> data,
    Map<String, dynamic> headers}) async {
    return request('POST', path, data: data, headers: headers);
  }

  Future<MaApiResponse> postForm(String path, {FormData data,
    Map<String, dynamic> headers}) async {
    return request('POST', path, data: data, headers: headers);
  }

  Future<MaApiResponse> patch(String path, {Map<String, dynamic> data,
    Map<String, dynamic> headers}) async {
    return request('PATCH', path, data: data, headers: headers);
  }

  Future<MaApiResponse> patchForm(String path, {FormData data,
    Map<String, dynamic> headers}) async {
    return request('PATCH', path, data: data, headers: headers);
  }

  Future<MaApiResponse> delete(String path, {Map<String, dynamic> data,
    Map<String, dynamic> headers, Map<String, dynamic> queryParameters}) async {
    return request('DELETE', path, data: data, headers: headers,
        queryParameters: queryParameters);
  }

  Future<MaApiResponse> getNoBase(String path, {Map<String, dynamic> data,
    Map<String, dynamic> headers, Map<String, dynamic> queryParameters}) async {
    return requestNoBase('GET', path, data: data, headers: headers,
        queryParameters: queryParameters);
  }
}