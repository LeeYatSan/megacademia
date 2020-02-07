import 'package:package_info/package_info.dart';
import 'package:logging/logging.dart';

class MaConfig {
  static PackageInfo packageInfo;
  static var domain = 'leeyatsan.cn';
  static var maApiBaseUrl = 'https://$domain';
  static var debug = false;
  static var loggerLevel = Level.INFO;
  static var isLogAction = false;
  static var isLogApi = false;
}

class MaGlobalValue {
  static const clientName = "Megacademia";
  static const clientVersion = "V 0.1";
  static const copyRight = '©李逸辰（2020）';
  static const clientId = "client_id";
  static const clientSecret = "client_secret";
  static const accessToken = "access_token";
  static const redirectUrl = "urn:ietf:wg:oauth:2.0:oob";
  static const scopes = 'read write follow push';
  static const userInfo = 'user_info';
  static const fontFamily = 'MaIconFonts';
  static const aboutMastodon = 'Mastodon.social（中文译:万象）是一个免费开源的去中心化的分布式微博客社交网络。它的用户界面和操作方式跟推特类似，但是整个网络并非由单一机构运作，却是由多个由不同营运者独立运作的服务器以联邦方式交换数据而组成的去中心化社交网络。';
  static const aboutMegacademia = 'Megacademia.cn（中文译:学术万象）是一个基于Mastodon开源引擎的学术界社交软件，旨在创造更加专业、高效的学术研究社交环境，为学术人员提供一个交流、分享的平台。';
  static const about = '软件版本：${MaGlobalValue
      .clientVersion}\n\n关于Magacademia：\n${MaGlobalValue
      .aboutMegacademia}\n\n关于Mastodon：\n${MaGlobalValue.aboutMastodon}';
}
//class MaMeta {
//  static var clientId;
//  static var clientSecret;
//  static var userAccessToken;
//  static var appAccessToken;
//  static UserEntity user;
//}

class MaApi {
  static var maApiSubBaseUrl = '/api/v1';
  static String ServerList = 'https://instances.social/api/1.0/instances/list'; // 获取servrlist

  static String Apps = '$maApiSubBaseUrl/apps'; // 注册app信息
  static String Token = '/oauth/token'; // 获取header Authorization
  static String VerifyAccountToken = '$maApiSubBaseUrl/accounts/verify_credentials'; // 验证该header Authorization是否失效
  static String VerifyClientToken = '$maApiSubBaseUrl/apps/verify_credentials'; // 验证该header Authorization是否失效
  static String Register = '${MaConfig.maApiBaseUrl}/auth/sign_up';//注册页
  static String AuthEdit = '${MaConfig.maApiBaseUrl}/auth/edit';//修改密码 登录记录页
  static String MoreSetting = '${MaConfig.maApiBaseUrl}/settings/preferences/appearance';//更多设置
  static String HomeTimeLine = '$maApiSubBaseUrl/timelines/home'; // 首页时间线
  static String PublicTimeLine = '$maApiSubBaseUrl/timelines/public'; // 跨域时间线
  static String LocalTimeLine = '$maApiSubBaseUrl/timelines/public?local=true'; // 本站时间线
  static String OwnerAccount = '$maApiSubBaseUrl/accounts/verify_credentials'; // 该账号的信息
  static String Notifications = '$maApiSubBaseUrl/notifications'; // 获取用户的通知信息
  static String PushNewTooT = '$maApiSubBaseUrl/statuses'; // 发送一个新文章
  static String UpdateAccount = '$maApiSubBaseUrl/accounts/update_credentials'; // 更新用户信息
  static String Following(arg) {
    return '$maApiSubBaseUrl/accounts/$arg/following';
  }  // 获取一个用户关注的用户
  static String Follower(arg) {
    return '$maApiSubBaseUrl/accounts/$arg/followers';
  }  // 获取一个用户关注的用户
  static String UersArticle(arg, pragma) {
    return '$maApiSubBaseUrl/accounts/$arg/statuses?$pragma';
  } // 获取一个用户已经发送的嘟文
  static String Favourites = '$maApiSubBaseUrl/favourites'; // 收藏的嘟文
  static String Follow(arg) {
    return '$maApiSubBaseUrl/accounts/$arg/follow';
  } // 关注某人
  static String UnFollow(arg) {
    return '$maApiSubBaseUrl/accounts/$arg/unfollow';
  } // 取关某人
  static String Relationships = '$maApiSubBaseUrl/accounts/relationships'; // 查看与某人的关注或者被关注情况
  static String CustomEmojis = '$maApiSubBaseUrl/custom_emojis'; // 该节点的emojis
  static String FavouritesArticle(arg) {
    return '$maApiSubBaseUrl/statuses/$arg/favourite'; // 收藏某个文章
  }
  static String UnFavouritesArticle(arg) {
    return '$maApiSubBaseUrl/statuses/$arg/unfavourite'; // 取消收藏某个文章
  }
}