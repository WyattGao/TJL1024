//
//  XueTangTargerViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/27.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangTargerViewController.h"
#import "XueTangLiShiZhiCellTableViewCell.h"
#import "GLRecordInputPopUpView.h"
#import "SlideRuleView.h"

@interface XueTangTargerViewController ()

@property (nonatomic,strong) UIButton       *targetBtn;/**< 监测目标按钮 */
@property (nonatomic,strong) UILabel        *targetLbl;/**< 监测目标值 */
@property (nonatomic,strong) NSMutableArray *waringArr;/**< 存放预警值 */
@property (nonatomic,strong) UITableView    *mainTV;
@property (nonatomic,strong) SlideRuleView  *slideRuleView; /**< 滑尺 */

@end

@implementation XueTangTargerViewController

//目标值按钮点击事件
- (void)targetBtnClick:(GLButton *)sender
{
    WS(ws);
    if (sender == self.lowTargetBtn) {
        self.slideRuleView.title = @"最低值";
        [self.slideRuleView getValue:^(CGFloat value) {
            ws.lowTargetBtn.text = [NSString stringWithFormat:@"%.1lf",value/10.0f];
            [ws checkTheValueByTargetBtn];
        }];
    } else {
        self.slideRuleView.title = @"最高值";
        [self.slideRuleView getValue:^(CGFloat value) {
            ws.highTargetBtn.text = [NSString stringWithFormat:@"%.1lf",value/10.0f];
            [ws checkTheValueByTargetBtn];
        }];
    }
    [self.slideRuleView showWithCurrentValue:[sender.text floatValue] * 10];
}

//完成按钮点击事件
- (void)finishBtnClick:(GLButton *)sender
{
    [self saveDynamicBloodRang];
}

/**
 保存动态血糖预警范围
 */
