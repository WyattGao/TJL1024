//
//  TrainingCampViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/30.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "TrainingCampViewController.h"

@interface TrainingCampViewController ()

@end

@implementation TrainingCampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createUI
{
    [self setNavTitle:@"训练营"];
   
    UILabel *label  = [UILabel new];
    label.text      = @"暂未开放...";
    label.font      = GL_FONT_B(23);
    label.textColor = TCOL_NORMALETEXT;
    [self addSubView:label];
    
    WS(ws);
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.centerY.equalTo(ws.view).offset(0);
    }];
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
