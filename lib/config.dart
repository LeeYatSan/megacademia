import 'package:package_info/package_info.dart';
import 'package:logging/logging.dart';

class MaConfig {
  static PackageInfo packageInfo;
  static var domain = 'leeyatsan.cn';
//  static var domainExtended = '10.0.2.2:8000';
  static var domainExtended = '212.129.242.145:80';
  static var maApiBaseUrl = 'https://$domain';
  static var maApiBaseUrlExtended = 'http://$domainExtended';
  static var debug = false;
  static var loggerLevel = Level.INFO;
  static var isLogAction = false;
  static var isLogApi = false;
}

class MaGlobalValue {
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
  static var about = '软件版本：${MaConfig.packageInfo.version}\n\n关于Magacademia：\n${MaGlobalValue
      .aboutMegacademia}\n\n关于Mastodon：\n${MaGlobalValue.aboutMastodon}';
}

class MaApi {
  static var maApiSubBaseUrl = '/api/v1';
  static String ServerList = 'https://instances.social/api/1.0/instances/list'; // 获取servrlist

  static String Apps = '$maApiSubBaseUrl/apps'; // 注册app信息
  static String Token = '/oauth/token'; // 获取header Authorization
  static String Revoke = '/oauth/revoke'; // 撤销授权码
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
  static String FollowingRequests = '$maApiSubBaseUrl/follow_requests'; // 获取关注请求信息
  static String PushNewTooT = '$maApiSubBaseUrl/statuses'; // 发送一个新文章
  static String UpdateAccount = '$maApiSubBaseUrl/accounts/update_credentials'; // 更新用户信息
  static String Media = '$maApiSubBaseUrl/media'; // 媒体文件
  static String Muting = '$maApiSubBaseUrl/mutes'; // 获取静默用户列表
  static String Blocked = '$maApiSubBaseUrl/blocks'; // 获取黑名单
  static String Relationship = '$maApiSubBaseUrl/accounts/relationships'; // 获取关系
  static String Interests = '${MaConfig.maApiBaseUrlExtended}$maApiSubBaseUrl/extend/interest'; // 获取兴趣
  static String UploadFile = '${MaConfig.maApiBaseUrlExtended}$maApiSubBaseUrl/extend/upload_file'; // 获取上传文件
  static String CSRF = '${MaConfig.maApiBaseUrlExtended}$maApiSubBaseUrl/extend/get_csrf'; // 获取CSRF认证
  static String SearchInterest = '${MaConfig.maApiBaseUrlExtended}$maApiSubBaseUrl/extend/search_interest'; // 获取用户感兴趣的动态
  static String Account(arg) {
    return '$maApiSubBaseUrl/accounts/$arg';
  }  // 获取用户信息
  static String Following(arg) {
    return '$maApiSubBaseUrl/accounts/$arg/following';
  }  // 获取用户关注的用户
  static String Follower(arg) {
    return '$maApiSubBaseUrl/accounts/$arg/followers';
  }  // 获取用户的粉丝
  static String Mute(arg) {
    return '$maApiSubBaseUrl/accounts/$arg/mute';
  }  // 设置一个静默用户
  static String Unmute(arg) {
    return '$maApiSubBaseUrl/accounts/$arg/unmute';
  }  // 移除一个静默用户
  static String Block(arg) {
    return '$maApiSubBaseUrl/accounts/$arg/block';
  }  // 设置一个黑名单用户
  static String Unblock(arg) {
    return '$maApiSubBaseUrl/accounts/$arg/unblock';
  }  // 设置一个黑名单用户
  static String UersArticle(arg, pragma) {
    return '$maApiSubBaseUrl/accounts/$arg/statuses?$pragma';
  } // 获取一个用户已经发送的嘟文
  static String Follow(arg) {
    return '$maApiSubBaseUrl/accounts/$arg/follow';
  } // 关注某人
  static String UnFollow(arg) {
    return '$maApiSubBaseUrl/accounts/$arg/unfollow';
  } // 取关某人
  static String CustomEmojis = '$maApiSubBaseUrl/custom_emojis'; // 该节点的emojis
  static String Favourites = '$maApiSubBaseUrl/favourites'; // 点赞的嘟文
  static String Favourite(arg) {
    return '$maApiSubBaseUrl/statuses/$arg/favourite'; // 点赞某个嘟文
  }
  static String UnFavourite(arg) {
    return '$maApiSubBaseUrl/statuses/$arg/unfavourite'; // 取消点赞某个嘟文
  }
  static String Boost(arg) {
    return '$maApiSubBaseUrl/statuses/$arg/reblog'; // 转发嘟文
  }
  static String Unboost(arg) {
    return '$maApiSubBaseUrl/statuses/$arg/reblog'; // 取消转发某个嘟文
  }
  static String DeleteStatus(arg) {
    return '$maApiSubBaseUrl/statuses/$arg'; // 删除某个嘟文
  }
  static String PublishStatuses(arg) {
    return '$maApiSubBaseUrl/statuses/$arg'; // 发表某个嘟文
  }
  static String SomeonesStatuses(arg) {
    return '$maApiSubBaseUrl/accounts/$arg/statuses'; // 查看某人嘟文
  }
  static String AgreeFollowing(arg) {
    return '$maApiSubBaseUrl/follow_requests/$arg/authorize'; // 同意关注
  }
  static String DisagreeFollowing(arg) {
    return '$maApiSubBaseUrl/follow_requests/$arg/reject'; // 拒绝关注
  }
  static String PublicStatuses = '$maApiSubBaseUrl/timelines/public'; // 查看公共嘟文
  static String ShortLink = 'http://lnurl.cn/tcn/api';// 生成短链接
  static String DismissSingleNotification(arg) {
    return '$maApiSubBaseUrl/notifications/$arg/dismiss'; // 删除某条通知
  }
  static String Trends = '$maApiSubBaseUrl/trends'; // 获取趋势
  static String Search = '/api/v2/search';// 搜索
  static String Tag = '/tag';// 标签
  static String HashTagTimeline(arg) {
    return '$maApiSubBaseUrl/timelines/tag/$arg'; // 删除某条通知
  }
  static String SocialNetworkGraph(arg) {
    return '${MaConfig.maApiBaseUrlExtended}$maApiSubBaseUrl/extend/get_social_network_graph/$arg'; // 获取用户社交关系图
  }
}