import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../factory.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../config.dart';

class GetTrendsAction {
  final List<TagEntity> tags;

  GetTrendsAction({
    @required this.tags,
  });
}

class GetInterestsAction {
  final List<InterestEntity> interests;

  GetInterestsAction({
    @required this.interests,
  });
}

class SaveSearchHistoryAction {
  final String query;

  SaveSearchHistoryAction({
    @required this.query,
  });
}

class ClearSearchHistoryAction {
  ClearSearchHistoryAction();
}


// 获取所有通知
ThunkAction<AppState> getTrendsAction(
    {
      void Function() onSucceed,
      void Function(NoticeEntity) onFailed,
    }) =>
        (Store<AppState> store) async {
      final maService = await MaFactory().getMaService();

      // 本服务器接口异常 无数据返回，临时使用其他实例接口
      var response = await maService.getNoBase(
        'https://qoto.org/api/v1/trends',
        queryParameters: {'limit' : 5},
      );

//      var response = await maService.get(
//        MaApi.Trends,
//        data: {'limit' : 5},
//      );

      if (response.code == MaApiResponse.codeOk) {
        final List<TagEntity> tags = (response.data[''] as List<dynamic>)
            .map<TagEntity>((v) => TagEntity.fromJson(v))
            .toList();
        store.dispatch(GetTrendsAction(
          tags: tags,
        ));

        if (onSucceed != null){
          onSucceed();
        }
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };


// 获取所有兴趣
ThunkAction<AppState> getInterestsAction(
    {
      void Function() onSucceed,
      void Function(NoticeEntity) onFailed,
    }) =>
        (Store<AppState> store) async {
      final maService = await MaFactory().getMaService();

      var state = store.state.account;
      // 使用拓展服务器
      var response = await maService.postFormNoBase(
        MaApi.Interests,
        data: FormData.fromMap({
          'user_id': state.user.id,
          'user_token': '${state.accessToken}',
          'num': '15',
          'mode': false,
          'user_note': state.user.note
        }),
      );

      if (response.code == MaApiResponse.codeOk) {

        final List<InterestEntity> interests = (response.data['interest'] as List<dynamic>)
            .map<InterestEntity>((v) => InterestEntity.fromJson(v))
            .toList();
        store.dispatch(GetInterestsAction(
          interests: interests
        ));

        if (onSucceed != null){
          onSucceed();
        }
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };