//
//  HelpAndFeedBackViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/27.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "HelpAndFeedBackViewController.h"
#import "HelpAndFeedBackTableView.h"
#import "FeedBackViewController.h"

@interface HelpAndFeedBackViewController ()

@property (nonatomic,strong) HelpAndFeedBackTableView *mainTV;

@property (nonatomic,strong) FeedBackViewController *feedBackVC;

@end

@implementation HelpAndFeedBackViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavHide:false];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createUI
{
    [self setNavTitle:@"帮助与反馈"];
    [self setLeftBtnImgNamed:nil];
    
    self.view.backgroundColor = TCOL_BGGRAY;
    
    [self addSubView:self.mainTV];
    
    WS(ws);
    
    [self.mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(64 + 21, 0, 0, 0));
    }];
}

- (HelpAndFeedBackTableView *)mainTV
{
    if (!_mainTV) {
        _mainTV = [HelpAndFeedBackTableView new];
        WS(ws);
        [_mainTV tableViewDidSelect:^(NSIndexPath *indexPath) {
            [ws.mainTV deselectRowAtIndexPath:indexPath animated:true];
            switch (indexPath.row) {
                case 0: /**< 用户协议 */
                    break;
                case 1: /**< 使用说明 */
                    break;
                case 2: /**< 意见反馈 */
                    [ws pushWithController:ws.feedBackVC];
                    break;
                default:
                    break;
            }
        }];
    }
    return _mainTV;
}

- (FeedBackViewController *)feedBackVC
{
    _feedBackVC = [FeedBackViewController new];
    return _feedBackVC;
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
