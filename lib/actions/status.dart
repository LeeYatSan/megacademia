import 'package:megacademia/config.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../factory.dart';
import '../models/models.dart';
import '../services/services.dart';

class DeleteStatusAction {
  final StatusEntity status;

  DeleteStatusAction({
    @required this.status,
  });
}

class GetPublishedStatusAction {
  final List<StatusEntity> statuses;
  final String userId;
  final String beforeId;
  final String afterId;
  final bool refresh;

  GetPublishedStatusAction({
    @required this.statuses,
    @required this.userId,
    this.beforeId,
    this.afterId,
    this.refresh = false,
  });
}

class GetLikedStatusAction {
  final List<StatusEntity> statuses;
  final String userId;
  final String beforeId;
  final String afterId;
  final bool refresh;

  GetLikedStatusAction({
    @required this.statuses,
    @required this.userId,
    this.beforeId,
    this.afterId,
    this.refresh = false,
  });
}

class LikeStatusAction {
  final String userId;
  final String statusId;

  LikeStatusAction({
    @required this.userId,
    @required this.statusId,
  });
}

class UnlikeStatusAction {
  final String userId;
  final String statusId;

  UnlikeStatusAction({
    @required this.userId,
    @required this.statusId,
  });
}

class BoostStatusAction {
  final String userId;
  final String statusId;

  BoostStatusAction({
    @required this.userId,
    @required this.statusId,
  });
}

class UnboostStatusAction {
  final String userId;
  final String statusId;

  UnboostStatusAction({
    @required this.userId,
    @required this.statusId,
  });
}

class GetFollowingStatusAction {
  final List<StatusEntity> statuses;
  final String beforeId;
  final String afterId;
  final bool refresh;

  GetFollowingStatusAction({
    @required this.statuses,
    this.beforeId,
    this.afterId,
    this.refresh = false,
  });
}

class GetPublicStatusAction {
  final List<StatusEntity> statuses;
  final String beforeId;
  final String afterId;
  final bool refresh;

  GetPublicStatusAction({
    @required this.statuses,
    this.beforeId,
    this.afterId,
    this.refresh = false,
  });
}

ThunkAction<AppState> deleteStatusAction({
  @required StatusEntity status,
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      final response = await wgService.delete(
        MaApi.DeleteStatus(status.id),
        headers: {'Authorization': store.state.account.accessToken},
      );

      if (response.code == MaApiResponse.codeOk) {
        store.dispatch(DeleteStatusAction(status: status));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> getPublishedStatusAction({
  @required String userId,
  String beforeId,
  String afterId,
  bool refresh = false,
  void Function(List<StatusEntity>) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      final response = await wgService.get(
        MaApi.SomeonesStatuses(userId),
        headers: {'Authorization': store.state.account.accessToken},
      );

      if (response.code == MaApiResponse.codeOk) {
        final statuses = (response.data[''] as List<dynamic>)
            .map<StatusEntity>((v) => StatusEntity.fromJson(v))
            .toList();
        store.dispatch(GetPublishedStatusAction(
          statuses: statuses,
          userId: userId,
          beforeId: beforeId,
          afterId: afterId,
          refresh: refresh,
        ));
        if (onSucceed != null) onSucceed(statuses);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> getLikedStatusAction({
  @required String userId,
  int limit,
  String beforeId,
  String afterId,
  bool refresh = false,
  void Function(List<StatusEntity>) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      final response = await wgService.get(
        MaApi.Favourites,
        headers: {'Authorization': store.state.account.accessToken},
      );

      if (response.code == MaApiResponse.codeOk) {

        final statuses = (response.data[''] as List<dynamic>)
            .map<StatusEntity>((v) => StatusEntity.fromJson(v))
            .toList();
        store.dispatch(GetLikedStatusAction(
          statuses: statuses,
          userId: userId,
          beforeId: beforeId,
          afterId: afterId,
          refresh: refresh,
        ));
        if (onSucceed != null) onSucceed(statuses);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> likeStatusAction({
  @required String statusId,
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      final response = await wgService.post(
        MaApi.Favourite(statusId),
        headers: {'Authorization': store.state.account.accessToken},
      );

      if (response.code == MaApiResponse.codeOk) {
        store.dispatch(LikeStatusAction(
          userId: store.state.account.user.id,
          statusId: statusId,
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> unlikeStatusAction({
  @required String statusId,
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      final response = await wgService.post(
        MaApi.UnFavourite(statusId),
        headers: {'Authorization': store.state.account.accessToken},
      );

      if (response.code == MaApiResponse.codeOk) {
        store.dispatch(UnlikeStatusAction(
          userId: store.state.account.user.id,
          statusId: statusId,
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> boostStatusAction({
  @required String statusId,
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      final response = await wgService.post(
        MaApi.Boost(statusId),
        headers: {'Authorization': store.state.account.accessToken},
      );

      if (response.code == MaApiResponse.codeOk) {
        store.dispatch(BoostStatusAction(
          userId: store.state.account.user.id,
          statusId: statusId,
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> unboostStatusAction({
  @required String statusId,
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      final response = await wgService.post(
        MaApi.Unboost(statusId),
        headers: {'Authorization': store.state.account.accessToken},
      );

      if (response.code == MaApiResponse.codeOk) {
        store.dispatch(UnboostStatusAction(
          userId: store.state.account.user.id,
          statusId: statusId,
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> getFollowingStatusAction({
  int limit,
  String beforeId,
  String afterId,
  bool refresh = false,
  void Function(List<StatusEntity>) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      final response = await wgService.get(
        MaApi.HomeTimeLine,
        headers: {'Authorization': store.state.account.accessToken},
        data: {
          'limit': limit,
          'max_id': beforeId,
          'min_id': afterId,
        },
      );

      if (response.code == MaApiResponse.codeOk) {
        final statuses = (response.data[''] as List<dynamic>)
            .map<StatusEntity>((v) => StatusEntity.fromJson(v))
            .toList();
        store.dispatch(GetFollowingStatusAction(
          statuses: statuses,
          beforeId: beforeId,
          afterId: afterId,
          refresh: refresh,
        ));
        if (onSucceed != null) onSucceed(statuses);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> getPublicStatusAction({
  int limit,
  String beforeId,
  String afterId,
  bool refresh = false,
  void Function(List<StatusEntity>) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      final response = await wgService.get(
        MaApi.PublicStatuses,
        data: {
          'local': true,
          'limit': limit,
          'max_id': beforeId,
          'min_id': afterId,
        },
      );

      if (response.code == MaApiResponse.codeOk) {
        final statuses = (response.data[''] as List<dynamic>)
            .map<StatusEntity>((v) => StatusEntity.fromJson(v))
            .toList();
        store.dispatch(GetPublicStatusAction(
          statuses: statuses,
          beforeId: beforeId,
          afterId: afterId,
          refresh: refresh,
        ));
        if (onSucceed != null) onSucceed(statuses);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };