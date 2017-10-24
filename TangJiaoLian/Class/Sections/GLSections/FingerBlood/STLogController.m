//
//  STLogController.m
//  Diabetes
//
//  Created by 高临原 on 17/9/25.
//  Copyright© 2017年 高临原♬. All rights reserved.
//

#import "STLogController.h"
#import "STLogView.h"
#import "STDietRecordViewController.h"
#import "STMedicationController.h"
#import "LogDateHeaderView.h"
#import "LoginViewController.h"

#define TYPECOUNT 5

#define IntTOSting(__int__) [NSString stringWithFormat:@"%d",__int__]


@interface STLogController()
{
    int days;
    
    NSArray *BloodArr;
    
    UIScrollView *TypeScrollview;
    
    UIScrollView *BloodSugarScrollview;//血糖
    
    UILabel *yearLab;
    UILabel *monthLab;
    //时间选择器
    UIView *alertTimeView;
    UIView *alertTimeBackGroundView;
    UIPickerView *timePickerView;
    UILabel *alertTimeLab;
    int year;
    int month;
}

@property (nonatomic,strong) LogDateHeaderView *headerView;

@property (nonatomic,strong) NSDate *recordLoadDete;

@property (nonatomic,strong) SlideRuleView *slideRuleView;

@end

@implementation STLogController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(![[_recordLoadDete toString:@"dd"] isEqualToString:[[NSDate date] toString:@"dd"]]){
        [self.headerView createData];
    }
    
    _recordLoadDete = [NSDate date];
    
    self.navigationController.navigationBar.translucent = false;
}

- (void)viewDidLoad {

    WS(ws);
    
    //判断糖教练账号和有赞账号是否登陆
    if (!ISLOGIN || !YZISLOGIN) {
        LoginViewController *loginVC = [LoginViewController new];

        [self.navigationController presentViewController:loginVC animated:false completion:^{
            [super viewDidLoad];
        }];
    } else {
        [super viewDidLoad];
    }
    
    _recordLoadDete = [NSDate date];
    
    [self setNavTitle:@"指尖血（点击单元格编辑）"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bloodClick:) name:@"bloodClick" object:nil];//监测异常
    //登陆完成
    [GL_NOTIC_CENTER addObserver:self selector:@selector(loginFinish) name:@"loginFinish" object:nil];
    
    self.view.backgroundColor = RGB(241, 241, 245);

    NSDate *date = [NSDate date];
    year         = [[date toString:@"yyyy"] intValue];
    month        = [[date toString:@"MM"] intValue];
    
    
    [self setLeftBtnImgNamed:nil];
    [self setRightBtnImgNamed:@"iconfont-shuju"];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self makeTypeScrollview];
    
    [self makeTabble];
    
    //获取所有数据
    if (ISLOGIN) {
        [self getBloodRange];
    }
    
//    [self loadBloodSugar];
    
    self.reloadView.reload = ^{
        [ws loadBloodSugar];
    };
}

//登陆完成通知回调
- (void)loginFinish
{
    [self getBloodRange];
}

- (void)bloodArrHaveData
{
    if (BloodArr.count>0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - - makeTypeScrollview
- (void)makeTypeScrollview{
    
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.height;
    TypeScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-(0 + 49 + statusHeight + navBarHeight))];
    TypeScrollview.pagingEnabled = YES;
    TypeScrollview.scrollEnabled = NO;
    TypeScrollview.contentSize   = CGSizeMake(TYPECOUNT*SCREEN_WIDTH, TypeScrollview.height);
//    TypeScrollview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//        [self loadBloodSugar];
//    }];
    [self addSubView:TypeScrollview];
}

#pragma mark - - makeTabble
- (void)makeTabble{
    //血糖
    [self BloodSugarView];
}

- (void)BloodSugarView{
    //绘制表头
    [TypeScrollview addSubview:self.headerView];
    [TypeScrollview addSubview:[STLogView makeHeaderView]];
    
    WS(ws);
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(0);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 42));
    }];
    
}

- (LogDateHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [LogDateHeaderView new];
        WS(ws);
        _headerView.dateChange = ^{
            [ws loadBloodSugar];
        };
    }
    return _headerView;
}

#pragma mark - 获取血糖数据
- (void)loadBloodSugar{
    NSDictionary *dic = @{
                          @"FuncName":@"getBloodValueByMonthNew",
                          @"InField":@{
                              @"ACCOUNT":USER_ACCOUNT,	//帐号
                              @"BEGINDATE":self.headerView.leftDateBtn.lbl.text, //起始日期
                              @"ENDDATE":self.headerView.rightDateBtn.lbl.text,  //结束日期
                              @"DEVICE":@"1"
                          },
                          @"OutField":@[]
                          };
    WS(ws);
    [GL_Requst postWithParameters:dic SvpShow:true success:^(GLRequest *request, id response) {
        if (GETTAG) {
            if (GETRETVAL) {
                BloodArr = [[response[@"Result"][@"OutTable"] reverseObjectEnumerator] allObjects];
                [BloodSugarScrollview removeFromSuperview];
                BloodSugarScrollview = [STLogView makeBloodSugarScrollview:TypeScrollview andSelectYear:year andMonth:month andData:BloodArr];
                [ws bloodArrHaveData];
                [ws.reloadView setHidden:true];
            } else {
                GL_ALERT_E(GETRETMSG);
                if (!BloodArr.count) {
                    [self.reloadView setHidden:false];
                }
            }
        } else {
            GL_ALERT_E(GETMESSAGE);
            if (!BloodArr.count) {
                [ws.reloadView setHidden:false];
            }        }
    } failure:^(GLRequest *request, NSError *error) {
        GL_AFFAil;
        if (!BloodArr.count) {
            [ws.reloadView setHidden:false];
        }
    }];
}

