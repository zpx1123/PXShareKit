//
//  weiboManage.m
//  PXShareKit
//
//  Created by 周鹏翔 on 15/12/22.
//  Copyright © 2015年 周鹏翔. All rights reserved.
//

#import "weiboManage.h"
#import "WeiboSDK.h"
#define kAppKey         @"2045436852"

@implementation weiboManage

/**
 *  单例对象
 *
 *  @return 返回一个全局单例的DWZShareSDK对象
 */
+ (instancetype) shareInstance
{
    static weiboManage *_currentweiboManage;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _currentweiboManage = [[weiboManage alloc] init];
    });
    return _currentweiboManage;
}

/**
 *  注册
 *
 *  @return 返回注册是否成功
 */
-(BOOL)registApp{
    
    
//    [WeiboSDK enableDebugMode:YES];
//    if ([WeiboSDK isWeiboAppInstalled]) {
//        
//        
//    }else{
//        NSLog(@"微博没有安装");
//    }
    
    if ([WeiboSDK registerApp:_appKey]) {
        
        return YES;
        
    }else{
        
        return NO;
    }

}

/**
 *  获取个人用户信息
 */

-(void)getUserInfo{
    
}

/**
 *  第三方登录
 *
 *  @param viewController viewcontroller实现登录之后代理方法
 */

-(void)login:(UIViewController *)viewController{
    
    _authDelegate=nil;
    _authDelegate=(id<WDAuthDelegate>)viewController;
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    request.scope = @"email,direct_messages_write";
    request.userInfo = @{@"SSO_From": NSStringFromClass([viewController class]),
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    request.shouldOpenWeiboAppInstallPageIfNotInstalled=NO;
    [WeiboSDK sendRequest:request];
}

- (void)ssoOut
{
//    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [WeiboSDK logOutWithToken:myDelegate.wbtoken delegate:self withTag:@"user1"];
}

/**
 *  分享
 *
 *  @param content  分享数据
 *  @param where    （枚举）
 *  @param delegate 代理回调
 */
-(void)ShareContentInfo:(ShareContent*)content To:(ShareWhere)where delegate:(id<WDShareSDKDelegate>)delegate{
    
    _shareDelegate=nil;
    _shareDelegate=delegate;
    
//    if([WeiboSDK isWeiboAppInstalled]){
        WBMessageObject *obj = [self weiboMessageFrom:content];
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:obj];
        request.userInfo = @{@"shareMessageFrom":@"DWZShareKitDemo"};
        [WeiboSDK sendRequest:request];
        
//    }else{
//        
//    }
    
}

#pragma mark - sina weibodelegate

/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        
        if (_shareDelegate
            && [_shareDelegate respondsToSelector:@selector(WDshareSDKResponse:Success:)]) {
            
            [_shareDelegate WDshareSDKResponse:ShareWeiBo Success:YES];
        }
        
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
//            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
//            self.wbCurrentUserID = userID;
        }
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        
        if (_authDelegate
            && [_authDelegate respondsToSelector:@selector(WDLoginResponse:WithInfo:Success:)]) {
            
            WBAuthorizeResponse *authResp = (WBAuthorizeResponse *)response;
            NSMutableDictionary * infoDic=[NSMutableDictionary dictionary];
            infoDic[@"userid"] = authResp.userID;
            infoDic[@"expirationDate"]= authResp.expirationDate;
            infoDic[@"accessToken"]= authResp.accessToken;
            infoDic[@"userInfo"]= authResp.userInfo;
            
            [_authDelegate WDLoginResponse:LoginWeiXin WithInfo:infoDic Success:YES];
        }
        
        
        NSString *title = NSLocalizedString(@"认证结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        
//        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
//        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
//        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        [alert show];
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
        NSString *title = NSLocalizedString(@"支付结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if([response isKindOfClass:WBSDKAppRecommendResponse.class])
    {
        NSString *title = NSLocalizedString(@"邀请结果", nil);
        NSString *message = [NSString stringWithFormat:@"accesstoken:\n%@\nresponse.StatusCode: %d\n响应UserInfo数据:%@\n原请求UserInfo数据:%@",[(WBSDKAppRecommendResponse *)response accessToken],(int)response.statusCode,response.userInfo,response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - sina weibo
- (WBMessageObject *)weiboMessageFrom:(ShareContent *)pContent
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"%@ %@ %@",pContent.title,pContent.content,pContent.url];
    if(message.text.length >140){
        NSString *str = [NSString stringWithFormat:@"%@ %@",pContent.title,pContent.content];
        if(str.length > 140-pContent.url.length){
            message.text = [NSString stringWithFormat:@"%@ %@",[str substringToIndex:140-pContent.url.length],pContent.url];
        }else{
            message.text = [message.text substringToIndex:139];
        }
    }
    if(pContent.image){
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = UIImageJPEGRepresentation(pContent.image, 0.7);
        message.imageObject = imageObject;
    }
    return message;
}

-(void)dealloc{
    
    _authDelegate=nil;
    _shareDelegate=nil;
}
@end

