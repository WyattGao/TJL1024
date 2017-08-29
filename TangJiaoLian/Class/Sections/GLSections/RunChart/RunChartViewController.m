//
//  RunChartViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/22.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "RunChartViewController.h"
#import "RunChartView.h"

@interface RunChartViewController ()

@property (nonatomic,strong) RunChartView *runChartView;

@end

@implementation RunChartViewController

- (void)createUI
{
    [self setNavTitle:@"动态"];
    [self setLeftBtnImgNamed:nil];
    
    [self addSubView:self.runChartView];
    
    WS(ws);
    
    [self.runChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(ws.view);
        make.center.equalTo(ws.view);
    }];
}

- (RunChartView *)runChartView
{
    if (!_runChartView) {
        _runChartView = [RunChartView new];
    }
    return _runChartView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
