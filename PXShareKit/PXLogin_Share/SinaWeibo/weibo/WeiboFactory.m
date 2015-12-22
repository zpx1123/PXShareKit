//
//  WeiboFactory.m
//  PXShareKit
//
//  Created by 周鹏翔 on 15/12/18.
//  Copyright © 2015年 周鹏翔. All rights reserved.
//

#import "WeiboFactory.h"
#import "weiboManage.h"

@implementation WeiboFactory
-(ThirdPartyApi *)ThirdPartyConnectWithAppKey:(NSString *)appKey
                                    appSecret:(NSString *)appSecret
                                  redirectUri:(NSString *)redirectUri{
    
    weiboManage * weibosdk=[weiboManage shareInstance];
    weibosdk.appKey=appKey;
    weibosdk.appSecret=appSecret;
    weibosdk.redirectUri=redirectUri;

    return weibosdk;
}
@end
