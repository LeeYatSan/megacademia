import 'package:megacademia/models/entity/relationship.dart';
import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final userReducer = combineReducers<UserState>([
  TypedReducer<UserState, GetFollowingListAction>(_followingUsers),
  TypedReducer<UserState, GetFollowersListAction>(_followers),
  TypedReducer<UserState, FollowUserAction>(_followUser),
  TypedReducer<UserState, UnfollowUserAction>(_unfollowUser),
  TypedReducer<UserState, GetMutingUsersAction>(_muteUsers),
  TypedReducer<UserState, MuteUserAction>(_muteUser),
  TypedReducer<UserState, UnmuteUserAction>(_unmuteUser),
  TypedReducer<UserState, GetBlockedUsersAction>(_blockUsers),
  TypedReducer<UserState, BlockUserAction>(_blockUser),
  TypedReducer<UserState, UnblockUserAction>(_unblockUser),
  TypedReducer<UserState, RelationshipsAction>(_relationships),
]);

UserState _followingUsers(UserState state, GetFollowingListAction action) {
  return state.copyWith(
    followingUsers: action.users,
  );
}

UserState _followers(UserState state, GetFollowersListAction action) {
  return state.copyWith(
    followers: action.users,
  );
}

UserState _followUser(UserState state, FollowUserAction action) {
  List<UserEntity> users = state.followingUsers;
  print('前：${users.length}');
  users.add(action.user);
  print('后：${users.length}');
  RelationshipEntity relationship;
  if(!action.user.locked){
    relationship = state.currRelationship.copyWith(following: true);
  }
  relationship = state.currRelationship;
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
  users.add(action.user);
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