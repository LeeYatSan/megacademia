import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../factory.dart';
import '../config.dart';
import '../models/models.dart';
import '../services/services.dart';

class GetHashTagStatusesAction {
  final String topic;
  final List<StatusEntity>statuses;

  GetHashTagStatusesAction({
    @required this.topic,
    @required this.statuses,
  });
}

// 获取搜索结果
ThunkAction<AppState> getHashTagStatusesAction(
    String topic,
    {
      String minId,
      String maxId,
      int limit,
      void Function() onSucceed,
      void Function(NoticeEntity) onFailed,
    }) =>
        (Store<AppState> store) async {
      final maService = await MaFactory().getMaService();
      var response = await maService.get(
        MaApi.HashTagTimeline(topic),
        queryParameters: {
          'max_id' : maxId,
          'min_id' : minId,
          'limit' : limit,
        },
      );

      if (response.code == MaApiResponse.codeOk) {
        final statuses = (response.data[''] as List<dynamic>)
            .map<StatusEntity>((v) => StatusEntity.fromJson(v))
            .toList();
        store.dispatch(GetHashTagStatusesAction(
          topic: topic,
          statuses: statuses,
        ));

        if (onSucceed != null){
          onSucceed();
        }
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };
