import 'package:megacademia/actions/actions.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:megacademia/config.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:path/path.dart';

import '../factory.dart';
import '../models/models.dart';
import '../services/services.dart';

class PublishNewStatusAction {
  final StatusEntity status;

  PublishNewStatusAction({
    @required this.status,
  });
}


class GetNodeCustomEmojisAction {
  final List<Emoji> emojis;

  GetNodeCustomEmojisAction({
    @required this.emojis,
  });
}


// 获取emoji
ThunkAction<AppState> getNodeCustomEmojisAction(
    {
      void Function() onSucceed,
      void Function(NoticeEntity) onFailed,
    }) =>
        (Store<AppState> store) async {
      final maService = await MaFactory().getMaService();

      var response = await maService.get(MaApi.CustomEmojis,);

      if (response.code == MaApiResponse.codeOk) {
        final List<Emoji> emojis = (response.data[''] as List<dynamic>)
            .map<Emoji>((v) => Emoji.fromJson(v))
            .toList();

        store.dispatch(GetNodeCustomEmojisAction(emojis: emojis));

        if (onSucceed != null){
          onSucceed();
        }
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

// 发表动态
ThunkAction<AppState> publishAction(
    {
      String status,
      String inReplyToId,
      List<String> mediaIds,
      String visibility,
      void Function() onSucceed,
      void Function(NoticeEntity) onFailed,
    }) =>
        (Store<AppState> store) async {
      final maService = await MaFactory().getMaService();

      var state = store.state.account;
      var response = await maService.post(
        MaApi.PushNewTooT,
        headers: {'Authorization': state.accessToken,},
        data: {
          'status' : status ?? '',
          'in_reply_to_id' : inReplyToId,
          'media_ids' : mediaIds,
          'visibility' : visibility,
        }
      );

      if (response.code == MaApiResponse.codeOk) {
        if (onSucceed != null){
          onSucceed();
        }
      } else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

// 上传附件
ThunkAction<AppState> uploadMeidaAction(
    String media,
    {
      void Function(String) onSucceed,
      void Function(NoticeEntity) onFailed,
    }) =>
        (Store<AppState> store) async {
      final maService = await MaFactory().getMaService();
      var state = store.state.account;

      if(media == null) return;

      var formData = FormData.fromMap({
        'file' : MultipartFile.fromFileSync(media, filename: absolute(media))
      });

      final response = await maService.postForm(
        MaApi.Media,
        headers: {'Authorization': state.accessToken,},
        data: formData,
      );
      if (response.code == MaApiResponse.codeOk) {
        if (onSucceed != null)
          onSucceed(AttachmentEntity.fromJson(response.data).id);
      }
      else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };

// 上传附件
ThunkAction<AppState> transToShortLinkAction(
    String url,
    {
      void Function(String) onSucceed,
      void Function(NoticeEntity) onFailed,
    }) =>
        (Store<AppState> store) async {
      final maService = await MaFactory().getMaService();
      print('url: $url');

      final response = await maService.getNoBase(
        MaApi.ShortLink,
        queryParameters: {
          'key': 'ScKwD6wH3j',
          'url': url,
        }
      );
      if (response.code == MaApiResponse.codeOk) {
        print(response.data['']);
        if (onSucceed != null)
          onSucceed(response.data['']);
      }
      else {
        if (onFailed != null) onFailed(NoticeEntity(message: response.message));
      }
    };