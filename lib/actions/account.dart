import 'package:megacademia/config.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../factory.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'reset.dart';

class AccountInfoAction {
  final UserEntity user;

  AccountInfoAction({
    @required this.user,
  });
}

class AccountAccessTokenAction {
  final String accessToken;

  AccountAccessTokenAction({
    @required this.accessToken,
  });
}

class ClientInfoAction {
  final String clientId;
  final String clientSecret;

  ClientInfoAction({
    @required this.clientId,
    @required this.clientSecret,
  });
}

// 获取账户信息
ThunkAction<AppState> clientInfoAction({
  void Function(String) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      final maService = await MaFactory().getMaService();

      var response = await maService.post(MaApi.Apps, data: {
        "client_name": MaConfig.packageInfo.appName,
        "redirect_uris": MaGlobalValue.redirectUrl,
        "scopes": MaGlobalValue.scopes,
      });

      if (response.code == MaApiResponse.codeOk) {

        store.dispatch(ClientInfoAction(
          clientId: response.data[MaGlobalValue.clientId],
          clientSecret: response.data[MaGlobalValue.clientSecret],
        ));
        if (onSucceed != null) onSucceed(response.data[MaGlobalValue.clientId]);
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

// 获取令牌
ThunkAction<AppState> accountAccessTokenAction(bool grantType, {
  void Function() onSucceed,
  void Function(NoticeEntity) onFailed,
  var code,
}) =>
        (Store<AppState> store) async {
      final maService = await MaFactory().getMaService();

      const authorizationCode = 'authorization_code';
      const clientCredentials = 'client_credentials';

      var state = store.state;

      var response = await maService.post(MaApi.Token, data: {
        'client_id': state.clientId,
        'client_secret':state.clientSecret,
        'redirect_uri': MaGlobalValue.redirectUrl,
        'scope': MaGlobalValue.scopes,
        'grant_type': grantType ? authorizationCode : clientCredentials,
        'code': code ?? ''
      });

      if (response.code == MaApiResponse.codeOk) {

        store.dispatch(AccountAccessTokenAction(
          accessToken: 'Bearer ${response.data[MaGlobalValue.accessToken]}'
        ));

        if (onSucceed != null) onSucceed();
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

// 验证令牌有效性
ThunkAction<AppState> verifyAccessTokenAction(
    bool isUserLevel, final accessToken,
    {
      void Function(UserEntity) onAccountSucceed,
      void Function() onClientSucceed,
      void Function(NoticeEntity) onFailed,
    }) =>
        (Store<AppState> store) async {
      final maService = await MaFactory().getMaService();
      var response = await maService
          .get(isUserLevel ? MaApi.VerifyAccountToken : MaApi.VerifyClientToken,
          headers: {'Authorization': accessToken});

      if (response.code == MaApiResponse.codeOk) {
        if(isUserLevel){
          if (onAccountSucceed != null){
            store.dispatch(AccountInfoAction(
              user: UserEntity.fromJson(response.data)
            ));
            onAccountSucceed(UserEntity.fromJson(response.data));
          }
        }
        else{
          if (onClientSucceed != null) onClientSucceed();
        }
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };


// 撤销令牌
ThunkAction<AppState> revokeAccessTokenAction(
    {
      void Function() onSucceed,
      void Function(NoticeEntity) onFailed,
    }) =>
        (Store<AppState> store) async {
      final maService = await MaFactory().getMaService();
      var state = store.state;

      final accessToken = state.account.accessToken.split(' ')[1];

      var response = await maService.post(MaApi.Revoke, data: {
        'client_id': state.clientId,
        'client_secret': state.clientSecret,
        'token': accessToken,
      });

      if (response.code == MaApiResponse.codeOk) {
        if (onSucceed != null){
          store.dispatch(AccountAccessTokenAction(accessToken: ''));
          store.dispatch(ResetStateAction);
          onSucceed();
        }
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };


ThunkAction<AppState> accountEditAction(
    final accessToken,
    {
      var discoverable,
      var displayName,
      var note,
      var avatar,
      var header,
      bool locked,
      void Function(UserEntity) onSucceed,
      void Function(NoticeEntity) onFailed,
    }) =>
        (Store<AppState> store) async {
      final wgService = await MaFactory().getMaService();

      var state = store.state.account;

      final response = await wgService.patch(
        MaApi.UpdateAccount,
        headers: {'Authorization': accessToken},
        data: {
          'discoverable' : discoverable ?? true,
          'display_name' : displayName ?? state.user.displayName,
//          'note' : note ?? MaMeta.user.note,
//          'avatar' : avatar ?? MaMeta.user.avatar,
//          'header' : header ?? MaMeta.user.header,
          'locked' : locked ?? state.user.locked,
        },
      );

      if (response.code == MaApiResponse.codeOk) {
        store.dispatch(AccountInfoAction(
          user: UserEntity.fromJson(response.data),
        ));
        if (onSucceed != null) onSucceed(UserEntity.fromJson(response.data));
      }
      else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

//ThunkAction<AppState> accountSendMobileVerifyCodeAction({
//  @required String type,
//  @required String mobile,
//  void Function() onSucceed,
//  void Function(NoticeEntity) onFailed,
//}) =>
//        (Store<AppState> store) async {
//      final wgService = await MaFactory().getMaService();
//      final response = await wgService.post(
//        '/account/send/mobile/verify/code',
//        data: {'type': type, 'mobile': mobile},
//      );
//
//      if (response.code == MaApiResponse.codeOk) {
//        if (onSucceed != null) onSucceed();
//      } else {
//        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
//      }
//    };