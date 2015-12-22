//
//  weiboManage.h
//  PXShareKit
//
//  Created by 周鹏翔 on 15/12/22.
//  Copyright © 2015年 周鹏翔. All rights reserved.
//

#import "ThirdPartyApi.h"
#import "WeiboSDK.h"
@interface weiboManage : ThirdPartyApi<WeiboSDKDelegate>
@property (nonatomic,strong) NSString *appKey;
@property (nonatomic,strong) NSString *appSecret;
@property (nonatomic,strong) NSString *redirectUri;
@property (nonatomic,weak) id<WDShareSDKDelegate> shareDelegate;
@property (nonatomic,weak) id<WDAuthDelegate> authDelegate;

/**
 *  单例对象
 *
 *  @return 返回一个全局单例的DWZShareSDK对象
 */
+ (instancetype) shareInstance;

/**
 *  注册
 *
 *  @return 返回注册是否成功
 */
-(BOOL)registApp;

/**
 *  获取个人用户信息
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
 *  @param where    （枚举）
 *  @param delegate 代理回调
 */
-(void)ShareContentInfo:(ShareContent*)content To:(ShareWhere)where delegate:(id<WDShareSDKDelegate>)delegate;
@end
