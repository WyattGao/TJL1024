//
//  FuWuViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "FuWuViewController.h"
#import "FuWuTableView.h"
#import "FuWuWebViewController.h"

@interface FuWuViewController ()

@property (nonatomic,strong) FuWuTableView         *mainTV;
@property (nonatomic,strong) FuWuWebViewController *webVC;
@property (nonatomic,strong) NSArray *adsArr;
//@property (nonatomic,strong) NSMutableArray *<#对象名#>

@end

@implementation FuWuViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navHide = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createUI
{
    [self.view addSubview:self.mainTV];
    
    WS(ws);
    
    [self.mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(ws.view);
        make.center.equalTo(ws.view);
    }];
}

- (void)createData
{
    WS(ws);
    
    //获取轮播图
    NSDictionary *getAdsDic = @{
                           @"FuncName":@"getAds",
                           @"InField":@{
                                   @"TYPEID":@"5",      //string 非必填项，1 app开屏 2 活动首页 3 活动详情 4场景首页 5服务轮播
                                   @"ACTIVITYID":@""      //string 非必填项，TYPEID为3时，该值必填
                                   },
                           @"OutField":@[]
                           };
    [GL_Requst postWithParameters:getAdsDic SvpShow:false success:^(GLRequest *request, id response) {
        if (GETTAG) {
            if (GETRETVAL) {
               _adsArr = [NSArray arrayWithArray:response[@"Result"][@"OutTable"]];
                NSMutableArray *picArr = [NSMutableArray array];
                [_adsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [picArr addObject:[obj getStringValue:@"Photo"]];
                }];
                
                [ws.mainTV.headerView.picReView setImageArr:picArr WithTilteArr:nil];
            }
        }
    } failure:^(GLRequest *request, NSError *error) {
        
    }];
    
    NSDictionary *getDoctorListDic = @{
                                       FUNCNAME : @"getDoctorList",
                                       INFIELD  : @{
                                               @"ACCOUNT" : USER_ACCOUNT,
                                               @"DEVICE"  : @"1",
                                               @"PAGE"    : @"1",
                                               @"PAGESIZE": @"5",
                                               }
                                       };
    [GL_Requst postWithParameters:getDoctorListDic SvpShow:true success:^(GLRequest *request, id response) {
        if (GETTAG) {
            if (GETRETVAL) {
                
            }
        }
    } failure:^(GLRequest *request, NSError *error) {
        
    }];
}

- (FuWuTableView *)mainTV
{
    if (!_mainTV) {
        _mainTV = [FuWuTableView new];
        
        //点击轮播图回调
        [_mainTV.headerView.picReView PicReClick:^(NSInteger clickIndex) {
           
        }];
        
        //点击查看全部医生回调
        _mainTV.headerView.checkAllDoc = ^{
            
        };
    }
    return _mainTV;
}
- (FuWuWebViewController *)webVC
{
    if (!_webVC) {
        _webVC = [FuWuWebViewController new];
    }
    return _webVC;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
