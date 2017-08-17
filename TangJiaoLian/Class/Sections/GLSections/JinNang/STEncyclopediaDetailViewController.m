//
//  STEncyclopediaDetailViewController.m
//  SuiTangNew
//
//  Created by 高临原 on 2016/6/15.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import "STEncyclopediaDetailViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import <WebKit/WebKit.h>

@interface STEncyclopediaDetailViewController ()
<
WKNavigationDelegate,
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
GLTextViewDelegate
>
{
    NSInteger moveCount;   /**< 记录ScrollView的偏移量 */
    NSInteger moveTmpNum;  /**< 记录ScrollView变化值 */
    CGFloat   tfRectY;
}

@property (nonatomic,strong) WKWebView *webView;          /**< WebView */

@property (nonatomic,assign) NSInteger zanCount;          /**< 该文章的点赞输量 */

@property (nonatomic,assign) BOOL zanState;               /**< 该文章的点赞装态 */

@property (nonatomic,copy)   NSString *webTitle;          /**< 文章标题 */

@property (nonatomic,strong) UITableView *commentTV;      /**< 评论tableview */

@property (nonatomic,strong) UIView *commentView;         /**< 下方评论View */

@property (nonatomic,strong) GLTextView *commentTextView; /**< 下方评论输入框 */

@end

@implementation STEncyclopediaDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}

- (void)initData
{
    if (_entity.ID == nil) {
        return;
    }
    NSDictionary *postPraiseStateDic = @{
                                         FUNCNAME : @"getPraiseState",
                                         INFIELD  : @{
                                                 @"ACCOUNT" : USER_ACCOUNT,
                                                 @"TYPE"    : @"1",
                                                 @"PID"     : _entity.ID,
                                                 @"DEVICE"  : @"1"
                                                 }
                                         };
    [GL_Requst postWithParameters:postPraiseStateDic SvpShow:true success:^(GLRequest *request, id response) {
        if ([response getIntegerValue:@"Tag"]) {
            if ([[[[response objectForKey:@"Result"] objectForKey:@"OutField"] getStringValue:@"RETVAL"] isEqualToString:@"S"]) {
                self.zanState = [[[response objectForKey:@"Result"] objectForKey:@"OutField"] getIntegerValue:@"RETMSG"];
            }
        }
    } failure:^(GLRequest *request, NSError *error) {
        
    }];
    
    NSDictionary *postPraiseCountDic = @{
                                         FUNCNAME : @"getPraiseCount",
                                         INFIELD  : @{
                                                 @"DEVICE" : @"1",
                                                 @"TYPE"   : @"1",
                                                 @"PID"    : _entity.ID
                                                 }
                                         };
    [GL_Requst postWithParameters:postPraiseCountDic SvpShow:true success:^(GLRequest *request, id response) {
        if ([response getIntegerValue:@"Tag"]) {
            if ([[[[response objectForKey:@"Result"] objectForKey:@"OutField"] getStringValue:@"RETVAL"] isEqualToString:@"S"]) {
                self.zanCount = [[[response objectForKey:@"Result"] objectForKey:@"OutTable"] getIntegerValue:@"count"];
            }
        }
    } failure:^(GLRequest *request, NSError *error) {
        
    }];
    
    //获取文章收藏状态
    NSDictionary *postGetCollectStateDic = @{
                                             FUNCNAME : @"getCollectState",
                                             INFIELD  : @{
                                                     @"ACCOUNT" : USER_ACCOUNT,
                                                     @"TYPE" : @"0",
                                                     @"PID"  : _entity.ID,
                                                     @"DEVICE" : @"1"
                                                     }
                                             };
    [GL_Requst postWithParameters:postGetCollectStateDic SvpShow:true success:^(GLRequest *request, id response) {
        if (GETTAG) {
            if (GETRETVAL) {
                if ([GETRETMSG isEqualToString:@"1"]) {
                    _entity.COLLECTSTATUS = @"1";
                } else {
                    _entity.COLLECTSTATUS = @"0";
                }
                [(UIButton *)[self.navigationController.view viewWithTag:200] setSelected:[_entity.COLLECTSTATUS integerValue]];
            }
        }
    } failure:^(GLRequest *request, NSError *error) {
        
    }];
}

