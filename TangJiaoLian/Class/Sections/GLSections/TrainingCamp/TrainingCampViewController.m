//
//  TrainingCampViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/30.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "TrainingCampViewController.h"
#import <WebKit/WebKit.h>

@interface TrainingCampViewController ()<WKNavigationDelegate>

@property (nonatomic,strong)  WKWebView *webView;

@property (nonatomic,strong)  UILabel *hintLbl;

@end

@implementation TrainingCampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)navRightBtnClick:(UIButton *)sender
{
    [_webView loadRequest:[NSURLRequest requestWithURL:GL_URL(@"http://xly.tangjiaolian.cn")]];
}

//WkWebViewDelegate
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    _hintLbl.hidden = false;
    [SVProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [SVProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [SVProgressHUD dismiss];
    if ([webView.title isEqualToString:@"403 Forbidden"]) {
        _hintLbl.hidden = false;
    } else {
        _hintLbl.hidden = true;
    }
}

- (void)createUI
{
    [self setNavHide:true];
    
//    [self setNavTitle:@"训练营"];
//    [self setRightBtnImgNamed:@"刷新-白"];
   
    [self addSubView:self.webView];
    [self addSubView:self.hintLbl];
    
    WS(ws);
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.centerY.equalTo(ws.view).offset(0);
        make.size.mas_equalTo(ws.view);
    }];
}

- (WKWebView *)webView
{
    if (!_webView) {
        _webView                    = [WKWebView new];
        [_webView loadRequest:[NSURLRequest requestWithURL:GL_URL(@"http://xly.tangjiaolian.cn")]];
        _webView.navigationDelegate = self;
        if (@available(iOS 11.0, *)) { //iOS11不自动调整状态栏
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _webView;
}

- (UILabel *)hintLbl
{
    if (!_hintLbl) {
        _hintLbl                 = [UILabel new];
        _hintLbl.text            = @"暂未开放...";
        _hintLbl.font            = GL_FONT_B(23);
        _hintLbl.textColor       = TCOL_NORMALETEXT;
        _hintLbl.textAlignment   = NSTextAlignmentCenter;
        _hintLbl.hidden          = true;
        _hintLbl.backgroundColor = self.view.backgroundColor;
    }
    return _hintLbl;
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
