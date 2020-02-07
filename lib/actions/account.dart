import 'package:megacademia/config.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../factory.dart';
import '../meta.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'reset.dart';

//class AccountInfoAction {
//  final UserEntity user;
//
//  AccountInfoAction({
//    @required this.user,
//  });
//}
//
//ThunkAction<AppState> accountRegisterAction({
//  @required RegisterForm form,
//  void Function(UserEntity) onSucceed,
//  void Function(NoticeEntity) onFailed,
//}) =>
//        (Store<AppState> store) async {
//      final wgService = await MaFactory().getMaService();
//      final response = await wgService.post(
//        '/account/register',
//        data: form.toJson(),
//      );
//
//      if (response.code == MaApiResponse.codeOk) {
//        final user = UserEntity.fromJson(response.data['user']);
//        if (onSucceed != null) onSucceed(user);
//      } else {
//        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
//      }
//    };
//
//ThunkAction<AppState> accountLoginAction({
//  @required LoginForm form,
//  void Function(UserEntity) onSucceed,
//  void Function(NoticeEntity) onFailed,
//}) =>
//        (Store<AppState> store) async {
//      final wgService = await MaFactory().getMaService();
//      final response = await wgService.post(
//        '/account/login',
//        data: form.toJson(),
//      );
//
//      if (response.code == MaApiResponse.codeOk) {
//        final user = UserEntity.fromJson(response.data['user']);
//        store.dispatch(AccountInfoAction(user: user));
//        if (onSucceed != null) onSucceed(user);
//      } else {
//        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
//      }
//    };
//
//ThunkAction<AppState> accountLogoutAction({
//  void Function() onSucceed,
//  void Function(NoticeEntity) onFailed,
//}) =>
//        (Store<AppState> store) async {
//      final wgService = await MaFactory().getMaService();
//      final response = await wgService.get('/account/logout');
//
//      if (response.code == MaApiResponse.codeOk) {
//        store.dispatch(ResetStateAction());
//        if (onSucceed != null) onSucceed();
//      } else {
//        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
//      }
//    };

// 获取账户信息
ThunkAction<AppState> accountInfoAction({
  void Function(String) onSucceed,
  void Function(NoticeEntity) onFailed,
}) =>
        (Store<AppState> store) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final maService = await MaFactory().getMaService();

      var response = await maService.post(MaApi.Apps, data: {
        "client_name": MaGlobalValue.clientName,
        "redirect_uris": MaGlobalValue.redirectUrl,
        "scopes": MaGlobalValue.scopes,
      });

      if (response.code == MaApiResponse.codeOk) {
        MaMeta.clientId = response.data[MaGlobalValue.clientId];
        MaMeta.clientSecret = response.data[MaGlobalValue.clientSecret];
        prefs.setString(MaGlobalValue.clientId, MaMeta.clientId);
        prefs.setString(MaGlobalValue.clientSecret, MaMeta.clientSecret);

        if (onSucceed != null) onSucceed(MaMeta.clientId);
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final maService = await MaFactory().getMaService();

      const authorizationCode = 'authorization_code';
      const clientCredentials = 'client_credentials';

      var response = await maService.post(MaApi.Token, data: {
        'client_id': MaMeta.clientId,
        'client_secret':MaMeta.clientSecret,
        'redirect_uri': MaGlobalValue.redirectUrl,
        'scope': MaGlobalValue.scopes,
        'grant_type': grantType ? authorizationCode : clientCredentials,
        'code': code ?? ''
      });

      if (response.code == MaApiResponse.codeOk) {
        MaMeta.userAccessToken = 'Bearer ${response.data[MaGlobalValue.accessToken]}';
        prefs.setString(MaGlobalValue.accessToken, MaMeta.userAccessToken);
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
          if (onAccountSucceed != null)
            onAccountSucceed(UserEntity.fromJson(response.data));
        }
        else{
          if (onClientSucceed != null) onClientSucceed();
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

      final _logger = MaFactory().getLogger('Maservice');
      _logger.fine("access token: $accessToken");
      _logger.fine("display_name: ${displayName ?? MaMeta.user.displayName}");
      _logger.fine("discoverable: ${discoverable ?? true}");
      _logger.fine("note: ${note ?? MaMeta.user.note}");
      _logger.fine("locked: ${locked ?? MaMeta.user.locked}");

      final response = await wgService.patch(
        MaApi.UpdateAccount,
        headers: {'Authorization': accessToken},
        data: {
          'discoverable' : discoverable ?? true,
          'display_name' : displayName ?? MaMeta.user.displayName,
//          'note' : note ?? MaMeta.user.note,
//          'avatar' : avatar ?? MaMeta.user.avatar,
//          'header' : header ?? MaMeta.user.header,
          'locked' : locked ?? MaMeta.user.locked,
        },
      );

      if (response.code == MaApiResponse.codeOk) {
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