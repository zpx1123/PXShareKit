//
//  WeixinSdk.h
//  PXShareKit
//
//  Created by 周鹏翔 on 15/12/21.
//  Copyright © 2015年 周鹏翔. All rights reserved.
//

#import "ThirdPartyApi.h"
#import "WXApi.h"

@interface WeixinSdk : ThirdPartyApi<WXApiDelegate>
@property (nonatomic,strong) NSString *appKey;
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
 *  获取个人用户信息  微信需要自行调api接口，在登录回调返回code 信息 自行在回调出口获取个人用户信息
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
 *  @param where    朋友圈还是微信好友（枚举）
 *  @param delegate 代理回调
 */
-(void)ShareContentInfo:(ShareContent*)content To:(ShareWhere)where delegate:(id<WDShareSDKDelegate>)delegate;
@end
