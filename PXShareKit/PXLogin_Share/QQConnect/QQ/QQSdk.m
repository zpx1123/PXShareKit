//
//  QQSdk.m
//  PXShareKit
//
//  Created by 周鹏翔 on 15/12/18.
//  Copyright © 2015年 周鹏翔. All rights reserved.
//

#import "QQSdk.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "ShareContent.h"
#import "WDThirdPartyKitAuthDelegate.h"


@interface QQSdk()<TencentSessionDelegate>{
    
    
}

@end


@implementation QQSdk

+ (instancetype) shareInstance
{
    static QQSdk *_currentQQSdk;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _currentQQSdk = [[QQSdk alloc] init];
    });
    return _currentQQSdk;
}
/**
 *  注册
 *
 *  @return 返回注册是否成功
 */
-(BOOL)registApp{
    
    _tencentOAuth=[[TencentOAuth alloc]initWithAppId:_appKey andDelegate:self];
    
    return nil;
}

/**
 *  获取个人用户信息
 ＊ 获取成功之后 会抛出到 WDLoginResponse对应信息
 */

-(void)getUserInfo{
    
    
    BOOL isgetuserInfo= [_tencentOAuth getUserInfo];
    
   }

/**
 *  第三方登录
 *
 *  @param viewController viewcontroller实现登录之后代理方法
 */

-(void)login:(UIViewController *)viewController{
    
    
    _authDelegate=nil;
    _authDelegate=(id<WDAuthDelegate>)viewController;
    
    if ([TencentOAuth iphoneQQInstalled]) {
        
        NSArray* permissions = [NSArray arrayWithObjects:
                                kOPEN_PERMISSION_GET_USER_INFO,
                                kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                nil];
        if (![_tencentOAuth authorize:permissions inSafari:NO]) {
            NSLog(@"授权失败");
        }else{
            NSLog(@"授权ok");
            //            BOOL iss= [_tencentOAuth getUserInfo];
        }
        
    }else{
        
        NSLog(@"use webview login QQ");
    }
}

/**
 *  分享
 *
 *  @param content  分享数据
 *  @param where    广场还是好友（枚举）
 *  @param delegate 代理回调
 */
-(void)ShareContentInfo:(ShareContent*)content To:(ShareWhere)where delegate:(id<WDShareSDKDelegate>)delegate{
    
    
    _shareDelegate=nil;
    _shareDelegate=delegate;
    
    
    if([QQApiInterface isQQInstalled]|| [TencentApiInterface isTencentAppInstall:kIphoneQZONE]){
        
        QQApiNewsObject *newsObject = [self qqMessageFrom:content];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObject];
        QQApiSendResultCode sent;
        if(where == ShareFirends){
            sent = [QQApiInterface sendReq:req];
        }else if(where == ShareSquare){
            sent = [QQApiInterface SendReqToQZone:req];
        }else{
            //消除警告
            sent = EQQAPISENDFAILD;
        }
        NSLog(@"sent %d",sent);
        
        
    }
    
}



#pragma mark - qq回调

- (void)addShareResponse:(APIResponse*) response{
    
    
    
}
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        [_tencentOAuth isSessionValid];
        
        
        if (_authDelegate
            && [_authDelegate respondsToSelector:@selector(WDLoginResponse:WithInfo:Success:)]) {
            
            NSDictionary *userInfo = @{@"accessToken": _tencentOAuth.accessToken,
                                       @"expirationDate": _tencentOAuth.expirationDate,
                                       @"openId": _tencentOAuth.openId,
                                       @"appId":  _tencentOAuth.appId
                                       };
            
            [_authDelegate WDLoginResponse:LoginQQ WithInfo:userInfo Success:YES];
        }
        
    }
    else
    {
        NSLog(@"登录不成功 没有获取accesstoken");
    }
    
   
    
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    
    if (_authDelegate
        && [_authDelegate respondsToSelector:@selector(WDLoginResponse:WithInfo:Success:)]) {
        
        [_authDelegate WDLoginResponse:LoginQQ WithInfo:nil Success:NO];
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    
    if (_authDelegate
        && [_authDelegate respondsToSelector:@selector(WDLoginResponse:WithInfo:Success:)]) {
        
        [_authDelegate WDLoginResponse:LoginQQ WithInfo:nil Success:NO];
    }
}

/**
 * 登录时权限信息的获得
 */
- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams{
    return nil;
}
/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response{
    
    
}

-(QQApiNewsObject *)qqMessageFrom:(ShareContent *)pContent
{
    NSData *imageData;
    if(pContent.image){
        imageData = UIImageJPEGRepresentation(pContent.image, 0.7);
    }
    
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:pContent.url] title:pContent.title description:[NSString stringWithFormat:@"%@ %@",pContent.content,pContent.url] previewImageData:imageData];
    
    return newsObj;
}

@end