#pragma mark - 获取血糖异常范围
- (void)getBloodRange
{
    NSDictionary *postDic = @{
                              FUNCNAME : @"selectBloodRang",
                              INFIELD  : @{
                                      @"ACCOUNT" : USER_ACCOUNT,
                                      @"TYPE" : @"1" //1:普通患者 2:妊娠患者
                                      }
                              };
    [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
        if (GETTAG) {
            if (GETRETMSG) {
                NSArray *rangArr = [[response objectForKey:@"Result"] objectForKey:@"OutTable"];
                if ([rangArr isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in rangArr) {
                        //gettimetype 1：餐前 2：餐后
                        if ([dic getIntegerValue:@"gettimetype"] == 1) {
                            [GL_USERDEFAULTS setValue:@([dic getFloatValue:@"yellowlow"]) forKey:SamFingerRangeBeforeLow];
                            [GL_USERDEFAULTS setValue:@([dic getFloatValue:@"yellowhigh"]) forKey:SamFingerRangeBeforeHigh];
                        } else {
                            [GL_USERDEFAULTS setValue:@([dic getFloatValue:@"yellowlow"]) forKey:SamFingerRangeAfterLow];
                            [GL_USERDEFAULTS setValue:@([dic getFloatValue:@"yellowhigh"]) forKey:SamFingerRangeAfterHigh];
                        }
                    }
                }
                [self loadBloodSugar];
            } else {
                [self getBloodRangeFailed];
            }
        } else {
            [self getBloodRangeFailed];
        }
    } failure:^(GLRequest *request, NSError *error) {
        [self getBloodRangeFailed];
    }];
}

//获取血糖异常范围失败设置默认值
- (void)getBloodRangeFailed
{
    [GL_USERDEFAULTS setValue:@"6.0"  forKey:SamFingerRangeBeforeLow];
    [GL_USERDEFAULTS setValue:@"7.0"  forKey:SamFingerRangeBeforeHigh];
    [GL_USERDEFAULTS setValue:@"8.0"  forKey:SamFingerRangeAfterLow];
    [GL_USERDEFAULTS setValue:@"10.0" forKey:SamFingerRangeAfterHigh];
    
    [self loadBloodSugar];
}

#pragma mark - 添加修改血糖
- (void)bloodClick:(NSNotification*)not{
    NSDictionary *dic  = [not object];
    NSDictionary *dicc = BloodArr[[dic[@"i"] intValue]][@"result"][[dic[@"j"] intValue]];
    GLButton *btn      = [dic objectForKey:@"btn"];
    
    [[BloodSugarScrollview subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj class] isEqual:[GLButton class]] && obj != btn) {
            GLButton *tmpBtn = obj;
            tmpBtn.selected  = false;
        }
    }];
    btn.selected = true;
    NSInteger  bloodSugarValue = [dicc getDoubleValue:@"VALUE"] * 10;
    [self.slideRuleView showWithCurrentValue:bloodSugarValue > 0 ? bloodSugarValue : 100];
    [self.slideRuleView getValue:^(CGFloat value) {
        
        NSString *btnStr = btn.lbl.text;
        [btn setTitle:[NSString stringWithFormat:@"%.1lf",value/10.0f]  forState:UIControlStateNormal];
        
        NSDictionary *postDic = @{
                                  FUNCNAME : @"saveBloodValue",
                                  INFIELD : @{@"DEVICE":@"1"},
                                  INTABLE : @{
                                          @"BLOOD_TEST" :@[
                                                  @{
                                                  @"ACCOUNT" : USER_ACCOUNT,
                                                  @"COUNTS" : btn.lbl.text,
                                                  @"TYPE" : [dicc getStringValue:@"TYPE"],
                                                  @"DATE" : [BloodArr[[dic[@"i"] intValue]] getStringValue:@"date"]
                                                  }
                                          ]
                                          }
                                  };
        [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
            if (GETTAG) {
                if (GETRETVAL) {
                    [btn setTitleColor:TCOL_MAIN forState:UIControlStateNormal];
                    //刷新数据，获取ID
                    [self loadBloodSugar];
                } else {
                    GL_ALERTCONTR(nil, GETRETMSG);
                    [btn setTitle:btnStr  forState:UIControlStateNormal];
                }
            } else {
                GL_ALERTCONTR(nil, GETMESSAGE);
                [btn setTitle:btnStr  forState:UIControlStateNormal];
            }
        } failure:^(GLRequest *request, NSError *error) {
            GL_AFFAil;
            [btn setTitle:btnStr  forState:UIControlStateNormal];
        }];
    }];
    
    [self.slideRuleView deleteValue:^{
        if ([dicc getStringValue:@"ID"].length) {
            NSDictionary *postDic = @{
                                      FUNCNAME : @"delSamReferGlucose",
                                      INFIELD  : @{
                                              @"ACCOUNT":USER_ACCOUNT,
                                              @"ID":[dicc getStringValue:@"ID"]
                                              }
                                      };
            [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) { 
                if (GETTAG) {
                    if (GETRETVAL) {
                        [btn setTitle:@"" forState:UIControlStateNormal];
                    } else {
                        GL_ALERTCONTR_1(GETRETMSG);
                    }
                } else {
                    GL_ALERTCONTR_1(GETMESSAGE);
                }
            } failure:^(GLRequest *request, NSError *error) {
                GL_AFFAil;
                }];
        }
    }];
}

- (SlideRuleView *)slideRuleView
{
    if (!_slideRuleView) {
        _slideRuleView = [SlideRuleView slideRuleViewWithType:GLSlideRuleViewFingerBloodType];
    }
    return _slideRuleView;
}


@end
