//
//  AppDelegate.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/14.
//  Copyright © 2017年 高临原. All rights reserved.
//

#import "AppDelegate.h"
#import "GLTabBarViewController.h"
#import "MMPDeepSleepPreventer.h"
#import <YZBaseSDK/YZBaseSDk.h>
#import <YZNativeSDK/YZNativeSDK.h>

@interface AppDelegate ()<EMContactManagerDelegate,EMChatManagerDelegate>

@property (nonatomic,strong) GLTabBarViewController *tabBarVC;

@property (nonatomic,strong) NSTimer *shakeTimer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //设置RootViewController
    [self setAppOption];
    [self createRootViewController];
    
    return YES;
}

/**
 App配置信息
 */
- (void)setAppOption
{
    //对 进行成员id的录入，默认可以填写123456（必填）
    [[NSUserDefaults standardUserDefaults] setObject:@"123456" forKey:@"kSDCurrentMemberKey"];
    //注册本地推送
    [GL_APPLICATION registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    
    //配置环信
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"1194170401178411#tangjiaolian"];
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"patient_Development";
#else
    apnsCertName = @"patient_Distribution";
#endif
    options.apnsCertName = apnsCertName;
    [[EMClient sharedClient] initializeSDKWithOptions:options];

    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    //设置有赞代理
    //设置clientId
    [YZSDK setUpWithClientId:@"c6561083fc718aaa79"];
    //有赞自动注册信息
    if (YZISLOGIN) {
        NSDictionary *dic = [GLCache readCacheDicWithName:YZToken];
        if ([dic count]) {
            //清除之前的登陆信息
            [YZSDK logout];
            //设置登陆信息
            [YZSDK setToken:[dic getStringValue:@"access_token"] key:[dic getStringValue:@"cookie_key"] value:[dic getStringValue:@"cookie_value"]];
        }
    }
}

/**
 设置RootViewController
 */
- (void)createRootViewController
{
    _tabBarVC = [GLTabBarViewController new];
    self.window.rootViewController = _tabBarVC;
    [self.window makeKeyAndVisible];
}

#pragma mark - HuanXinDelegate
/*!
 *  用户A发送加用户B为好友的申请，用户B会收到这个回调
 *
 *  @param aUsername   用户名
 *  @param aMessage    附属信息
 */
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage
{
    //默认同意好友请求
    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
    if (!error) {
        NSLog(@"发送同意成功");
    }
}

/*!
 @method
 @brief 用户B设置了自动同意，用户A邀请用户B入群，SDK 内部进行同意操作之后，用户B接收到该回调
 */
- (void)didJoinedGroup:(EMGroup *)aGroup
               inviter:(NSString *)aInviter
               message:(NSString *)aMessage
{
    
}

/*!
 @method
 @brief 接收到一条及以上非cmd消息
 */
- (void)messagesDidReceive:(NSArray *)aMessages
{

}

/*!
 @method
 @brief 接收到一条及以上cmd消息
 */
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages
{
    
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //环信
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