- (void)setZanCount:(NSInteger)zanCount
{
    _zanCount = zanCount;
    
    UIButton *zanBtn  = (UIButton *)[self.view viewWithTag:100];
    if (zanBtn) {
        [zanBtn setTitle:[NSString stringWithFormat:@" %ld",_zanCount] forState:UIControlStateNormal];
    }
}

- (void)setZanState:(BOOL)zanState
{
    _zanState = zanState;
    
    UIButton *zanBtn  = (UIButton *)[self.view viewWithTag:100];
    if (zanBtn) {
        zanBtn.selected = zanState;
    }
}

- (void)initUI
{
    _webView     = [WKWebView new];
    
    
    [self.view addSubview:_webView];
    
    _webView.navigationDelegate  = self;
    _webView.backgroundColor     = RGB(255, 255, 255);
    _webView.scrollView.delegate = self;
    
    if (_entity.URL.length >= 5) {
        if (![[_entity.URL substringToIndex:4] isEqualToString:@"http"] ) {
            _entity.URL = [NSString stringWithFormat:@"http://%@",_entity.URL];
        }
    }
    
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_entity.URL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:40.0f];
    [_webView loadRequest:requst];
        
    WS(ws);
    
    if (_viewType != FormServer) {
        [self addObserverForWebViewContentSize];
    }
    

    [self setNavTitle:_entity.TITLE];
    [self setLeftBtnImgNamed:nil];
    
    //        [self commentView]; 暂时隐藏评论按钮
    
    /*
    //收藏
    UIButton *collectButton    = [UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.tag          = 200;
    collectButton.frame        = CGRectMake(-10, 0, 15.8, 15.8);
    [collectButton setBackgroundImage:[UIImage imageNamed:@"iconfont-favorite"] forState:UIControlStateNormal];
    [collectButton setBackgroundImage:[UIImage imageNamed:@"iconfont-favorite-sel"] forState:UIControlStateSelected];
    collectButton.selected     = [_entity.COLLECTSTATUS integerValue];
    [collectButton addTarget:self action:@selector(collecBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem  = [[UIBarButtonItem alloc] initWithCustomView:collectButton];
    
    //分享
    
    UIButton *shareButton      = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame          = CGRectMake(0, 0, 15.8, 15.8);
    [shareButton setBackgroundImage:[UIImage imageNamed:@"iconfont-fenxiang (1)"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
     
    
    //医风采和轮播图不能收藏
    if ( _viewType == FormServer) {
        [self.navigationItem setRightBarButtonItems:@[shareItem]];
    } else {
        [self.navigationItem setRightBarButtonItems:@[shareItem,leftItem]];
    }
     */
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

- (UIView *)commentView
{
    if (!_commentView) {
        _commentView      = [UIView new];
        _commentTextView  = [GLTextView new];
        GLButton *sendBtn = [GLButton new];
        
        [self.view addSubview:_commentView];
        [_commentView addSubview:_commentTextView];
        [_commentView addSubview:sendBtn];
        
        _commentView.backgroundColor      = RGB(255, 255, 255);
        _commentView.hidden               = true;
        _commentView.alpha                = 0;
        
        _commentTextView.placeholder      = @"发表下对文章的评论吧";
        _commentTextView.placeholderColor = RGB(153, 153, 153);
        _commentTextView.cornerRadius     = 5;
        _commentTextView.backgroundColor  = RGB(240, 240, 244);
        _commentTextView.font             = GL_FONT(14);
        _commentTextView.glDelegate       = self;
        _commentTextView.returnKeyType    = UIReturnKeySend;
        
        [sendBtn setGraphicLayoutState:TEXTCENTER];
        [sendBtn setBackgroundColor:RGB(64, 165, 243) forState:UIControlStateNormal];
        [sendBtn setTitle:@"发表" forState:UIControlStateNormal];
        [sendBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(postAcommentClick:) forControlEvents:UIControlEventTouchUpInside];
        
        WS(ws);
        
        [_commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.view.mas_bottom);
            make.centerX.equalTo(ws.view);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.equalTo(_commentTextView).offset(14);
        }];
        
        [_commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_commentView).offset(15);
            make.centerY.equalTo(_commentView);
            make.right.equalTo(sendBtn.mas_left).offset(-12);
            make.height.mas_equalTo(35);
        }];
        
        [_commentTextView.placeholderLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_commentTextView).offset(12);
            make.left.equalTo(_commentTextView).offset(12);
        }];
        
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_commentView);
            make.width.mas_equalTo(88);
            make.right.equalTo(_commentView);
            make.centerY.equalTo(_commentView);
        }];
    }
    
    return _commentView;
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    _webTitle = webView.title;
    if (_viewType == FormServer) {
        [self setNavTitle:_webTitle];
        _entity.TITLE  = _webTitle;
        _entity.SKETCH = _webTitle;
    }
}

