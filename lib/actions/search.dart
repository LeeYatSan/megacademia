import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../factory.dart';
import '../config.dart';
import '../models/models.dart';
import '../services/services.dart';

class GetSearchResultAction {
  final SearchEntity searchResult;

  GetSearchResultAction({
    @required this.searchResult,
  });
}

// 获取搜索结果
ThunkAction<AppState> getSearchResultAction(
    String query,
    {
      void Function() onSucceed,
      void Function(NoticeEntity) onFailed,
    }) =>
        (Store<AppState> store) async {
      final maService = await MaFactory().getMaService();
      var state = store.state.account;
      var response = await maService.get(
        MaApi.Search,
        headers: {'Authorization': state.accessToken,},
        queryParameters: {'q' : query},
      );

      if (response.code == MaApiResponse.codeOk) {
        final searchResult = SearchEntity.fromJson(response.data);
        store.dispatch(GetSearchResultAction(
          searchResult: searchResult,
        ));

        if (onSucceed != null){
          onSucceed();
        }
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };
