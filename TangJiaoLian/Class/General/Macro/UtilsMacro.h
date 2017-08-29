//
//  UtilsMacro.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief weak化self 防止循环引用造成无法释放
 */
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//=====================================================================>
//Frame
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define GL_IPHONE_4_SCREEN_WIDTH       320
#define GL_IPHONE_4_SCREEN_HEIGHT      480
#define GL_IPHONE_5_SCREEN_WIDTH       320
#define GL_IPHONE_5_SCREEN_HEIGHT      568
#define GL_IPHONE_6_SCREEN_WIDTH       375
#define GL_IPHONE_6_SCREEN_HEIGHT      667
#define GL_IPHONE_6_PLUS_SCREEN_WIDTH  414
#define GL_IPHONE_6_PLUS_SCREEN_HEIGHT 736

#define GL_IP6_W_RATIO(f)    ((f * 1.0f)/GL_IPHONE_6_SCREEN_WIDTH*SCREEN_WIDTH)
#define GL_IP6_H_RATIO(f)   ((f * 1.0f)/GL_IPHONE_6_SCREEN_HEIGHT*SCREEN_HEIGHT)

#define GL_KEYWINDOW    [[UIApplication sharedApplication] keyWindow]

#define GL_TABBARHEIGHT 49
#define GL_NAVBARHEIGHT 44
#define GL_STATUESBARHEIGHT 20
#define GL_NAVSTATUESABARHEIGHT 64


//=====================================================================>
//StyleTool
/**
 * @brief 获取一个RBGA颜色值
 */
#define RGBA(r,g,b,a) [UIColor colorWithRed:r / 255.0f green: g / 255.0f blue:b / 255.0f alpha:a]
#define RGB(r,g,b)    RGBA(r,g,b,1)

/**
 * @brief 获取一个16进制颜色值
 */
#define CHEXA(v,a) [UIColor colorWithRed:((Byte)(v >> 16))/255.0 green:((Byte)(v >> 8))/255.0 blue:((Byte)v)/255.0 alpha:a]
#define CHEX(v)    CHEXA(v,1)

/**
 * @brief 像素转PT
 */
#define XT(v) ((v * 1.0f) / 2)


//Font
#define GL_FONT_BY_NAME(n, s) [UIFont fontWithName:[NSString stringWithFormat:@"%@",n] size:(s)]
#define GL_FONT_B(s)          [UIFont boldSystemFontOfSize:s]
#define GL_FONT(s)            [UIFont systemFontOfSize:s]


//================================
//imageName
#define GL_IMAGE(s)           [UIImage imageNamed:s]
#define AddImage(s)           [UIImage imageNamed:s]

//================================
//UrlWIthStr
#define GL_URL(s)             [NSURL URLWithString:s]

//=====================================================================>
//UIAlert
#define GL_ALERTCONTR(TITLE,MESSAGE) UIAlertController *alertController = [UIAlertController alertControllerWithTitle:TITLE message:MESSAGE preferredStyle:UIAlertControllerStyleAlert];\
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:nil]];\
    [self presentViewController:alertController animated:YES completion:nil];

#define GL_ALERTFORVIEW(TITLE,MESSAGE) UIAlertController *alertController = [UIAlertController alertControllerWithTitle:TITLE message:MESSAGE preferredStyle:UIAlertControllerStyleAlert];\
[alertController addAction:[UIAlertAction actionWithTitle:@"确定"  style:UIAlertActionStyleDefault handler:nil]];\
[[self getFormViewController] presentViewController:alertController animated:YES completion:nil];


#define GL_ALERTCONTR_1(MESSAGE) GL_ALERTCONTR(nil,MESSAGE)
#define GL_ALERTFORVIEW_1(MESSAGE) GL_ALERTFORVIEW(nil,MESSAGE)

#define GL_ALERT(Title, Message, Tag, LeftButton, ...)                                             \
{                                                                                                  \
UIAlertView * view = [[UIAlertView alloc] initWithTitle:Title                                  \
message:Message                                \
delegate:self                                   \
cancelButtonTitle:LeftButton                             \
otherButtonTitles:__VA_ARGS__, nil];                     \
[view setTag:Tag];                                                                             \
[view show];                                                                                   \
}

#define GL_ALERT_1(Message) GL_ALERT(nil, Message, 0, @"确定", nil)
#define GL_ALERT_2(Title, Message) GL_ALERT(Title, Message, 0, @"确定", nil)

#define GL_ALERT_AFTER(Message, after)                                                             \
{                                                                                                  \
UIAlertView * view = [[UIAlertView alloc] initWithTitle:nil                                    \
message:Message                                \
delegate:self                                   \
cancelButtonTitle:nil                                    \
otherButtonTitles:nil, nil];                             \
[view show];                                                                                   \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
[view dismissWithClickedButtonIndex:0 animated:YES];                                       \
});                                                                                            \
}

#define GL_ALERT_S(Message)  \
{\
[SVProgressHUD setMinimumDismissTimeInterval:1.5f];\
[SVProgressHUD showSuccessWithStatus:Message];\
}

#define GL_ALERT_E(Message)  \
{\
[SVProgressHUD setMinimumDismissTimeInterval:1.5f];\
[SVProgressHUD showErrorWithStatus:Message];\
}

//网络请求 －－－  服务器异常
#define GL_AFFAil GL_ALERT_E(@"请求超时，请检查网络")

//=====================================================================>
//singleton
#define GL_APPLICATION [UIApplication sharedApplication]
#define GL_USERDEFAULTS [NSUserDefaults standardUserDefaults]

//=====================================================================>
//NSNotificationCenter

#define GL_NOTIC_CENTER               [NSNotificationCenter defaultCenter]
#define GL_NOTIC_CENTER_POST1(p)      [[NSNotificationCenter defaultCenter] postNotificationName:p object:nil];
#define GL_NOTIC_CENTER_POST2(p, obj) [[NSNotificationCenter defaultCenter] postNotificationName:p object:obj];


//=====================================================================>
//Log
#define GL_DISLOG(Log) [GL_DisLog:Log]

//deBug
#define DLog(format, ...) do {                                               \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)

//=====================================================================>
//获取版本号
#define GL_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


//=====================================================================>         
//沙盒
#define DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//=====================================================================>
//Thread
/**
 * @brief 主线程运行block语句块
 */
CG_INLINE void runDispatchGetMainQueue(void (^block)(void)) {
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
CG_INLINE void GL_DISPATCH_MAIN_QUEUE(void (^block)(void)) {
    runDispatchGetMainQueue(block);
}

//=====================================================================>
//
#define NSEaseLocalizedString(key, comment) [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"EaseUIResource" withExtension:@"bundle"]] localizedStringForKey:(key) value:@"" table:nil]


