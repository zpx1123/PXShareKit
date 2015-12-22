//
//  WeixinSdk.m
//  PXShareKit
//
//  Created by 周鹏翔 on 15/12/21.
//  Copyright © 2015年 周鹏翔. All rights reserved.
//

#import "WeixinSdk.h"
#import "ShareContent.h"

static NSString *kAuthScope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";

@implementation WeixinSdk

+ (instancetype) shareInstance
{
    static WeixinSdk *_currentWeixinSdk;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _currentWeixinSdk = [[WeixinSdk alloc] init];
    });
    return _currentWeixinSdk;
}

-(BOOL)registApp{
    
    //向微信注册
//    BOOL isInstallWX=[WXApi isWXAppInstalled];//把微信加入白名单
    
    BOOL issucess= [WXApi registerApp:_appKey withDescription:@"demo 2.0"];
    if (issucess) {
        
        return YES;
        
    }else{
        
        return NO;
    }
}

-(void)dealloc{
    
    NSLog(@"weixinClass is dealloc");
    _authDelegate=nil;
    _shareDelegate=nil;
}

#pragma mark - 登录
-(void)login:(UIViewController *)viewController{
    _authDelegate=nil;
    _authDelegate=(id<WDAuthDelegate>)viewController;
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = kAuthScope; // @"post_timeline,sns"
    req.state = @"chinadance";
  //req.openID = kAuthOpenID;
    
    [WXApi sendAuthReq:req viewController:viewController delegate:self];
}

-(void)ShareContentInfo:(ShareContent*)content To:(ShareWhere)where delegate:(id<WDShareSDKDelegate>)delegate{
    
    
    _shareDelegate=nil;
    _shareDelegate=delegate;
    
    //    if([WXApi isWXAppInstalled]){
    
    SendMessageToWXReq *wechatReq = [[SendMessageToWXReq alloc] init];
    WXMediaMessage *message = [self wechatMessageFrom:content];
    wechatReq.message = message;
    wechatReq.bText = NO;
    if(where == ShareFirends){
        wechatReq.scene = WXSceneSession;
    }else{
        wechatReq.scene = WXSceneTimeline;
    }
    [WXApi sendReq:wechatReq];
    
    //    }
}


-(void)getUserInfo{
    
//    https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317851&token=&lang=zh_CN
    
//    https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID

}

#pragma mark - 微信回调接口

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_shareDelegate
            && [_shareDelegate respondsToSelector:@selector(WDshareSDKResponse:Success:)]) {
            
            [_shareDelegate WDshareSDKResponse:ShareWeiXin Success:YES];
        }
        
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {

        if (_authDelegate
            && [_authDelegate respondsToSelector:@selector(WDLoginResponse:WithInfo:Success:)]) {
            
            SendAuthResp *authResp = (SendAuthResp *)resp;
            NSMutableDictionary * infoDic=[NSMutableDictionary dictionary];
            infoDic[@"code"] = authResp.code;
            infoDic[@"errCode"]= [NSNumber numberWithInt:authResp.errCode];
            infoDic[@"errStr"]= authResp.errStr;
            
            [_authDelegate WDLoginResponse:LoginWeiXin WithInfo:infoDic Success:YES];
        }
        
//
//            通过code获取access_token
//            https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
//
//            {
//                "access_token":"ACCESS_TOKEN",
//                "expires_in":7200,
//                "refresh_token":"REFRESH_TOKEN",
//                "openid":"OPENID",
//                "scope":"SCOPE",
//                
//                "unionid":"o6_bmasdasdsad6_2sgVt7hMZOPfL"
//                
//            }
            
//            {"errcode":40029,"errmsg":"invalid code"}
            
//            获取用户信息
            //    https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
       
       
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {

        
    }
}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {

    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {

    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {

    }
}

#pragma  mark - 私有方法
-(WXMediaMessage *)wechatMessageFrom:(ShareContent *)pContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = pContent.title;
    message.description = [NSString stringWithFormat:@"%@ %@", pContent.content,pContent.url];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = pContent.url;
    if(pContent.image){
        NSData *imageData = UIImageJPEGRepresentation(pContent.image, 0.7);
        [message setThumbData:imageData];
    }
    message.mediaObject = webpageObject;
    return message;
}

//- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
//    NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
//    NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
//                                                    message:strMsg
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil, nil];
//    [alert show];
//
//}
//- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)req {
//    WXMediaMessage *msg = req.message;
//    
//    //显示微信传过来的内容
//    WXAppExtendObject *obj = msg.mediaObject;
//    
//    NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
//    NSString *strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n附加消息:%@\n", req.openID, msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length, msg.messageExt];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
//                                                    message:strMsg
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil, nil];
//    [alert show];
//    
//}
@end
