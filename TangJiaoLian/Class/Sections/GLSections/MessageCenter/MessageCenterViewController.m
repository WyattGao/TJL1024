//
//  MessageCenterViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/6/1.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageCenterEmptyHintView.h"

@interface MessageCenterViewController ()

@property (nonatomic,strong) MessageCenterEmptyHintView *messageCenterView;

@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createUI
{
    [self setNavTitle:@"消息中心"];
    
    [self addSubView:self.messageCenterView];
    
    WS(ws);
    
    [self.messageCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

- (MessageCenterEmptyHintView *)messageCenterView
{
    if (!_messageCenterView) {
        _messageCenterView = [MessageCenterEmptyHintView new];
    }
    return _messageCenterView;
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