//启动时加载数据发生错误就会调用这个方法
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    GL_AFFAil;
}

//当一个正在提交的页面在跳转过程中出现错误时
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    GL_AFFAil;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    return;
//    GL_ALERT_1(@"网络不稳定，请稍后再试或者滑动返回上一页");
//    
//    UIButton *reloadBtn = [UIButton new];
//    [_webView addSubview:reloadBtn];
//    
//    [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
//    [reloadBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
//    [reloadBtn setBackgroundColor:RGB(255, 255, 255)];
//    [reloadBtn setCornerRadius:5];
//    [reloadBtn setBorderWidth:0.5];
//    [reloadBtn setBorderColor:[UIColor blackColor]];
//    [reloadBtn addTarget:self action:@selector(reloadClick:) forControlEvents:UIControlEventTouchUpInside];
//    reloadBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150/2, [UIScreen mainScreen].bounds.size.height/2 - 40/2, 150, 40);
////    [reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.center.equalTo(_webView);
////        make.size.mas_equalTo(CGSizeMake(150, 40));
////    }]; 
//}

- (void)reloadClick:(UIButton *)sender
{
    [_webView loadRequest:[NSURLRequest requestWithURL:GL_URL(_entity.URL)]];
    [sender removeFromSuperview];
    sender = nil;
}

- (void)addObserverForWebViewContentSize{
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
}
- (void)removeObserverForWebViewContentSize{
    [_webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}
//以下是监听结果回调事件：
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (_viewType != FormSearch) {
//        [self layoutView];
    }
}
//设置footerView的合理位置
- (void)layoutView{
    //取消监听，因为这里会调整contentSize，避免无限递归
    [self removeObserverForWebViewContentSize];
    
    CGSize contentSize = _webView.scrollView.contentSize;
    
    if (!_commentTV) {
        _commentTV       = [UITableView new];
        UIView *vi       = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40 + 26.2)];
        UILabel *readLbl = [UILabel new];
        UIButton *zanBtn = [UIButton new];
        UIView  *topLine = [UIView new];
        UILabel *tipLbl  = [UILabel new];
        
        [_webView.scrollView addSubview:_commentTV];
        [vi addSubview:readLbl];
        [vi addSubview:zanBtn];
        [vi addSubview:topLine];
        [topLine addSubview:tipLbl];
        
        vi.backgroundColor         = [UIColor whiteColor];
        vi.userInteractionEnabled  = YES;
        
        readLbl.text               = [NSString stringWithFormat:@"阅读 %@",_entity.CLICKNUM ? _entity.CLICKNUM : @""];
        readLbl.textColor          = RGB(102, 102, 102);
        readLbl.font               = GL_FONT(15);
        
        [zanBtn setTag:100];
        [zanBtn setTitle:[NSString stringWithFormat:@" %ld",_zanCount] forState:UIControlStateNormal];
        [zanBtn setSelected:_zanState];
        [zanBtn.titleLabel setFont:GL_FONT(14)];
        [zanBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        [zanBtn setImage:[UIImage imageNamed:@"icon_zaned"] forState:UIControlStateNormal];
        [zanBtn setImage:[UIImage imageNamed:@"iconzan"] forState:UIControlStateSelected];
        [zanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        topLine.backgroundColor    = RGB(243, 243, 243);
        
        //隐藏用户评论
        topLine.hidden             = true;
        
        tipLbl.text                = @"用户评论";
        tipLbl.font                = GL_FONT(12);
        tipLbl.textColor           = RGB(51, 51, 51);
        
        
        [readLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(vi).offset(5);
            make.left.equalTo(vi.mas_left).offset(GL_IP6_W_RATIO(14));
        }];
        
        [zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(readLbl.mas_right);
            make.centerY.equalTo(readLbl);
            make.right.equalTo(zanBtn.titleLabel.mas_right);
            make.height.mas_equalTo(60);
        }];
        
        [zanBtn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(zanBtn.titleLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake(12 * 1.4, 10 * 1.4));
            make.centerY.equalTo(zanBtn);
            make.left.equalTo(zanBtn).offset(14);
        }];
        
        [zanBtn.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(zanBtn);
            make.width.mas_equalTo(50);
        }];
        
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(vi).offset(40);
            make.centerX.equalTo(vi);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 26.2));
        }];
        
        [tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topLine);
            make.left.equalTo(topLine).offset(14);
        }];
    }
    
    
    _commentTV.frame                = CGRectMake(0, contentSize.height - (26.2 + 40), SCREEN_WIDTH,_commentTV.contentSize.height);
    _commentTV.height               = 26.2 + 40; //暂时隐藏评论部分
    