- (void)saveDynamicBloodRang
{
    WS(ws);
    NSDictionary *postDic = @{
                              FUNCNAME : @"saveDynamicBloodRang",
                              INFIELD  : @{
                                      @"ACCOUNT" : USER_ACCOUNT,
                                      @"low" : ws.lowTargetBtn.text,
                                      @"height" : ws.highTargetBtn.text
                                      }
                              };
    [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
        if (GETTAG) {
            if (GETRETVAL) {
                [GL_USERDEFAULTS setObject:ws.lowTargetBtn.text  forKey:SamTargetLow];
                [GL_USERDEFAULTS setObject:ws.highTargetBtn.text forKey:SamTargetHeight];
                [GL_USERDEFAULTS setBool:true  forKey:SamTargetState];
                [GL_USERDEFAULTS setBool:false forKey:SAMISLOWWARNING];
                [GL_USERDEFAULTS setBool:false forKey:SAMISHIGHWARNING];
                [SVProgressHUD showSuccessWithStatus:@"监测目标保存成功"];
                //刷新主页的监控目标值
                if (ws.refreshTarget) {
                    ws.refreshTarget();
                }
                [ws popViewController];
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


//检查高低目标按钮的值是否正确
- (void)checkTheValueByTargetBtn
{
    if ([self.highTargetBtn.text floatValue] <= [self.lowTargetBtn.text floatValue]) {
        self.errorLbl.hidden    = false;
        self.finishBtn.selected = false;
    } else {
        self.errorLbl.hidden    = true;
        self.finishBtn.selected = true;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _waringArr   = [NSMutableArray array];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNowWaringData) name:@"warningPush" object:nil];
}

- (void)createUI
{
    [self setNavTitle:@"监测目标"];
    [self setLeftBtnImgNamed:nil];
    
    [self.view setBackgroundColor:TCOL_BG];
    
    [self addSubView:self.hintLbl];
    [self addSubView:self.highTargetBtn];
    [self addSubView:self.lowTargetBtn];
    [self addSubView:self.finishBtn];
    [self addSubView:self.errorLbl];
    
    WS(ws);
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(27 + 64);
        make.centerX.equalTo(ws.view);
        make.width.mas_equalTo(SCREEN_WIDTH  - 24 * 2);
    }];
    
    [self.lowTargetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(94 + 64);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    
    [self.highTargetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.lowTargetBtn.mas_bottom).offset(20);
        make.centerX.equalTo(ws.lowTargetBtn);
        make.size.equalTo(ws.lowTargetBtn);
    }];
    
    [self.finishBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.errorLbl.mas_bottom).offset(11);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 40));
    }];
    
    [self.errorLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.highTargetBtn.mas_bottom).offset(69);
        make.centerX.equalTo(ws.finishBtn);
    }];
    
    for (NSInteger i = 0;i < 4;i++) {
        UILabel *tfLbl  = [UILabel new];
        tfLbl.font      = GL_FONT(18);
        tfLbl.textColor = RGB(102, 102, 102);
        tfLbl.text      = @[@"最低值：",@"最高值：",@" mmol/L",@" mmol/L"][i];
        [self.view addSubview:tfLbl];
        
        [tfLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            switch (i) {
                case 0:
                    make.centerY.equalTo(ws.lowTargetBtn);
                    make.right.equalTo(ws.lowTargetBtn.mas_left);
                    break;
                case 1:
                    make.centerY.equalTo(ws.highTargetBtn);
                    make.right.equalTo(ws.highTargetBtn.mas_left);
                    break;
                case 2:
                    make.centerY.equalTo(ws.lowTargetBtn);
                    make.left.equalTo(ws.lowTargetBtn.mas_right);
                    break;
                case 3:
                    make.centerY.equalTo(ws.highTargetBtn);
                    make.left.equalTo(ws.highTargetBtn.mas_right);
                    break;
                default:
                    break;
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navHide = false;
    //    [self reloadNowWaringData];
}

- (UILabel *)hintLbl
{
    if (!_hintLbl) {
        _hintLbl = [UILabel new];
        _hintLbl.text          = @"请录入监测范围，动态血糖超出范围时标记为异常血糖";
        _hintLbl.font          = GL_FONT(14);
        _hintLbl.textColor     = RGB(255, 51, 0);
        _hintLbl.textAlignment = NSTextAlignmentCenter;
        _hintLbl.numberOfLines = 0;
    }
    return _hintLbl;
}

- (UILabel *)errorLbl
{
    if (!_errorLbl) {
        _errorLbl               = [UILabel new];
        _errorLbl.font          = GL_FONT(14);
        _errorLbl.textColor     = RGB(255, 51, 0);
        _errorLbl.textAlignment = NSTextAlignmentCenter;
        _errorLbl.text          = @"请输入正确的血糖范围";
        _errorLbl.hidden        = true;
    }
    return _errorLbl;
}

- (GLButton *)highTargetBtn
{
    if (!_highTargetBtn) {
        _highTargetBtn                    = [GLButton new];
        _highTargetBtn.borderWidth        = 1;
        _highTargetBtn.borderColor        = RGB(204, 204, 204);
        _highTargetBtn.cornerRadius       = 5;
        _highTargetBtn.textAlignment      = NSTextAlignmentCenter;
        _highTargetBtn.text               = [GL_USERDEFAULTS getStringValue:SamTargetHeight];
        _highTargetBtn.graphicLayoutState = TEXTCENTER;
        [_highTargetBtn addTarget:self action:@selector(targetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _highTargetBtn;
}

- (GLButton *)lowTargetBtn
{
    if (!_lowTargetBtn) {
        _lowTargetBtn                    = [GLButton new];
        _lowTargetBtn.borderWidth        = 1;
        _lowTargetBtn.borderColor        = RGB(204, 204, 204);
        _lowTargetBtn.cornerRadius       = 5;
        _lowTargetBtn.textAlignment      = NSTextAlignmentCenter;
        _lowTargetBtn.text               = [GL_USERDEFAULTS getStringValue:SamTargetLow];
        _lowTargetBtn.graphicLayoutState = TEXTCENTER;
        [_lowTargetBtn addTarget:self action:@selector(targetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lowTargetBtn;
}

- (GLNextBtn *)finishBtn
{
    if (!_finishBtn) {
        _finishBtn = [[GLNextBtn alloc]initWithType:GLFinishBtnNomalType];
        _finishBtn.selected = true;
        [_finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (SlideRuleView *)slideRuleView
{
    if (!_slideRuleView) {
        _slideRuleView = [SlideRuleView slideRuleViewWithType:GLSlideRuleViewTargetType];
    }
    return _slideRuleView;
}

//
//- (BOOL)isKeyboardListener{
//    return YES;
//}
//
//- (UITableView *)mainTV
//{
//    if (!_mainTV) {
//        _mainTV                 = [[UITableView alloc] initWithFrame:CGRectMake(0,75 + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 75)];
//        _mainTV.separatorStyle  = UITableViewCellSeparatorStyleNone;
//        _mainTV.delegate        = self;
//        _mainTV.dataSource      = self;
//        _mainTV.backgroundColor = TCOL_BG;
//    }
//    return _mainTV;
//}
//
//- (UIButton *)targetBtn
//{
//    if (!_targetBtn) {
//        _targetBtn           = [[UIButton alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, 75)];
//        UIView  *targetView  = [UIView new];
//        UILabel *tipLbl      = [UILabel new];
//        _targetLbl           = [UILabel new];
//        UIImageView *arrowIV = [UIImageView new];
//        
//        [_targetBtn addSubview:targetView];
//        [_targetBtn addSubview:tipLbl];
//        [_targetBtn addSubview:_targetLbl];
//        [_targetBtn addSubview:arrowIV];
//        
//        [_targetBtn setBackgroundColor:TCOL_BGGRAY];
//        [_targetBtn addTarget:self action:@selector(targetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [targetView setUserInteractionEnabled:false];
//        [targetView setBackgroundColor:TCOL_BG];
//        
//        [_targetLbl setText:[NSString stringWithFormat:@"%.1lf-%.1lf",[GL_USERDEFAULTS getFloatValue:SamTargetLow],[GL_USERDEFAULTS getFloatValue:SamTargetHeight]]];
//        [_targetLbl setTextColor:TCOL_MAIN];
//        [_targetLbl setFont:GL_FONT(26)];
//        
//        [tipLbl setText:@"监测目标(mmol/L)："];
//        [tipLbl setTextColor:RGB(93, 93, 93)];
//        [tipLbl setFont:GL_FONT(15)];
//        
//        [arrowIV setImage:GL_IMAGE(@"右箭头_灰色")];
//        
//        [targetView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(10);
//            make.center.equalTo(_targetBtn);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
//        }];
//        
//        [tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(17);
//            make.centerY.equalTo(_targetBtn);
//        }];
//        
//        [_targetLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-45);
//            make.centerY.equalTo(_targetBtn);
//        }];
//        
//        [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-19.2);
//            make.centerY.equalTo(_targetBtn);
//        }];
//    }
//    
//    return _targetBtn;
//}
//
//
//#pragma mark - 设置控糖目标
//- (void)targetBtnClick:(UIButton *)sender
//{
//    GL_DISPATCH_MAIN_QUEUE(^{
//        GLRecordInputPopUpView  *popView = [[GLRecordInputPopUpView alloc]initWithPopUpViewType:GLPopUpViewTarget];
//        [popView show];
//        [popView popUpViewSubmit:^(NSDictionary *dic) {
//            DLog(@"%@",dic);
//            [GL_USERDEFAULTS setObject:dic[@"low"]    forKey:SamTargetLow];
//            [GL_USERDEFAULTS setObject:dic[@"height"] forKey:SamTargetHeight];
//            [GL_USERDEFAULTS setBool:true  forKey:SamTargetState];
//            [GL_USERDEFAULTS setBool:false forKey:SAMISLOWWARNING];
//            [GL_USERDEFAULTS setBool:false forKey:SAMISHIGHWARNING];
//            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
//            [self reloadNowWaringData];
//            if (_refreshTarget) {
//                _refreshTarget();
//            }
//        }];
//
//    });    
//}
//
////刷新当前显示的预警值
//- (void)reloadNowWaringData
//{
//    [_waringArr removeAllObjects];
//    
//    _targetLbl.text = [NSString stringWithFormat:@"%.1lf-%.1lf",
//                       [GL_USERDEFAULTS getFloatValue:SamTargetLow],
//                       [GL_USERDEFAULTS getFloatValue:SamTargetHeight]];
//    
//    NSArray *allWaringArr = [GLCache readCacheArrWithName:SamTargetWarningArr];
//    [allWaringArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj getFloatValue:@"value"] <= [GL_USERDEFAULTS getFloatValue:SamTargetLow] ||
//            [obj getFloatValue:@"value"] >= [GL_USERDEFAULTS getFloatValue:SamTargetHeight]) {
//            [_waringArr addObject:obj];
//        }
//    }];
//    
//    _waringArr = [NSMutableArray arrayWithArray:[[_waringArr reverseObjectEnumerator] allObjects]];
//    [_mainTV reloadData];
//    [_mainTV.mj_header endRefreshing];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //        [STLoadingView hidenLoading:self.view];
//    });
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _waringArr.count;
//}
//
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *sectionHeader = [UIView new];
//    sectionHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
//    sectionHeader.backgroundColor = TCOL_BG;
//    NSArray *arr = @[@"时间",@"血糖值",@"电流值"];
//    for (int i=0; i<arr.count; i++) {
//        UILabel *lab      = [UILabel new];
//        [sectionHeader addSubview:lab];
//        lab.textColor     = RGB(155, 155, 155);
//        lab.font          = GL_FONT(18);
//        lab.textAlignment = NSTextAlignmentCenter;
//        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//            switch (i) {
//                case 0:make.left.equalTo(sectionHeader); break;
//                case 1:make.centerX.equalTo(sectionHeader);break;
//                case 2:make.right.equalTo(sectionHeader.mas_right);
//                default:break;
//            }
//            make.width.mas_equalTo(SCREEN_WIDTH/3);
//            make.centerY.mas_equalTo(sectionHeader.mas_centerY);
//        }];
//        lab.font = GL_FONT(15);
//        
//        lab.text = arr[i];
//    }
//    return sectionHeader;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 40;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    NSString *identifierrk = [@(indexPath.row) stringValue];
//    XueTangLiShiZhiCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierrk];
//    if (cell == nil) {
//        cell = [[XueTangLiShiZhiCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierrk];
//    }
//    NSDictionary *dic = _waringArr[indexPath.row];
//    
//    cell.timeLbl.text         = [NSString stringWithFormat:@"%@",[dic[@"collectedtime"] substringFromIndex:11]];
//    cell.bloodValueLbl.text   = [NSString stringWithFormat:@"%@mmol/L",dic[@"value"]];
//    cell.currentValueLbl.text = [NSString stringWithFormat:@"%@nA",dic[@"currentvalue"]];
//    
//    if ([dic[@"value"] floatValue]<= [GL_USERDEFAULTS getFloatValue:SamTargetLow]) {
//        cell.bloodValueLbl.textColor = TCOL_MAIN;
//    }else{
//        cell.bloodValueLbl.textColor = RGB(254, 119, 119);
//    }
//        
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
