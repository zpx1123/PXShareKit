# PXShareKit
微信 微博 qq 三方登录  分享


  [self thirdPary:@"WeiboFactory"];
  [self thirdPary:@"QQFactory"];
  [self thirdPary:@"WeixinFactory"];
           
           
           
-(void)thirdPary:(NSString * )Factory{
    
    Class class=NSClassFromString(Factory);
    ThirdPartyKit * kit=[class new];
    api=[kit ThirdPartyConnectWithAppKey:WeChatAppId appSecret:WeChatAppKey redirectUri:WeChatRedirectURI];
    [api registApp];
    [api login:self];
    
    
}
环境参考官方文档：
https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419318634&token=&lang=zh_CN
http://open.weibo.com/wiki/SDK
http://wiki.open.qq.com/wiki/IOS_API%E8%B0%83%E7%94%A8%E8%AF%B4%E6%98%8E
