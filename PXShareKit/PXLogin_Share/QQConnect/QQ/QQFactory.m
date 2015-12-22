//
//  QQFactory.m
//  PXShareKit
//
//  Created by 周鹏翔 on 15/12/18.
//  Copyright © 2015年 周鹏翔. All rights reserved.
//

#import "QQFactory.h"
#import "QQSdk.h"

@implementation QQFactory

-(ThirdPartyApi *)ThirdPartyConnectWithAppKey:(NSString *)appKey
                                    appSecret:(NSString *)appSecret
                                  redirectUri:(NSString *)redirectUri{
    
    
    QQSdk * qqsdk=[QQSdk shareInstance];
    qqsdk.appKey=appKey;
    qqsdk.appSecret=appSecret;
    qqsdk.redirectUri=redirectUri;
    return qqsdk;
    
}
@end
