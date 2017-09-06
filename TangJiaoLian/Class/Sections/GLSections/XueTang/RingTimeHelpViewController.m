//
//  RingTimeHelpViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/9/6.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "RingTimeHelpViewController.h"
#import "RingTimeHelpView.h"

@interface RingTimeHelpViewController ()

@property (nonatomic,strong) RingTimeHelpView *helpView;

@end

@implementation RingTimeHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"图示说明"];
    
    [self addSubView:self.helpView];
    
    WS(ws);
    
    [self.helpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

- (RingTimeHelpView *)helpView
{
    if (!_helpView) {
        _helpView = [RingTimeHelpView new];
    }
    return _helpView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
