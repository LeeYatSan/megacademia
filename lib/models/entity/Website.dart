class WebsiteEntity extends Object {
  final String name;
  final String url;
  final String logoUrl;

  WebsiteEntity({
    this.name = '',
    this.url = '',
    this.logoUrl = '',
  });
}

final List<WebsiteEntity> websites = [
  WebsiteEntity(name: '百度学术', url: 'http://xueshu.baidu.com/', logoUrl: 'http://s1.bdstatic.com/r/www/cache/mid/static/xueshu/img/logo_4b1971d.gif'),
  WebsiteEntity(name: 'Google 学术搜索', url: 'https://scholar.google.com.hk/?hl=zh-CN', logoUrl: 'https://scholar.google.com.hk/intl/zh-CN/scholar/images/2x/scholar_logo_64dp.png'),
  WebsiteEntity(name: '中国知网', url: 'https://www.cnki.net/', logoUrl: 'https://piccache.cnki.net/kdn/index/kns7/nimages/foot-logo.png'),
  WebsiteEntity(name: '万方数据', url: 'http://www.wanfangdata.com.cn/index.html', logoUrl: 'http://cdn.login.wanfangdata.com.cn/Content/src/img/anxs-logo_sns.png'),
  WebsiteEntity(name: '维普资讯', url: 'http://www.cqvip.com/', logoUrl: 'http://image.cqvip.com/www/img/logo.png'),
  WebsiteEntity(name: 'SpringerInk', url: 'https://link.springer.com/', logoUrl: 'https://link.springer.com/static/97cb41eb16154e585855cb356c8e9ce735d78158/sites/link/images/logo_high_res.png'),
  WebsiteEntity(name: 'ScienceDiret', url: 'https://www.sciencedirect.com/', logoUrl: 'https://sdfestaticassets-us-east-1.sciencedirectassets.com/shared-assets/47/images/elsevier-non-solus-new-with-wordmark.svg'),
  WebsiteEntity(name: 'Wiley Online Libarary', url: 'https://onlinelibrary.wiley.com/', logoUrl: 'https://onlinelibrary.wiley.com/pb-assets/hub-assets/pericles/logo-header-1526603583437.png'),
  WebsiteEntity(name: 'Web of Sicence', url: 'http://login.webofknowledge.com', logoUrl: 'http://login.webofknowledge.com/error/WOK5/6.25.0.65/images/crv_logo_rgb_pos.svg'),
  WebsiteEntity(name: 'Engineering Village', url: 'http://www.engineeringvillage.com/', logoUrl: 'https://www.engineeringvillage.com/static/images/ELS_Wordmark_1C_151_RGB.png'),
  WebsiteEntity(name: 'Sage Journals', url: 'https://journals.sagepub.com/', logoUrl: 'https://journals.sagepub.com/pb-assets/Images/SJ%20-LOGO-1513073727437.png'),
  WebsiteEntity(name: 'ADS', url: 'https://ui.adsabs.harvard.edu/', logoUrl: 'https://ui.adsabs.harvard.edu/styles/img/transparent_logo.svg'),
];