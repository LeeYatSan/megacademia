import 'package:megacademia/actions/account.dart';
import 'package:megacademia/config.dart';
import 'package:megacademia/models/entity/relationship.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../factory.dart';
import '../models/models.dart';
import '../services/services.dart';

class UserInfoAction {
  final UserEntity user;

  UserInfoAction({
    @required this.user,
  });
}

class UserInfosAction {
  final List<UserEntity> users;

  UserInfosAction({
    @required this.users,
  });
}

class GetFollowingListAction {
  final List<UserEntity> users;
  final String userId;
  final int offset;
  final bool refresh;

  GetFollowingListAction({
    @required this.users,
    @required this.userId,
    this.offset,
    this.refresh = false,
  });
}

class GetFollowersListAction {
  final List<UserEntity> users;
  final String userId;
  final int offset;
  final bool refresh;

  GetFollowersListAction({
    @required this.users,
    @required this.userId,
    this.offset,
    this.refresh = false,
  });
}

class FollowUserAction {
  final UserEntity user;

  FollowUserAction({
    @required this.user,
  });
}

class UnfollowUserAction {
  final String userId;

  UnfollowUserAction({
    @required this.userId,
  });
}

class GetMutingUsersAction {
  final List<UserEntity> users;
  final String userId;
  final int offset;
  final bool refresh;

  GetMutingUsersAction({
    @required this.users,
    @required this.userId,
    this.offset,
    this.refresh = false,
  });
}

class MuteUserAction {
  final UserEntity user;

  MuteUserAction({
    @required this.user,
  });
}

class UnmuteUserAction {
  final String userId;

  UnmuteUserAction({
    @required this.userId,
  });
}

class GetBlockedUsersAction {
  final List<UserEntity> users;
  final String userId;
  final int offset;
  final bool refresh;

  GetBlockedUsersAction({
    @required this.users,
    @required this.userId,
    this.offset,
    this.refresh = false,
  });
}

class BlockUserAction {
  final UserEntity user;

  BlockUserAction({
    @required this.user,
  });
}

class UnblockUserAction {
  final String userId;

  UnblockUserAction({
    @required this.userId,
  });
}

class RelationshipsAction {
  final RelationshipEntity relationship;

  RelationshipsAction({
    @required this.relationship,
  });
}

