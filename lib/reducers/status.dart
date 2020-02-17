import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final statusReducer = combineReducers<StatusState>([
  TypedReducer<StatusState, DeleteStatusAction>(_deleteStatus),
  TypedReducer<StatusState, GetPublishedStatusAction>(_getPublishedStatus),
  TypedReducer<StatusState, GetLikedStatusAction>(_getLikedStatus),
  TypedReducer<StatusState, LikeStatusAction>(_likeStatus),
  TypedReducer<StatusState, UnlikeStatusAction>(_unlikeStatus),
  TypedReducer<StatusState, BoostStatusAction>(_boostStatus),
  TypedReducer<StatusState, UnboostStatusAction>(_unboostStatus),
  TypedReducer<StatusState, GetFollowingStatusAction>(_getFollowingStatus),
  TypedReducer<StatusState, GetPublicStatusAction>(_getPublicStatus),
]);

StatusState _deleteStatus(StatusState state, DeleteStatusAction action) {
  var creatorId = action.status.account.id;

  var publishedStatus = Map<String, List<String>>.from(state.publishedStatus);
  publishedStatus[creatorId]?.remove(action.status.id);

  var followingStatus = List<String>.from(state.followingStatus);
  followingStatus.remove(action.status.id);

  return state.copyWith(
    publishedStatus: publishedStatus,
    followingStatus: followingStatus,
  );
}

StatusState _getPublishedStatus(StatusState state, GetPublishedStatusAction action) {
  var userId = action.userId;

  var statuses = Map<String, StatusEntity>.from(state.statuses);
  statuses.addAll(Map.fromIterable(
    action.statuses,
    key: (v) => (v as StatusEntity).id.toString(),
    value: (v) => v,
  ));

  var publishedStatuses = Map<String, List<String>>.from(state.publishedStatus);
  publishedStatuses[userId] = publishedStatuses[userId] ?? [];
  final statusIds = action.statuses.map<String>((v) => v.id).toList();
  if (action.refresh) {
    publishedStatuses[userId] = statusIds;
  } else if (action.afterId != null) {
    publishedStatuses[userId].insertAll(0, statusIds);
  } else {
    publishedStatuses[userId].addAll(statusIds);
  }

  return state.copyWith(
    statuses: statuses,
    publishedStatus: publishedStatuses,
  );
}

StatusState _getLikedStatus(StatusState state, GetLikedStatusAction action) {
  var userId = action.userId;
  var statuses = Map<String, StatusEntity>.from(state.statuses);
  statuses.addAll(Map.fromIterable(
    action.statuses,
    key: (v) => (v as StatusEntity).id.toString(),
    value: (v) => v,
  ));

  var likedStatuses = Map<String, List<String>>.from(state.favouriteStatus);
  likedStatuses[userId] = likedStatuses[userId] ?? [];
  final statusIds = action.statuses.map<String>((v) => v.id).toList();
  if (action.refresh) {
    likedStatuses[userId] = statusIds;
  } else if (action.afterId != null) {
    likedStatuses[userId].insertAll(0, statusIds);
  } else {
    likedStatuses[userId].addAll(statusIds);
  }

  return state.copyWith(
    statuses: statuses,
    favouriteStatus: likedStatuses,
  );
}

StatusState _likeStatus(StatusState state, LikeStatusAction action) {
  var statusId = action.statusId;
  var userId = action.userId;

  var statuses = Map<String, StatusEntity>.from(state.statuses);
  statuses[statusId] = statuses[statusId].copyWith(favourited: true,
      favouritesCount: statuses[statusId].favouritesCount+1);

  var likedStatuses = Map<String, List<String>>.from(state.favouriteStatus);
  likedStatuses[userId] = likedStatuses[userId] ?? [];
  likedStatuses[userId]
    ..remove(action.statusId)
    ..insert(0, action.statusId);

  return state.copyWith(
    statuses: statuses,
    favouriteStatus: likedStatuses,
  );
}

StatusState _unlikeStatus(StatusState state, UnlikeStatusAction action) {
  var statusId = action.statusId;
  var userId = action.userId;

  var statuses = Map<String, StatusEntity>.from(state.statuses);
  statuses[statusId] = statuses[statusId].copyWith(favourited: false,
      favouritesCount: statuses[statusId].favouritesCount-1);

  var likedStatuses = Map<String, List<String>>.from(state.favouriteStatus);
  likedStatuses[userId] = likedStatuses[userId] ?? [];
  likedStatuses[userId].remove(action.statusId);

  return state.copyWith(
    statuses: statuses,
    favouriteStatus: likedStatuses,
  );
}

StatusState _boostStatus(StatusState state, BoostStatusAction action) {
  var statusId = action.statusId;
//  var userId = action.userId;

  var statuses = Map<String, StatusEntity>.from(state.statuses);
  statuses[statusId] = statuses[statusId].copyWith(reblogged: true,
      reblogsCount: statuses[statusId].reblogsCount+1);

//  var likedStatuses = Map<String, List<String>>.from(state.favouriteStatus);
//  likedStatuses[userId] = likedStatuses[userId] ?? [];
//  likedStatuses[userId]
//    ..remove(action.statusId)
//    ..insert(0, action.statusId);

  return state.copyWith(
    statuses: statuses,
//    favouriteStatus: likedStatuses,
  );
}

StatusState _unboostStatus(StatusState state, UnboostStatusAction action) {
  var statusId = action.statusId;
  var userId = action.userId;

  var statuses = Map<String, StatusEntity>.from(state.statuses);
  statuses[statusId] = statuses[statusId].copyWith(reblogged: false,
      reblogsCount: statuses[statusId].reblogsCount-1);

//  var likedStatuses = Map<String, List<String>>.from(state.favouriteStatus);
//  likedStatuses[userId] = likedStatuses[userId] ?? [];
//  likedStatuses[userId].remove(action.statusId);

  return state.copyWith(
    statuses: statuses,
//    favouriteStatus: likedStatuses,
  );
}

StatusState _getFollowingStatus(StatusState state, GetFollowingStatusAction action) {
  final statuses = Map<String, StatusEntity>.from(state.statuses);
  statuses.addAll(Map.fromIterable(
    action.statuses,
    key: (v) => (v as StatusEntity).id.toString(),
    value: (v) => v,
  ));

  var followingStatuses = List<String>.from(state.followingStatus);
  final statusIds = action.statuses.map<String>((v) => v.id).toList();
  if (action.refresh) {
    followingStatuses = statusIds;
  } else if (action.afterId != null) {
    followingStatuses.insertAll(0, statusIds);
  } else {
    followingStatuses.addAll(statusIds);
  }

  return state.copyWith(
    statuses: statuses,
    followingStatus: followingStatuses,
  );
}

StatusState _getPublicStatus(StatusState state, GetPublicStatusAction action) {
  final statuses = Map<String, StatusEntity>.from(state.statuses);
//  final Map<String, StatusEntity> statuses = Map.fromIterable(
//    action.statuses,
//    key: (v) => (v as StatusEntity).id.toString(),
//    value: (v) => v,
//  );
  statuses.addAll(Map.fromIterable(
    action.statuses,
    key: (v) => (v as StatusEntity).id.toString(),
    value: (v) => v,
  ));
  return state.copyWith(
    statuses: statuses,
  );
}