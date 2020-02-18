import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final notificationReducer = combineReducers<NotificationState>([
  TypedReducer<NotificationState, GetNotificationsAction>(_getNotifications),
  TypedReducer<NotificationState, GetFollowingRequestsAction>(_getFollowingRequests),
  TypedReducer<NotificationState, AgreeFollowingAction>(_agreeFollowing),
  TypedReducer<NotificationState, DisagreeFollowingAction>(_disagreeFollowing),
  TypedReducer<NotificationState, DismissSingleNotificationAction>(_dismissSingleNotification),
]);

NotificationState _getNotifications(NotificationState state,
    GetNotificationsAction action) {
  final List<NotificationEntity> notifications = action.notifications;
  return state.copyWith(
    notifications: notifications,
  );
}

NotificationState _getFollowingRequests(NotificationState state,
    GetFollowingRequestsAction action) {
  final List<UserEntity> users = action.requestFollowAccounts;
  return state.copyWith(
    requestFollowAccounts: users,
  );
}

NotificationState _agreeFollowing(NotificationState state,
    AgreeFollowingAction action) {
  final List<UserEntity> users = state.requestFollowAccounts;
  for(UserEntity user in users){
    if(user.id == action.user.id){
      users.remove(user);
      break;
    }
  }
  return state.copyWith(
    requestFollowAccounts: users,
  );
}

NotificationState _disagreeFollowing(NotificationState state,
    DisagreeFollowingAction action) {
  final List<UserEntity> users = state.requestFollowAccounts;
  for(UserEntity user in users){
    if(user.id == action.user.id){
      users.remove(user);
      break;
    }
  }
  return state.copyWith(
    requestFollowAccounts: users,
  );
}

NotificationState _dismissSingleNotification(NotificationState state,
    DismissSingleNotificationAction action) {
  final List<NotificationEntity> notifications = state.notifications;
  for(NotificationEntity notification in notifications){
    if(notification.id == action.notificationId){
      notifications.remove(notification);
      break;
    }
  }
  return state.copyWith(
    notifications: notifications,
  );
}