ThunkAction<AppState> userInfoAction({
  @required String id,
  void Function(UserEntity) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      final response = await wgService.get(
        MaApi.Account(id),
      );

      if (response.code == MaApiResponse.codeOk) {
        final user = UserEntity.fromJson(response.data);
//        final user = noteTransform(response);
        if (onSucceed != null) onSucceed(user);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> getFollowingListAction({
  @required String userId,
  int limit,
  int offset,
  bool refresh = false,
  void Function(List<UserEntity>) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      var state = store.state.account;
      final response = await wgService.get(
        MaApi.Following(userId),
        headers: {'Authorization': state.accessToken,},
      );

      if (response.code == MaApiResponse.codeOk) {
        final users = UserListEntity.fromJson(response.data).users;
//        final users = noteTransformForUserList(response);
        store.dispatch(GetFollowingListAction(
          users: users,
          userId: userId,
          offset: offset,
          refresh: refresh,
        ));
        store.dispatch(userInfoAction(id: userId));
        if (onSucceed != null) onSucceed(users);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> getFollowersListAction({
  @required String userId,
  int limit,
  int offset,
  bool refresh = false,
  void Function(List<UserEntity>) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      var state = store.state.account;
      final response = await wgService.get(
        MaApi.Follower(userId),
        headers: {'Authorization': state.accessToken,},
      );

      if (response.code == MaApiResponse.codeOk) {
        final users = UserListEntity.fromJson(response.data).users;
//        final users = noteTransformForUserList(response);
        store.dispatch(GetFollowersListAction(
          users: users,
          userId: userId,
          offset: offset,
          refresh: refresh,
        ));
        if (onSucceed != null) onSucceed(users);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> followUserAction({
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
        MaApi.Follow(userId),
        headers: {'Authorization': state.accessToken,},
      );

      if (response.code == MaApiResponse.codeOk) {
        store.dispatch(userInfoAction(
            id: userId,
            onSucceed: (user)=>(
                store.dispatch(FollowUserAction(
                  user: user
                ))
            )
        ));
        store.dispatch(userInfoAction(
          id: store.state.account.user.id,
          onSucceed: (user) => (
              store.dispatch(AccountInfoAction(user: user))
          ),
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> unfollowUserAction({
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
        MaApi.UnFollow(userId),
        headers: {'Authorization': state.accessToken,},
      );

      if (response.code == MaApiResponse.codeOk) {
        store.dispatch(UnfollowUserAction(
          userId: userId,
        ));
        store.dispatch(userInfoAction(
            id: store.state.account.user.id,
            onSucceed: (user) => (
              store.dispatch(AccountInfoAction(user: user))
            ),
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> getMuteUsersListAction({
  @required String userId,
  int limit,
  int offset,
  bool refresh = false,
  void Function(List<UserEntity>) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      var state = store.state.account;
      final response = await wgService.get(
        MaApi.Muting,
        headers: {'Authorization': state.accessToken,},
      );

      if (response.code == MaApiResponse.codeOk) {
        final users = UserListEntity.fromJson(response.data).users;
//        final users = noteTransformForUserList(response);
        store.dispatch(GetMutingUsersAction(
          users: users,
          userId: userId,
          offset: offset,
          refresh: refresh,
        ));
        if (onSucceed != null) onSucceed(users);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> muteUserAction({
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
        MaApi.Mute(userId),
        headers: {'Authorization': state.accessToken,},
      );

      if (response.code == MaApiResponse.codeOk) {
        store.dispatch(userInfoAction(
          id: userId,
          onSucceed: (user)=>(
            store.dispatch(MuteUserAction(
              user: user,
            ))
          )
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> unmuteUserAction({
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
        MaApi.Unmute(userId),
        headers: {'Authorization': state.accessToken,},
      );

      if (response.code == MaApiResponse.codeOk) {
        store.dispatch(UnmuteUserAction(
          userId: userId,
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> getBlockUsersListAction({
  @required String userId,
  int limit,
  int offset,
  bool refresh = false,
  void Function(List<UserEntity>) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      var state = store.state.account;
      final response = await wgService.get(
        MaApi.Blocked,
        headers: {'Authorization': state.accessToken,},
      );

      if (response.code == MaApiResponse.codeOk) {
        final users = UserListEntity.fromJson(response.data).users;
//        final users = noteTransformForUserList(response);
        store.dispatch(GetBlockedUsersAction(
          users: users,
          userId: userId,
          offset: offset,
          refresh: refresh,
        ));
        if (onSucceed != null) onSucceed(users);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> blockUserAction({
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
        MaApi.Block(userId),
        headers: {'Authorization': state.accessToken,},
      );

      if (response.code == MaApiResponse.codeOk) {
        store.dispatch(userInfoAction(
            id: userId,
            onSucceed: (user)=>(
                store.dispatch(BlockUserAction(
                  user: user,
                ))
            )
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> unblockUserAction({
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
        MaApi.Unblock(userId),
        headers: {'Authorization': state.accessToken,},
      );

      if (response.code == MaApiResponse.codeOk) {
        store.dispatch(UnblockUserAction(
          userId: userId,
        ));
        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

ThunkAction<AppState> relationshipAction({
  @required String userId,
  int limit,
  int offset,
  bool refresh = false,
  void Function(RelationshipEntity) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();
      var state = store.state.account;
      final response = await wgService.get(
        MaApi.Relationship,
        headers: {'Authorization': state.accessToken,},
        queryParameters: {'id[]' : userId}
      );
      if (response.code == MaApiResponse.codeOk) {
        RelationshipEntity relationship = RelationshipListEntity
            .fromJson(response.data).relationships[0];
        store.dispatch(RelationshipsAction(
          relationship: relationship
        ));
        if (onSucceed != null) onSucceed(relationship);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };