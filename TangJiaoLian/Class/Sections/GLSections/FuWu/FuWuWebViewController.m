//
//  FuWuWebViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/31.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "FuWuWebViewController.h"

@interface FuWuWebViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation FuWuWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navHide = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setLoadUrl:(NSString *)loadUrl
{
    _loadUrl = loadUrl;
    [self.webView loadRequest:[NSURLRequest requestWithURL:GL_URL(loadUrl)]];
}

#pragma mark - WebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark - CreateUI
- (void)createUI
{
    [self addSubView:self.webView];
    
    WS(ws);
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(20);
        make.centerX.equalTo(ws.view);
        make.bottom.equalTo(ws.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [UIWebView new];
        _webView.delegate = self;
    }
    return _webView;
}


@end
