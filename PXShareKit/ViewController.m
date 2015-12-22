//
//  ViewController.m
//  PXShareKit
//
//  Created by 周鹏翔 on 15/12/18.
//  Copyright © 2015年 周鹏翔. All rights reserved.
//

#import "ViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "ThirdPartyKit.h"
#import "QQFactory.h"
#import "ThirdPartyApi.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import "TencentOpenAPI/QQApiInterface.h"




@interface ViewController ()<WDAuthDelegate,WDShareSDKDelegate>{
    
    ThirdPartyApi * api;
}
@property(nonatomic,strong)TencentOAuth * oauth;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

        UIButton * butt=[[UIButton alloc]initWithFrame:CGRectMake(50, 100, 80, 80)];
        [butt setBackgroundColor:[UIColor redColor]];
        [butt setTitle:@"登录" forState:UIControlStateNormal];
        [butt addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:butt];
    
    
        UIButton * butt1=[[UIButton alloc]initWithFrame:CGRectMake(50, 200, 80, 80)];
        [butt1 setBackgroundColor:[UIColor redColor]];
        [butt1 setTitle:@"分享" forState:UIControlStateNormal];
        [butt1 addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:butt1];
    
}

-(void)shareClick{
    
    
    ShareContent *shareContent = [[ShareContent alloc] initWitContent:@"视频描述" title:@"视频标题" image:nil url:@"http://baidu.com"];
    [api ShareContentInfo:shareContent To:ShareFirends delegate:self];
    
}

#pragma  mark -  代理回调出来
-(void)WDLoginResponse:(LoginType)socialType WithInfo:(NSDictionary *)userInfo Success:(BOOL)success{
    
    
    NSLog(@"1");
}
- (void) WDshareSDKResponse:(ShareType)socialType Success:(BOOL)success{
    
     NSLog(@"2");
}
-(void)click{
    
    //     [self thirdPary:@"WeiboFactory"];
           [self thirdPary:@"QQFactory"];
    //     [self thirdPary:@"WeixinFactory"];

    
    
}
-(void)thirdPary:(NSString * )Factory{
    
    Class class=NSClassFromString(Factory);
    ThirdPartyKit * kit=[class new];
    api=[kit ThirdPartyConnectWithAppKey:WeChatAppId appSecret:WeChatAppKey redirectUri:WeChatRedirectURI];
    [api registApp];
    [api login:self];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
