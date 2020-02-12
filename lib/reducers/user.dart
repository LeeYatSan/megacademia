import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final userReducer = combineReducers<UserState>([
  TypedReducer<UserState, FollowUserAction>(_followUser),
  TypedReducer<UserState, UnfollowUserAction>(_unfollowUser),
  TypedReducer<UserState, GetMutingUsersAction>(_muteUsers),
  TypedReducer<UserState, MuteUserAction>(_muteUser),
  TypedReducer<UserState, UnmuteUserAction>(_unmuteUser),
  TypedReducer<UserState, GetBlockedUsersAction>(_blockUsers),
  TypedReducer<UserState, BlockUserAction>(_blockUser),
  TypedReducer<UserState, UnblockUserAction>(_unblockUser),
  TypedReducer<UserState, RelationshipsAction>(_relationships),

//  TypedReducer<UserState, UserInfoAction>(_userInfo),
//  TypedReducer<UserState, UserInfosAction>(_userInfos),
]);

UserState _followUser(UserState state, FollowUserAction action) {
  List<UserEntity> users = state.followingUsers;
  print('前：${users.length}');
  users.add(action.user);
  print('后：${users.length}');
  final relationship = state.currRelationship.copyWith(following: true);
  return state.copyWith(
    followingUsers: users,
    currRelationship: relationship,
  );
}

UserState _unfollowUser(UserState state, UnfollowUserAction action) {
  List<UserEntity> users = state.followingUsers;
  for(UserEntity user in users){
    if(user.id == action.userId){
      users.remove(user);
      break;
    }
  }
  final relationship = state.currRelationship.copyWith(following: false);
  return state.copyWith(
    followingUsers: users,
    currRelationship: relationship,
  );
}

UserState _muteUsers(UserState state, GetMutingUsersAction action) {
  return state.copyWith(
    muteUsers: action.users,
  );
}

UserState _muteUser(UserState state, MuteUserAction action) {
  List<UserEntity> users = state.muteUsers;
  print('前：${users.length}');
  users.add(action.user);
  print('后：${users.length}');
  final relationship = state.currRelationship.copyWith(muting: true);
  return state.copyWith(
    muteUsers: users,
    currRelationship: relationship,
  );
}

UserState _unmuteUser(UserState state, UnmuteUserAction action) {
  List<UserEntity> users = state.muteUsers;
  for(UserEntity user in users){
    if(user.id == action.userId){
      users.remove(user);
      break;
    }
  }
  final relationship = state.currRelationship.copyWith(muting: false);
  return state.copyWith(
    muteUsers: users,
    currRelationship: relationship,
  );
}

UserState _blockUsers(UserState state, GetBlockedUsersAction action) {
  return state.copyWith(
    blockedUsers: action.users,
  );
}

UserState _blockUser(UserState state, BlockUserAction action) {
  List<UserEntity> users = state.blockedUsers;
  print('前：${users.length}');
  users.add(action.user);
  print('后：${users.length}');
  final relationship = state.currRelationship.copyWith(blocking: true);
  return state.copyWith(
    blockedUsers: users,
    currRelationship: relationship,
  );
}

UserState _unblockUser(UserState state, UnblockUserAction action) {
  List<UserEntity> users = state.blockedUsers;
  for(UserEntity user in users){
    if(user.id == action.userId){
      users.remove(user);
      break;
    }
  }
  final relationship = state.currRelationship.copyWith(blocking: false);
  return state.copyWith(
    blockedUsers: users,
    currRelationship: relationship,
  );
}

UserState _relationships(UserState state, RelationshipsAction action) {
  return state.copyWith(
    currRelationship: action.relationship,
  );
}

//UserState _userInfo(UserState state, UserInfoAction action) {
//  var userId = action.user.id.toString();
//
//  var users = Map<String, UserEntity>.from(state.users);
//  users[userId] = action.user;
//
//  return state.copyWith(
//    users: users,
//  );
//}
//
//UserState _userInfos(UserState state, UserInfosAction action) {
//  var users = Map<String, UserEntity>.from(state.users);
//  users.addAll(Map.fromIterable(
//    action.users,
//    key: (v) => (v as UserEntity).id.toString(),
//    value: (v) => v,
//  ));
//
//  return state.copyWith(
//    users: users,
//  );
//}
//
//UserState _usersFollowing(UserState state, UsersFollowingAction action) {
//  var userId = action.userId.toString();
//
//  var users = Map<String, UserEntity>.from(state.users);
//  users.addAll(Map.fromIterable(
//    action.users,
//    key: (v) => (v as UserEntity).id.toString(),
//    value: (v) => v,
//  ));
//
//  var usersFollowing = Map<String, List<int>>.from(state.usersFollowing);
//  usersFollowing[userId] = usersFollowing[userId] ?? [];
//  final userIds = action.users.map<int>((v) => 0).toList();
////  final userIds = action.users.map<int>((v) => v.id).toList();
//  if (action.refresh) {
//    usersFollowing[userId] = userIds;
//  } else if (action.offset == null) {
//    usersFollowing[userId].insertAll(
//      0,
//      userIds.where((v) => !usersFollowing[userId].contains(v)),
//    );
//  } else {
//    usersFollowing[userId].addAll(userIds);
//  }
//
//  return state.copyWith(
//    users: users,
//    usersFollowing: usersFollowing,
//  );
//}
//
//UserState _followers(UserState state, FollowersAction action) {
//  var userId = action.userId.toString();
//
//  var users = Map<String, UserEntity>.from(state.users);
//  users.addAll(Map.fromIterable(action.users,
//      key: (v) => (v as UserEntity).id.toString(), value: (v) => v));
//
//  var followers = Map<String, List<int>>.from(state.followers);
//  followers[userId] = followers[userId] ?? [];
//  final userIds = action.users.map<int>((v) => 0).toList();
////  final userIds = action.users.map<int>((v) => v.id).toList();
//  if (action.refresh) {
//    followers[userId] = userIds;
//  } else if (action.offset == null) {
//    followers[userId].insertAll(
//      0,
//      userIds.where((v) => !followers[userId].contains(v)),
//    );
//  } else {
//    followers[userId].addAll(userIds);
//  }
//
//  return state.copyWith(
//    users: users,
//    followers: followers,
//  );
//}
//
//UserState _followUser(UserState state, FollowUserAction action) {
//  var userId = action.followerId.toString();
//  var followingId = action.followingId.toString();
//
//  var users = Map<String, UserEntity>.from(state.users);
////  users[followingId] = users[followingId].copyWith(isFollowing: true);
//
//  var usersFollowing = Map<String, List<int>>.from(state.usersFollowing);
//  usersFollowing[userId] = usersFollowing[userId] ?? [];
//  usersFollowing[userId]
//    ..remove(action.followingId)
//    ..insert(0, action.followingId);
//
//  return state.copyWith(
//    users: users,
//    usersFollowing: usersFollowing,
//  );
//}
//
//UserState _unfollowUser(UserState state, UnfollowUserAction action) {
//  var userId = action.followerId.toString();
//  var followingId = action.followingId.toString();
//
//  var users = Map<String, UserEntity>.from(state.users);
////  users[followingId] = users[followingId].copyWith(isFollowing: false);
//
//  var usersFollowing = Map<String, List<int>>.from(state.usersFollowing);
//  usersFollowing[userId] = usersFollowing[userId] ?? [];
//  usersFollowing[userId].remove(action.followingId);
//
//  return state.copyWith(
//    users: users,
//    usersFollowing: usersFollowing,
//  );
//}