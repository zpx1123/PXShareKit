//
//  ThirdPartyApi.h
//  PXShareKit
//
//  Created by 周鹏翔 on 15/12/18.
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
#import "ThirdPartyApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WDThirdPartyKitAuthDelegate.h"
#import "ShareContent.h"


/**
 *  三方登录基类（接口）
 *
 */
@interface ThirdPartyApi : NSObject



/**
 *  注册
 *
 *  @return 返回注册是否成功
 */
-(BOOL)registApp;

/**
 *  获取个人用户信息
 ＊ 获取成功之后 会抛出到 WDLoginResponse对应信息
 */

-(void)getUserInfo;

/**
 *  第三方登录
 *
 *  @param viewController viewcontroller实现登录之后代理方法
 */

-(void)login:(UIViewController *)viewController;

/**
 *  分享
 *
 *  @param content  分享数据
 *  @param where    广场还是好友（枚举）
 *  @param delegate 代理回调
 */
-(void)ShareContentInfo:(ShareContent*)content To:(ShareWhere)where delegate:(id<WDShareSDKDelegate>)delegate;
@end
