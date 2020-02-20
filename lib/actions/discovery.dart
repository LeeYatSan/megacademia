import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../factory.dart';
import '../models/models.dart';
import '../services/services.dart';

class GetTrendsAction {
  final List<TagEntity> tags;

  GetTrendsAction({
    @required this.tags,
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
