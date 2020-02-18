import 'package:meta/meta.dart';
import 'package:megacademia/config.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../factory.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../actions/actions.dart';

class GetNotificationsAction {
  final List<NotificationEntity> notifications;

  GetNotificationsAction({
    @required this.notifications,
  });
}

class GetFollowingRequestsAction {
  final List<UserEntity> requestFollowAccounts;

  GetFollowingRequestsAction({
    @required this.requestFollowAccounts,
  });
}

class AgreeFollowingAction {
  final UserEntity user;

  AgreeFollowingAction({
    @required this.user,
  });
}

class DisagreeFollowingAction {
  final UserEntity user;

  DisagreeFollowingAction({
    @required this.user,
  });
}

class DismissSingleNotificationAction {
  final String notificationId;

  DismissSingleNotificationAction({
    @required this.notificationId,
  });
}


// 获取所有通知
ThunkAction<AppState> getNotificationsAction(
    {
      void Function() onSucceed,
      void Function(NoticeEntity) onFailed,
    }) =>
        (Store<AppState> store) async {
      final maService = await MaFactory().getMaService();
      var state = store.state.account;
      var response = await maService.get(
        MaApi.Notifications,
        headers: {'Authorization': state.accessToken,},
      );

      if (response.code == MaApiResponse.codeOk) {
        final List<NotificationEntity> notifications = (response.data[''] as List<dynamic>)
            .map<NotificationEntity>((v) => NotificationEntity.fromJson(v))
            .toList();

        store.dispatch(GetNotificationsAction(
          notifications: notifications,
        ));

        if (onSucceed != null){
          onSucceed();
        }
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

// 获取所有关注请求
ThunkAction<AppState> getFollowingRequestAction(
    {
      void Function() onSucceed,
      void Function(NoticeEntity) onFailed,
    }) =>
        (Store<AppState> store) async {
      final maService = await MaFactory().getMaService();
      var state = store.state.account;
      var response = await maService.get(
        MaApi.FollowingRequests,
        headers: {'Authorization': state.accessToken,},
      );

      if (response.code == MaApiResponse.codeOk) {
        final List<UserEntity> users = (response.data[''] as List<dynamic>)
            .map<UserEntity>((v) => UserEntity.fromJson(v))
            .toList();
        store.dispatch(GetFollowingRequestsAction(
          requestFollowAccounts: users,
        ));

        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

// 同意关注
ThunkAction<AppState> agreeFollowingAction({
  @required String userId,
  int limit,
  int offset,
  bool refresh = false,
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      var state = store.state.account;
      final response = await wgService.post(
        MaApi.AgreeFollowing(userId),
        headers: {'Authorization': state.accessToken,},
      );

      if (response.code == MaApiResponse.codeOk) {
        store.dispatch(userInfoAction(
            id: userId,
            onSucceed: (user)=>(
                store.dispatch(AgreeFollowingAction(
                  user: user,
                ))
            )
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };


// 不同意关注
ThunkAction<AppState> disagreeFollowingAction({
  @required String userId,
  int limit,
  int offset,
  bool refresh = false,
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      var state = store.state.account;
      final response = await wgService.post(
        MaApi.DisagreeFollowing(userId),
        headers: {'Authorization': state.accessToken,},
      );

      if (response.code == MaApiResponse.codeOk) {
        store.dispatch(userInfoAction(
            id: userId,
            onSucceed: (user)=>(
                store.dispatch(DisagreeFollowingAction(
                  user: user,
                ))
            )
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };


// 删除某条通知
ThunkAction<AppState> dismissSingleNotificationAction({
  @required String notificationId,
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      var state = store.state.account;
      final response = await wgService.post(
        MaApi.DismissSingleNotification(notificationId),
        headers: {'Authorization': state.accessToken,},
      );

      if (response.code == MaApiResponse.codeOk) {
        store.dispatch(DismissSingleNotificationAction(
          notificationId: notificationId
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };