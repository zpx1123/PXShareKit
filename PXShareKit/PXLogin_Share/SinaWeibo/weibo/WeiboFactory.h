//
//  WeiboFactory.h
//  PXShareKit
//
//  Created by 周鹏翔 on 15/12/18.
//  Copyright © 2015年 周鹏翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThirdPartyKit.h"
@interface WeiboFactory : ThirdPartyKit
-(ThirdPartyApi *)ThirdPartyConnectWithAppKey:(NSString *)appKey
                                    appSecret:(NSString *)appSecret
                                  redirectUri:(NSString *)redirectUri;
@end