//    _webView.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height + _commentTV.contentSize.height);
    
    NSString *js = [NSString stringWithFormat:@"\
                    var appendDiv = document.getElementById(\"AppAppendDIV\");\
                    if (appendDiv) {\
                    appendDiv.style.height = %@+\"px\";\
                    } else {\
                    var appendDiv = document.createElement(\"div\");\
                    appendDiv.setAttribute(\"id\",\"AppAppendDIV\");\
                    appendDiv.style.width=%@+\"px\";\
                    appendDiv.style.height=%@+\"px\";\
                    document.body.appendChild(appendDiv);\
                    }\
                    ", @(_commentTV.contentSize.height), @(0), @( _commentTV.contentSize.height)];
    
    [_webView evaluateJavaScript:js completionHandler:nil];
    
    //重新监听
    [self addObserverForWebViewContentSize];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    moveCount = scrollView.contentOffset.y;
    
    if (scrollView.contentSize.height - scrollView.contentOffset.y <=  800) {
        if (_commentView.hidden) {
            _commentView.hidden = false;
            [UIView animateWithDuration:0.5f animations:^{
                _commentView.alpha = 1;
            } completion:^(BOOL finished) {
            }];
        }
    } else if (moveCount - moveTmpNum >= 20) {
        if (!_commentView.hidden && _commentView.alpha == 1) {
            [UIView animateWithDuration:0.5f animations:^{
                _commentView.alpha  = 0;
            } completion:^(BOOL finished) {
                _commentView.hidden = true;
            }];
        }
        moveTmpNum = moveCount;
    } else if (moveCount - moveTmpNum <= -10){
        if (_commentView.hidden && _commentView.alpha == 0) {
            _commentView.hidden = false;
            [UIView animateWithDuration:0.5f animations:^{
                _commentView.alpha = 1;
            } completion:^(BOOL finished) {
            }];
        }
        moveTmpNum = moveCount;
    }
}


