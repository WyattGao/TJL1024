//
//  GLTabBarViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/14.
//  Copyright © 2017年 高临原. All rights reserved.
//

#import "GLTabBarViewController.h"
#import "GLNavigationController.h"
#import "FuWuViewController.h"
#import "STEncyclopediaViewController.h"
#import "JinNangViewController.h"
#import "WoViewController.h"
#import "STLogController.h"
#import "MallViewController.h"
#import "TrainingCampViewController.h"
#import <YZBaseSDK/YZBaseSDK.h>
#import <YZNativeSDK/YZNativeSDK.h>

@interface GLTabBarViewController ()<UITabBarDelegate,YZNLoginDelegate,UITabBarControllerDelegate>

@property (nonatomic,strong) NSArray          *vcArr;/**< 存放所有ViewController */
@property (nonatomic,strong) NSArray          *ncArr;/**< 存放所有ViewController的导航栏 */
@property (nonatomic,strong) NSArray          *vcTitleArr;/**< 存放所有ViewController标题 */
@property (nonatomic,strong) NSArray          *vcNorWithSelIconArr;/**< 存放所有ViewController的TabBar图标 */
@property (nonatomic,strong) UITabBarItem     *yzItem;

@end

#define yzViewControllerIndex 2

@implementation GLTabBarViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpControllers];
    }
    return self;
}

//设置TabBar的控制器
- (void)setUpControllers
{
    self.delegate = self;
    
    self.tabBar.translucent = false;
    
    NSMutableArray *vcMArr = [NSMutableArray array];
    
    for (NSInteger i = 0;i < self.vcArr.count;i++) {
        GLNavigationController *nc = self.ncArr[i];
        NSString *vcTitle    = self.vcTitleArr[i];
        UIImage *vcNorIcon   = [[UIImage imageNamed:self.vcNorWithSelIconArr[0][i]]
                                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *vcSelIcon   = [[UIImage imageNamed:self.vcNorWithSelIconArr[1][i]]
                                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *item   = [[UITabBarItem alloc]initWithTitle:vcTitle image:vcNorIcon
                                                    selectedImage:vcSelIcon];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TCOL_MAIN,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        nc.tabBarItem        = item;
        [vcMArr addObject:nc];
    }
    
    self.viewControllers = [NSArray arrayWithArray:vcMArr];
    
    //监听有赞页面控制器的tabbarItem标题，防止根据页面头部标题变化
//    self.yzItem = [self.tabBar.items objectAtIndex:3];
//    [self.yzItem addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
//    [GL_NOTIC_CENTER addObserver:self selector:@selector(loginFinish) name:@"loginFinish" object:nil];
}

- (NSArray *)ncArr
{
    NSMutableArray *mNCArr = [NSMutableArray array];
    for (GLViewController *vc in self.vcArr) {
        GLNavigationController *nc = [[GLNavigationController alloc]initWithRootViewController:vc];
        [mNCArr addObject:nc];
    }
    
    return [NSArray arrayWithArray:mNCArr];
}

- (NSArray *)vcArr
{
    return @[[STLogController new],
             [TrainingCampViewController new],
             [MallViewController new],
             [WoViewController new]];
}

- (NSArray *)vcTitleArr
{
//    return @[@"动态血糖",@"服务",@"锦囊",@"我"];
//    return @[@"动态血糖",@"指尖血",@"训练营",@"商城",@"我"];
    return @[@"指尖血",@"训练营",@"商城",@"我"];
}

- (NSArray *)vcNorWithSelIconArr
{
//    return @[@[@"动态血糖",@"服务",@"锦囊",@"我"],@[@"动态血糖-选中",@"服务-选中",@"锦囊-选中",@"我-选中"]];
//    return @[@[@"动态血糖",@"指尖血",@"训练营",@"商城",@"我"],@[@"动态血糖-选中",@"指尖血-选中",@"",@"商城-选中",@"我-选中"]];
    return @[@[@"指尖血",@"训练营",@"商城",@"我"],@[@"指尖血-选中",@"",@"商城-选中",@"我-选中"]];
}

/**
 初始化有赞主页

 @return 有赞主页实例
 */
- (UIViewController *)getYZViewController
{
    UIViewController *yzViewController = [[YZNViewManager defaultManager] viewControllerForUrl:GL_URL(URL_YZMALL)];
    yzViewController.navigationController.navigationBar .barTintColor       = TCOL_NAVBAR;
    yzViewController.navigationController.navigationBar .barStyle           = UIBarStyleBlack;
    yzViewController.navigationController.navigationBar .tintColor          = [UIColor whiteColor];
    
    [YZNViewManager defaultManager].delegate = self;
    [YZNViewManager defaultManager].cartCopyRightString = @"温馨提示：\n在app中购买过的服务，请勿在微信公众号中重复购买";
    
    return yzViewController;
}

/**
 有赞登陆成功回调

 @param manager YZNViewManager
 */
- (void)receiveLoginRequestFrom:(YZNViewManager *)manager
{
    NSDictionary *dic = [GLCache readCacheDicWithName:YZToken];
    [YZSDK setToken:[dic getStringValue:@"access_token"] key:[dic getStringValue:@"cookie_key"] value:[dic getStringValue:@"cookie_value"]];
    GL_DISPATCH_MAIN_QUEUE(^{
        [[YZNViewManager defaultManager] userDidLogin:true];
    });
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"title"] && object == self.yzItem) {
//        GL_DISPATCH_MAIN_QUEUE(^{
//            if (![self.yzItem.title isEqualToString:@"商城"]) {
//                self.yzItem.title = @"商城";
//            }
//        });
//    }
//}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //即将跳转的navgationController
    GLNavigationController *laterNc = (GLNavigationController *)viewController;
    GLViewController *laterVc       = (GLViewController *)laterNc.topViewController;
    
    if ([NSStringFromClass([laterVc class]) isEqualToString:@"MallViewController"]) {
        //获取要推出商城页面的ViewController
        GLNavigationController *afterNc = (GLNavigationController *)tabBarController.selectedViewController;
        GLViewController *afterVc       = (GLViewController *)afterNc.topViewController;
        
        //获取有赞ViewController
        UIViewController *yzViewController = [self getYZViewController];
        [afterVc pushWithController:yzViewController];
        
        BOOL isHint = [GL_USERDEFAULTS boolForKey:YZISSHOPINGHINT];
        if (!isHint) {
            [JHSysAlertUtil presentAlertViewWithTitle:@"温馨提示：" message:@"在\"糖教练App\"中购买过的服务，请勿在\"糖教练微信公众号\"中重复购买" cancelTitle:@"确定" defaultTitle:@"确定且不再提示" distinct:false cancel:^{
            } confirm:^{
                [GL_USERDEFAULTS setBool:true forKey:YZISSHOPINGHINT];
            }];
        }
        
        return false;
    }
    return true;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
