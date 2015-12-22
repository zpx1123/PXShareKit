//
//  WeixinFactory.m
//  PXShareKit
//
//  Created by 周鹏翔 on 15/12/21.
//  Copyright © 2015年 周鹏翔. All rights reserved.
//

#import "WeixinFactory.h"
#import "WeixinSdk.h"
@implementation WeixinFactory
-(ThirdPartyApi *)ThirdPartyConnectWithAppKey:(NSString *)appKey
                                    appSecret:(NSString *)appSecret
                                  redirectUri:(NSString *)redirectUri{
    
   

    WeixinSdk * weixinsdk=[WeixinSdk shareInstance];
    weixinsdk.appKey=appKey;
//    [weixinsdk registApp];
    return weixinsdk;
}
@end
