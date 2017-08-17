//
//  FeedBackViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/31.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "FeedBackViewController.h"
#import "FeedBackView.h"
#import "WoChangePassWordWihPhoneFinishViewController.h"

@interface FeedBackViewController ()

@property (nonatomic,strong) FeedBackView *feedBackView;

@property (nonatomic,strong) WoChangePassWordWihPhoneFinishViewController *finishVC;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createUI
{
    [self setNavTitle:@"意见反馈"];
    [self setLeftBtnImgNamed:nil];
    
    [self addSubView:self.feedBackView];
    
    WS(ws);
    
    [self.feedBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

- (FeedBackView *)feedBackView
{
    if (!_feedBackView) {
        _feedBackView = [FeedBackView new];
        WS(ws);
        _feedBackView.nextBtn.glNextBtnClick = ^{
            if (ws.feedBackView.feedBackTV.text.length) {
                NSDictionary *postDic = @{
                                          FUNCNAME : @"savefeedback",
                                          INFIELD  : @{@"DEVICE" : @"1"},
                                          INTABLE  : @{
                                                  @"FEEDBACK" : @[
                                                          @{
                                                              @"ACCOUNT" : USER_ACCOUNT,
                                                              @"CONTENT" : ws.feedBackView.feedBackTV.text,
                                                              }
                                                          ]
                                                  }
                                          };
                [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
                    if (GETTAG) {
                        if (GETRETVAL) {
                            [ws pushWithController:ws.finishVC];
                        } else {
                            GL_ALERT_E(GETRETMSG);
                        }
                    } else {
                        GL_ALERT_E(GETMESSAGE);
                    }
                } failure:^(GLRequest *request, NSError *error) {
                    GL_AFFAil;
                }];
            }
        };
    }
    return _feedBackView;
}

- (WoChangePassWordWihPhoneFinishViewController *)finishVC
{
    if (!_finishVC) {
        _finishVC = [WoChangePassWordWihPhoneFinishViewController new];
        _finishVC.type = GLFinishFeedBack;
    }
    return _finishVC;
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
