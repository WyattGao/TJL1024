//
//  GLViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLViewController.h"
#import "LoginViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface GLViewController ()

@end

@implementation GLViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isKeyboardListener) { //是否进行键盘事件监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(kws:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(kwh:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationController.navigationBar.translucent  = true;
    self.view.backgroundColor                            = TCOL_BG;
    self.navigationController.navigationBar.barTintColor = TCOL_NAVBAR;
    self.automaticallyAdjustsScrollViewInsets            = false;
    //修改状态栏颜色为白色
    self.navigationController.navigationBar.barStyle     = UIBarStyleBlack;

    //设置默认返回按钮
    UIBarButtonItem *item                                = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor    = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem                = item;

    [self createUI];
    [self createData];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//白色
}

- (void)createUI{}

- (void)createData{}

- (void)addSubView:(UIView *)view
{
    [self.view addSubview:view];
}

#pragma mark 添加导航
-(void)setNavTitle:(NSString *)title
{
    UILabel *lab      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-180, 44)];
    lab.text          = title;
    lab.textColor     = RGB(255, 255, 255);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font          = GL_FONT_B(17);
    self.navigationItem.titleView = lab;
}

- (void)setLeftBtnImgNamed:(NSString *)imgNamed
{
    if (!imgNamed) {
//        imgNamed = @"返回";
        
        UIBarButtonItem *item                             = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationItem.backBarButtonItem             = item;
    } else {
        UIButton *fanHuiButton                = [UIButton buttonWithType:UIButtonTypeCustom];
        fanHuiButton.frame                    = CGRectMake(0, 0, 44, 44);
        fanHuiButton.imageEdgeInsets          = UIEdgeInsetsMake(0, -40, 0, 0);
        [fanHuiButton setImage:[UIImage imageNamed:imgNamed] forState:UIControlStateNormal];
        [fanHuiButton setImage:[UIImage imageNamed:imgNamed] forState:UIControlStateHighlighted];
        [fanHuiButton addTarget:self action:@selector(navLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftItem             = [[UIBarButtonItem alloc] initWithCustomView:fanHuiButton];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}

- (void)setRightBtnImgNamed:(NSString *)imgNamed
{
   UIButton *rightBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
   rightBtn.frame                         = CGRectMake(0, 0, 44, 44);
   rightBtn.imageEdgeInsets               = UIEdgeInsetsMake(0, 20, 0, 0);

    [rightBtn setTitleColor:RGB(74, 74, 74) forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:imgNamed] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
   UIBarButtonItem *rightItem             = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
   self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setRightBtnTitle:(NSString *)title
{
    UIButton *rightBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame                         = CGRectMake(0, 0, 60, 44);
    [rightBtn setTitleColor:TCOL_BG forState:UIControlStateNormal];
    rightBtn.titleLabel.font               = [UIFont systemFontOfSize:15];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem             = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)initTemporaryNavWithTitle:(NSString *)title LeftButtonIV:(NSString *)leftButtonIV RightButtonTtile:(NSString *)rightButtonTtile
{
    UIView   *navView  = [UIView new];
    UIButton *backBtn  = [UIButton new];
    UIButton *rightBtn = [UIButton new];
    UILabel  *titleLbl = [UILabel new];
    UIView   *line     = [UIView new];
    
    [self.view addSubview:navView];
    [navView addSubview:backBtn];
    [navView addSubview:rightBtn];
    [navView addSubview:titleLbl];
    [navView addSubview:line];
    
    navView.backgroundColor = TCOL_NAVBAR;
    
    leftButtonIV = leftButtonIV ? leftButtonIV : @"返回";
    
    [backBtn setImage:[UIImage imageNamed:leftButtonIV] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismissClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [titleLbl setText:title];
    [titleLbl setFont:GL_FONT(17)];
    [titleLbl setTextColor:TCOL_NAVTITLE];
    
    [rightBtn setTitle:rightButtonTtile forState:UIControlStateNormal];
    [rightBtn setTitleColor:RGB(64, 165, 243) forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:GL_FONT(15)];
    [rightBtn addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    line.backgroundColor = RGB(243, 243, 243);
    
    WS(ws);
    
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 64));
    }];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(ws.view);
        make.centerY.equalTo(titleLbl);
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backBtn);
        make.right.mas_equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(60, 44));
    }];
    
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(33);
        make.centerX.equalTo(ws.view);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(63.5);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
    }];
}


- (void)pushWithController:(UIViewController *)controller
{
    controller.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)setNavHide:(BOOL)navHide
{
    _navHide = navHide;
    
    self.fd_prefersNavigationBarHidden = navHide;
}

- (BOOL)navigationShouldPopOnBackButton
{
    [self navLeftBtnClick:nil];
    return false;
}

- (void)navLeftBtnClick:(UIButton *)sender
{
    WS(ws);
    dispatch_async(dispatch_get_main_queue(), ^{
        [ws.navigationController popViewControllerAnimated:YES];
    });
}

- (void)navRightBtnClick:(UIButton *)sender
{

}

- (void)dismissClick:(UIButton *)sender
{
    WS(ws);
    dispatch_async(dispatch_get_main_queue(), ^{
       [ws dismissViewControllerAnimated:true completion:^{
           
       }];
    });
}

- (BOOL)isLogin
{
    if (ISLOGIN) {
        return true;
    } else {
        LoginViewController *loginVC = [LoginViewController new];
        [self presentViewController:loginVC animated:true completion:^{
            
        }];
        return false;
    }
}

- (void)kws:(NSNotification *)sender
{
    
    [self keyboardWillShowHandler:[[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size];
}

- (void)kwh:(NSNotification *)sender
{
    [self keyboardWillHideHandler:[[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size];
}

- (void)keyboardWillHideHandler:(CGSize)keyBoardSize
{
    
}

- (void)keyboardWillShowHandler:(CGSize)keyBoardSize
{
    
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
