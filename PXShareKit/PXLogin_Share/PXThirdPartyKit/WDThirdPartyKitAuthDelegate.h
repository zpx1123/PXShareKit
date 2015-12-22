//
//  WDThirdPartyKitAuthDelegate.h
//  PXShareKit
//
//  Created by 周鹏翔 on 15/12/21.
//  Copyright © 2015年 周鹏翔. All rights reserved.
//
#define SinaWbAppKey         @"3705476230"
#define SinaWbSecret         @"90476c816329463b6aba87a3d3cf2342"
#define SinaWbRedirectURI    @"https://api.weibo.com/oauth2/default.html"

#define WeChatAppId        @"wx43288055c8299265"
#define WeChatAppKey       @"9ec610f85ada505f4721a05bc90d9c7a"
#define WeChatRedirectURI    @"http://d.91dingdong.com/"

#define TencentAppKey      @"1103835733"
#define TencentAppSecret   @"9e610eb9fd7043009053bbe9f2fbb89e"
#define TencentdirectURI   @"https://graph.qq.com/oauth2.0/authorize"
#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSUInteger, ShareType) {
    
    ShareWeiXin    = 0, //
    ShareWeiBo     = 1, //
    ShareQQ        = 2, //
    
    
};

typedef NS_OPTIONS(NSUInteger, LoginType) {
    
    LoginWeiXin    = 0, //
    LoginWeiBo     = 1, //
    LoginQQ        = 2, //
    
    
};
typedef NS_OPTIONS(NSUInteger, ShareWhere) {
    
    ShareFirends    = 0, //
    ShareSquare     = 1, //
    
    
};

@protocol WDShareSDKDelegate <NSObject>

- (void) WDshareSDKResponse:(ShareType)socialType Success:(BOOL)success;

@end

@protocol WDAuthDelegate <NSObject>

- (void) WDLoginResponse:(LoginType)socialType WithInfo:(NSDictionary *)userInfo Success:(BOOL)success;
@end


