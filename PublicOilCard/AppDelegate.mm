//
//  AppDelegate.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "BasetabbarViewController.h"
#import "yindaotuViewController.h"
#import "GLLoginController.h"
#import "GLCompleteInfoController.h"
#import "LBMineCenterPayPagesViewController.h"
#import <UMSocialSinaHandler.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isdirect1"] isEqualToString:@"YES"]) {
        self.window.rootViewController = [[BasetabbarViewController alloc]init];
        
    }else{
        self.window.rootViewController = [[yindaotuViewController alloc]init];
    }

    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];

    return YES;
}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];

    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"pay"]) {
            return [WXApi handleOpenURL:url delegate:self];
        }else if ([url.host isEqualToString:@"safepay"]){
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
                if (orderState==9000) {
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"Alipaysucess" object:nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateManagerNotification" object:nil];
                    
                }else{
                    NSString *returnStr;
                    switch (orderState) {
                        case 8000:
                            returnStr=@"订单正在处理中";
                            break;
                        case 4000:
                            returnStr=@"订单支付失败";
                            break;
                        case 6001:
                            returnStr=@"订单取消";
                            break;
                        case 6002:
                            returnStr=@"网络连接出错";
                            break;
                            
                        default:
                            break;
                    }
                    
                    [MBProgressHUD showError:returnStr];
                    
                }
            }];
        }
    }
    return result;

}

/**
 *微信支付
 */
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                
                strMsg = @"支付结果：成功！";
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"wxpaysucess" object:nil];
                
                break;
            case WXErrCodeUserCancel:
                strMsg = @"支付结果：取消！";
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败"];
                break;
        }
    }
    [MBProgressHUD showError:strMsg];
}

//支持目前所有iOS系统
- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WEIXI_APPKEY appSecret:WEIXI_SECRET redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:WEIBO_APPKEY  appSecret:WEIBO_SECRET redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}
@end
