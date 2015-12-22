//
//  QQFactory.h
//  PXShareKit
//
//  Created by 周鹏翔 on 15/12/18.
//  Copyright © 2015年 周鹏翔. All rights reserved.
//

#import "ThirdPartyKit.h"
#import "QQFactory.h"
@interface QQFactory : ThirdPartyKit
-(ThirdPartyApi *)ThirdPartyConnectWithAppKey:(NSString *)appKey
                                    appSecret:(NSString *)appSecret
                                  redirectUri:(NSString *)redirectUri;
@end
