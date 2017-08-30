//
//  GLTabBarViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/14.
//  Copyright © 2017年 高临原. All rights reserved.
//

#import "GLTabBarViewController.h"
#import "GLNavigationController.h"
#import "XueTangViewController.h"
#import "FuWuViewController.h"
#import "STEncyclopediaViewController.h"
#import "JinNangViewController.h"
#import "WoViewController.h"
#import "STLogController.h"
#import "MallViewController.h"
#import "TrainingCampViewController.h"


@interface GLTabBarViewController ()

@property (nonatomic,strong) NSArray *vcArr;               /**< 存放所有ViewController */
@property (nonatomic,strong) NSArray *ncArr;               /**< 存放所有ViewController的导航栏 */
@property (nonatomic,strong) NSArray *vcTitleArr;          /**< 存放所有ViewController标题 */
@property (nonatomic,strong) NSArray *vcNorWithSelIconArr; /**< 存放所有ViewController的TabBar图标 */

@end

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
    self.tabBar.translucent = false;
    
    NSMutableArray *vcMArr = [NSMutableArray array];
    
    for (NSInteger i = 0;i < self.vcArr.count;i++) {
        GLNavigationController *vc = self.ncArr[i];
        NSString *vcTitle    = self.vcTitleArr[i];
        UIImage *vcNorIcon   = [[UIImage imageNamed:self.vcNorWithSelIconArr[0][i]]
                                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *vcSelIcon   = [[UIImage imageNamed:self.vcNorWithSelIconArr[1][i]]
                                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *item   = [[UITabBarItem alloc]initWithTitle:vcTitle image:vcNorIcon
                                                    selectedImage:vcSelIcon];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TCOL_MAIN,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        vc.tabBarItem        = item;
        
        [vcMArr addObject:vc];
    }
    
    self.viewControllers = [NSArray arrayWithArray:vcMArr];
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
    return @[[XueTangViewController new],
             [STLogController new],
             [TrainingCampViewController new],
             [MallViewController new],
             [WoViewController new]];
}

- (NSArray *)vcTitleArr
{
//    return @[@"动态血糖",@"服务",@"锦囊",@"我"];
    return @[@"动态血糖",@"指尖血",@"训练营",@"商城",@"我"];
}

- (NSArray *)vcNorWithSelIconArr
{
//    return @[@[@"动态血糖",@"服务",@"锦囊",@"我"],@[@"动态血糖-选中",@"服务-选中",@"锦囊-选中",@"我-选中"]];
    return @[@[@"动态血糖",@"指尖血",@"训练营",@"商城",@"我"],@[@"动态血糖-选中",@"指尖血-选中",@"",@"商城-选中",@"我-选中"]];
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