#pragma mark - TextFieldDelegate
- (void)collecBtnClick:(UIButton *)sender
{
    if ([self isLogin]) {
        NSString *collecType = @"0";
        if ([_entity.TYPE isEqualToString:@"4"]) {
            collecType = @"2";
        }
        
        NSDictionary *postDic = @{
                                  @"FuncName" : @"collect",
                                  @"InField"  : @{
                                          @"DEVICE" : @"1",
                                          @"EVENT"  : [@(sender.selected) stringValue]
                                          },
                                  @"InTable"  : @{
                                          @"COLLECT" : @[
                                                  @{
                                                      @"ACCOUNT" : USER_ACCOUNT,
                                                      @"TYPE"    : collecType,   //0 文章 2 视频
                                                      @"PID"     : _entity.ID
                                                      }
                                                  ]
                                          }
                                  };
        [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
            if([response getIntegerValue:@"Tag"]){
                if (sender.selected) {
                    //取消收藏
                    GL_ALERT_S(@"已取消收藏");
                    _entity.COLLECTSTATUS = @"0";
                    _entity.COLLECTNUM = [@([_entity.COLLECTNUM integerValue] - 1) stringValue];
                } else {
                    //收藏
                    GL_ALERT_S(@"已收藏");
                    _entity.COLLECTSTATUS = @"1";
                    _entity.COLLECTNUM = [@([_entity.COLLECTNUM integerValue] + 1) stringValue];
                }
                
                if ([_delegate respondsToSelector:@selector(changeCollectStateWithEntity:)]) {
                    [_delegate changeCollectStateWithEntity:_entity];
                }
                
                sender.selected = !sender.selected;
            } else {
                GL_ALERT_E(@"操作失败");
            }

        } failure:^(GLRequest *request, NSError *error) {
            GL_ALERT_E(@"操作失败");
        }];
    }
}

/*
- (void)shareBtnClick:(UIButton *)sender
{
    NSString *sketch = self.entity.SKETCH;
    if (self.entity.SKETCH.length > 60) {
        sketch = [self.entity.SKETCH substringToIndex:60];
    }
    [[STUMShare share] shareWithTitle:self.entity.TITLE Text:sketch Image:self.entity.SPIC ClickUrl:self.entity.URL Target:self DataType:articleData];
}
 */

- (void)zanBtnClick:(UIButton *)sender
{
    if ([self isLogin]) {
        NSDictionary *postDic = @{
                                  FUNCNAME : @"savePraise",
                                  INFIELD  : @{
                                          @"DEVICE" : @"1",
                                          @"EVENT"  : [@(sender.selected) stringValue], //0:点赞 1:取消点赞
                                          @"ACCOUNT" : USER_ACCOUNT,
                                          @"TYPE"    : @"1",
                                          @"PID"     : _entity.ID
                                          }
                                  };
        [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
            if ([response getIntegerValue:@"Tag"] && [[[[response objectForKey:@"Result"] objectForKey:@"OutField"] getStringValue:@"RETVAL"] isEqualToString:@"S"]) {
                if (_zanState) {
                    if (!sender.selected) {
                        [sender setTitle:[NSString stringWithFormat:@" %ld",_zanCount] forState:UIControlStateNormal];
                    } else {
                        [sender setTitle:[NSString stringWithFormat:@" %ld",_zanCount - 1] forState:UIControlStateNormal];
                    }
                } else {
                    if (!sender.selected) {
                        [sender setTitle:[NSString stringWithFormat:@" %ld",_zanCount + 1] forState:UIControlStateNormal];
                    } else {
                        [sender setTitle:[NSString stringWithFormat:@" %ld",_zanCount] forState:UIControlStateNormal];
                    }
                }
                sender.selected = !sender.selected;
            }

        } failure:^(GLRequest *request, NSError *error) {
            
        }];
    }
}

- (void)navLeftBtnClick:(UIButton *)sender
{
    if (_pushType == formEncyLocal) {
//        DLog(@"%ld",[GL_USERDEFAULTS getIntegerValue:@"TabBarSelIndex"]);
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        [(STTabBarController *)self.tabBarController tabBarBtnClick:[self.tabBarController.view viewWithTag:[USERDEFAULTS getIntegerValue:@"TabBarSelIndex"]]];
    } else {
        [super navLeftBtnClick:sender];
    }
}

- (void)dealloc
{
    if (_viewType != FormServer) {
        [self removeObserverForWebViewContentSize];
    }
}

@end
