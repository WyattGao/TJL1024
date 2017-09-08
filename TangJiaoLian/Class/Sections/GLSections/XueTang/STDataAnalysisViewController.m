//
//  STDataAnalysisViewController.m
//  Diabetes
//
//  Created by 高临原 on 16/3/21.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "STDataAnalysisViewController.h"
#import "STDataAnalysisViewCell.h"
#import "STDataAnalysisViewTriangle.h"
#import "Example2PieView.h"
#import "MyPieElement.h"
#import "PieLayer.h"
#import "UUChart.h"

@interface STDataAnalysisViewController ()<UITableViewDelegate,UITableViewDataSource,UUChartDataSource>

@property (nonatomic,strong) UITableView    *mainTV;
@property (nonatomic,strong) UIView         *tvHeader;/**< MainTV的头 */
@property (nonatomic,strong) UIScrollView   *tvHeaderSV;/**< 最上方日期滚动条 */
@property (nonatomic,strong) UILabel        *thisMothLbl;/**< 当月月份标签 */
@property (nonatomic,assign) NSInteger      thisMoth;
@property (nonatomic,assign) NSInteger      thisYear;
@property (nonatomic,strong) UILabel        *BloodWarningLbl;/**< 血糖警告值Lbl */
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *processingArr;
@property (nonatomic,copy  ) NSString       *selBtnStr;
@property (nonatomic,assign) NSInteger      dayNumForThisMoth;
@property (nonatomic,strong) Example2PieView *pieView; /**< 饼图 */
@property (nonatomic,strong) UIView *pieLegendView;  /**< 饼图图例 */
@property (nonatomic,strong) NSMutableDictionary *dataDic;

@end

@implementation STDataAnalysisViewController
{
    NSInteger count;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navHide = false;
    
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initUI];
    //    [self initData];
}

- (void)initNav
{
    [self setNavTitle:@"数据分析"];
    [self setLeftBtnImgNamed:nil];
}

- (void)initUI
{
    self.view.backgroundColor = TCOL_BG;
    
    [self addSubView:self.mainTV];
    [self addSubView:self.tvHeader];
    
    WS(ws);
    
    [self.tvHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(64);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 130));
        make.centerX.equalTo(ws.view);
    }];
    
    [self.mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tvHeader.mas_bottom);
        make.bottom.equalTo(ws.view);
        make.left.equalTo(ws.view);
        make.right.equalTo(ws.view);
    }];
}

- (void)initData
{
    if (_endTimeStr.length<1) {
        _endTimeStr = [GLTools nowDateString];
    }
    _thisYear = [[[NSDate date] toString:@"yyyy"] integerValue];
    _thisMoth = [[[NSDate date] toString:@"MM"]   integerValue];
    
    switch (_thisMoth) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:
            _dayNumForThisMoth = 31;
            break;
        case 2:
            if ((!(_thisYear%4)&&_thisYear % 100!=0)||!(_thisYear %400)) {
                _dayNumForThisMoth = 29;
            } else {
                _dayNumForThisMoth = 28;
            }
            break;
        default:
            _dayNumForThisMoth = 30;
            break;
    }
    
    _dataSource    = [NSMutableArray array];
    
    if (_startTimeStr.length == 0) {
        _startTimeStr = @"";
    }
    if (_endTimeStr.length == 0) {
        _endTimeStr = @"";
    }
    
    WS(ws);

    if (_startTimeStr.length) {
        NSDictionary *dic =@{
                             @"FuncName":@"getSamGlucose",
                             @"InField":@{
                                     @"ACCOUNT":USER_ACCOUNT,	//账号
                                     @"DEVICE":@"1",	//设备号
                                     @"BEGINTIME":_startTimeStr,	//开始时间
                                     @"ENDTIME":_endTimeStr		//结束时间
                                     }
                             };
        
        [GL_Requst postWithParameters:dic SvpShow:true success:^(GLRequest *request, id response) {
            if (GETTAG) {
                if (GETRETVAL) {
                    [_dataSource addObjectsFromArray:response[@"Result"][@"OutTable"]];
                    if (!_dataSource.count) {
                        GL_ALERT_E(@"所选择时段暂无血糖记录")
                        [ws.navigationController popViewControllerAnimated:true];
                    } else {
                        [_tvHeaderSV removeFromSuperview];
                        _tvHeaderSV = nil;
                        [_tvHeader addSubview:ws.tvHeaderSV];
                        if ([ws.view viewWithTag:30]) {
                            [ws dayBtnClick:(GLButton *)[ws.view viewWithTag:30]];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [_tvHeaderSV setContentOffset:CGPointMake(0, 0) animated:YES];
                            });
                        }
                        //获取参比血糖
                        [self getSamReferGlucose];
                    }
                }else
                {
                    GL_ALERT_E(GETMESSAGE);
                    [self.navigationController popViewControllerAnimated:true];
                }
            }else
            {
                GL_AFFAil;
                [self.navigationController popViewControllerAnimated:true];
            }
        } failure:^(GLRequest *request, NSError *error) {
            GL_AFFAil;
            [self.navigationController popViewControllerAnimated:true];
        }];
    } else {
    }
}

- (void)getSamReferGlucose{
    WS(ws);
    NSDictionary *postDic = @{
                              @"FuncName":@"getSamReferGlucose",
                              @"InField":@{
                                      @"ACCOUNT":USER_ACCOUNT,	//账号
                                      @"DEVICE":@"1",	//设备号
                                      @"BEGINTIME":self.startTimeStr,	//开始时间
                                      @"ENDTIME":self.endTimeStr,		//结束时间
                                      @"VERSION":GL_VERSION
                                      }
                              };
    [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
        if (GETTAG) {
            if (GETRETVAL) {
                NSLog(@"获取参比%@",response);
                NSArray *arr = [[response objectForKey:@"Result"] objectForKey:@"OutTable"];
                if (arr.count) {
                    for (NSDictionary *dic in arr) {
                        NSString *tmpDay   = [[[dic getStringValue:@"createdtime"] toDateDefault] toString:@"dd"];
                        NSString *tmpValue = [dic getStringValue:@"value"];
                        [ws.referenceDic setValue:@{@"collectedtime":[dic getStringValue:@"createdtime"],@"value":tmpValue} forKey:tmpDay];
                    }
                    
                    [ws.mainTV reloadData];
                }
            }
        }
    } failure:^(GLRequest *request, NSError *error) {
        
    }];
}


- (UITableView *)mainTV
{
    if (!_mainTV) {
        _mainTV                                           = [UITableView new];
        _mainTV.delegate                                  = self;
        _mainTV.dataSource                                = self;
        _mainTV.separatorStyle                            = UITableViewCellSeparatorStyleNone;
    }
    
    return _mainTV;
}

- (UIView *)tvHeader
{
    if (!_tvHeader) {
        
        UIView *line = [UIView new];
        _tvHeader    = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
        
        line.backgroundColor      = TCOL_MAIN;
        _tvHeader.backgroundColor = RGB(255, 255, 255);
        
        [_tvHeader addSubview:line];
        [_tvHeader addSubview:self.tvHeaderSV];
        [_tvHeader addSubview:self.thisMothLbl];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
            make.bottom.equalTo(_tvHeader.mas_bottom);
            make.centerX.equalTo(_tvHeader);
        }];
        
        [self.thisMothLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tvHeader.mas_left).offset(15);
            make.top.equalTo(_tvHeader).offset(8);
        }];
    }
    return _tvHeader;
}


- (UILabel *)thisMothLbl
{
    if (!_thisMothLbl) {
        _thisMothLbl = [UILabel new];
        _thisMothLbl.font = GL_FONT(18);
        _thisMothLbl.textColor = TCOL_MAIN;
        _thisMothLbl.text = [[_startTimeStr toDate:@"yyyy-MM-dd HH:mm:ss"] toString:@"yyyy年-MM月"];
    }
    
    return _thisMothLbl;
}

- (UILabel *)BloodWarningLbl
{
    if (!_BloodWarningLbl) {
        _BloodWarningLbl           = [UILabel new];
        _BloodWarningLbl.font      = GL_FONT(18);
        _BloodWarningLbl.textColor = RGB(155, 155, 155);
        _BloodWarningLbl.text      = @"血糖警告值:H11.7 L3.9";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"血糖警告值:H11.7 L3.9"];
        [str addAttribute:NSForegroundColorAttributeName value:RGB(254, 199, 199) range:NSMakeRange(6,5)];
        [str addAttribute:NSForegroundColorAttributeName value:RGB(64, 165, 243) range:NSMakeRange(11, 5)];
        [_BloodWarningLbl setAttributedText:str];
    }
    
    return _BloodWarningLbl;
}

- (UIScrollView *)tvHeaderSV
{
    if (!_tvHeaderSV) {
        
        NSMutableArray *dateArr;
        if (_dataSource && _dataSource.count) {
            dateArr = [NSMutableArray new];
            
            __block NSDate   *firstDate  = [[[_dataSource firstObject] getStringValue:@"collectedtime"] toDateDefault];
            __block NSString *lastTimeStr = [firstDate toString:@"yyyy-MM-dd"];
            [dateArr addObject:firstDate];
            [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *tmpTimeStr = [[[obj getStringValue:@"collectedtime"] toDateDefault] toString:@"yyyy-MM-dd"];
                if (![tmpTimeStr isEqualToString:lastTimeStr]) {
                    [dateArr addObject:[tmpTimeStr toDate:@"yyyy-MM-dd"]];
                }
                lastTimeStr = tmpTimeStr;
            }];
        }
        
        
        _tvHeaderSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
        
        MASViewAttribute *tmpMasRight = [MASViewAttribute new];
        
        //    _tvHeaderSV.contentSize = CGSizeMake((50 + 19.4) * dateArr.count + 13 - 6.4 + SCREEN_WIDTH - (13 + 70.5), 0);
        _tvHeaderSV.contentSize = CGSizeMake((40 + 15) * dateArr.count, 0);
        
        _tvHeaderSV.showsHorizontalScrollIndicator = NO;
        _tvHeaderSV.delegate = self;
        [_tvHeaderSV setContentOffset:CGPointMake(0, 0) animated:YES];
        
        for (NSInteger i = 0;i < dateArr.count;i++) {
            
            NSDate   *date = [dateArr objectAtIndex:i];
            NSString *btnTitle = [date toString:@"d"];
            
            GLButton *btn = [GLButton new];
            UILabel  *lbl = [UILabel new];
            
            [_tvHeaderSV addSubview:btn];
            [_tvHeaderSV addSubview:lbl];
            
            [btn setBackgroundColor:RGB(247, 247, 247) forState:UIControlStateNormal];
            [btn setBackgroundColor:TCOL_MAIN forState:UIControlStateSelected];
            [btn setCornerRadius:40/2];
            [btn setBorderWidth:1];
            [btn setBorderColor:RGB(204, 204, 204)];
            [btn setTitle:btnTitle forState:UIControlStateNormal];
            [btn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
            [btn setTitleColor:RGB(255, 255, 255) forState:UIControlStateSelected];
            [btn.titleLabel setFont:GL_FONT(24)];
            [btn addTarget:self action:@selector(dayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:30 + i];
            
            [lbl setFont:GL_FONT(10)];
            [lbl setTextColor:TCOL_NORMALETEXT];
            [lbl setTextAlignment:NSTextAlignmentCenter];
            [lbl setText:[date toWeekString]];
            [lbl setTag:300 + i];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_tvHeaderSV).offset(51);
                if (!i) {
                    make.left.mas_equalTo(15);
                } else {
                    make.left.mas_equalTo(tmpMasRight).offset(15);
                }
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
            
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(btn);
                make.top.equalTo(btn.mas_bottom).offset(8);
            }];
            
            tmpMasRight = btn.mas_right;
        }
        
    }
    return _tvHeaderSV;
}

- (void)changeTableviewData
{
    __block CGFloat bCount      = 0;
    __block CGFloat sCount      = 0;
    __block CGFloat lCount      = 0;
    count       = 0;
    __block CGFloat maxNum      = 0;/**<最高血糖*/
    __block CGFloat miniNUm     = 0;/**<最低血糖*/
    __block CGFloat allNum      = 0;
    __block CGFloat sdbgNum     = 0; /**< 血糖波动系数 */
    __block CGFloat normalCount = 0;  /**< 正常血糖数 */
    
    //2016年12月01日11:51:29
    __block CGFloat validCount  = 0;  /**< 有效的血糖数据 大于0*/
    
    
    __block CGFloat tmpMaxScope1 = 0; /**< 最大波动幅度 */
    __block CGFloat previousNum1 = 0; /**< 保存前一天的数据 */
    NSMutableArray *tmpArr      = [NSMutableArray array]; /**< 存放单天的血糖记录 */
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    _processingArr = [NSMutableArray array];
    _bloodValueArr = [NSMutableArray array];
    WS(ws);
    [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *tmpTimeStr = [[formatter dateFromString: [obj getStringValue:@"collectedtime"]] toString:@"dd"];
        CGFloat tmpValue = [obj getFloatValue:@"value"];
        
        if (tmpValue > 0) {
            if ([tmpTimeStr isEqualToString:_selBtnStr]) {
                [_bloodValueArr addObject:obj];
                ws.thisMothLbl.text = [[formatter dateFromString: [obj getStringValue:@"collectedtime"]] toString:@"YYYY年MM月"];
                [tmpArr addObject:@(tmpValue)];
                allNum += tmpValue;
                count ++;
                
                //            if (fabsf(tmpValue -  previousNum1) > tmpMaxScope1) {
                //                tmpMaxScope1 = fabsf(tmpValue -  previousNum1);
                //            }
                
                //            previousNum1 = tmpValue;
                
                if (tmpValue>0) {
                    //最大
                    CGFloat A = tmpValue;
                    maxNum = A>maxNum?A:maxNum;
                    //最小
                    CGFloat B = tmpValue;
                    
                    if (miniNUm == 0) {
                        miniNUm = B;
                    }
                    miniNUm = B>miniNUm?miniNUm:B;
                    
                    //        minNum = [[allarray[j] objectForKey:@"value"] floatValue];
                    
                    validCount ++;
                }
                if (tmpValue >= 11.1) {
                    bCount ++;
                }
                if (tmpValue >= 7.8&&tmpValue<11.1) {
                    sCount ++;
                }
                if (tmpValue <= 2.9) {
                    lCount ++;
                }
                if (tmpValue > 2.9 && tmpValue < 11.1) {
                    normalCount++;
                }
                if (maxNum == 0) {
                    maxNum = tmpValue;
                }
                if (maxNum <= tmpValue) {
                    maxNum = tmpValue;
                }
                //            if (miniNUm == 0) {
                //                miniNUm = tmpValue;
                //            }
                //            if (miniNUm >= tmpValue) {
                //                miniNUm = tmpValue;
                //            }
            }
            
            
        }
    }];
    
    float aver;
    float e=0 ;
    
    //2016年12月01日11:51:15 只计算有效的血糖数据
    aver= allNum/tmpArr.count;
    for (NSString *value in tmpArr) {
        e+=( [value floatValue] - aver)*([value floatValue]-aver);
    }
    sdbgNum = sqrt(e/tmpArr.count);
    
    if (validCount == 0) {
        [_processingArr addObject:@{@"暂无血糖数据":@""}];
    } else {
        /*
         [_processingArr addObject:@{@"高血糖占时间比(PT)(>=11.1mmoL/L)"     : [NSString stringWithFormat:@"%.0lf%%",bCount / count * 100]}];
         [_processingArr addObject:@{@"高血糖占时间比(PT)(>=7.8mmoL/L))"      : [NSString stringWithFormat:@"%.0lf%%",sCount / count * 100]}];
         [_processingArr addObject:@{@"正常血糖时间百分比(3.9-7.8)" : [NSString stringWithFormat:@"%.0lf%%",normalCount / count * 100]}];
         [_processingArr addObject:@{@"低血糖占时间比(PT)(<=3.9mmoL/L)"      : [NSString stringWithFormat:@"%.0lf%%",lCount / count * 100]}];
         [_processingArr addObject:@{@"单日平均血糖值"              : [NSString stringWithFormat:@"%.2lf",aver]}];
         [_processingArr addObject:@{@"最大血糖波动幅度(LAGE)"      : [NSString stringWithFormat:@"%.2lf",tmpMaxScope1]}];
         [_processingArr addObject:@{@"血糖波动系数(血糖平均标准差SDBG)mmoL/L"        : [NSString stringWithFormat:@"%.2lf",sdbgNum]}];
         */
        //血糖监测次数
        [_processingArr addObject:@{@"血糖监测次数":[NSString stringWithFormat:@"%lu",tmpArr.count]}];
        
        //平均血糖（MGB）
        
        [_processingArr addObject:@{@"平均血糖(MGB)mmoL/L":[NSString stringWithFormat:@"%.2lf",aver]}];
        //高血糖占时间比 >=11.1
        [_processingArr addObject:@{@"高血糖占时间比(PT)(>=11.1mmoL/L)"     : [NSString stringWithFormat:@"%.0lf%%",bCount / count * 100]}];

        //高血糖占时间比 >=7.8 && <11.1
        [_processingArr addObject:@{@"高血糖占时间比(PT)(>=7.8mmoL/L))"      : [NSString stringWithFormat:@"%.0lf%%",sCount / count * 100]}];

        //低血糖占时间比 <=3.9
        [_processingArr addObject:@{@"低血糖占时间比(PT)(<=3.9mmoL/L)"      : [NSString stringWithFormat:@"%.0lf%%",lCount / count * 100]}];

        //正常血时间占比 > 3.9 && < 11.1
        [_processingArr addObject:@{@"正常血糖时间百分比(3.9-7.8)" : [NSString stringWithFormat:@"%.0lf%%",normalCount / count * 100]}];

        //最高值
        [_processingArr addObject:@{@"最高值"    :[NSString stringWithFormat:@"%.2f",maxNum]}];

        //最低值

        [_processingArr addObject:@{@"最低值"    :[NSString stringWithFormat:@"%.2f",miniNUm]}];

        //血糖波动系数
        [_processingArr addObject:@{@"血糖波动系数(SDBG)mmoL/L"        : [NSString stringWithFormat:@"%.2lf",sdbgNum]}];
    }
    
    _dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(normalCount),@"正常血糖数",@(bCount),@"高血糖数",@(lCount),@"低血糖数",@(isnan(aver)?0:aver),@"平均血糖",@(isnan(sdbgNum)?0:sdbgNum),@"血糖波动系数",@(maxNum),@"最高血糖值",@(miniNUm),@"最低血糖值",nil];
    
    
    [_mainTV reloadData];
}

- (UIView *)pieLegendView
{
    if (!_pieLegendView) {
        _pieLegendView = [UIView new];
        
        
        
    }
    return _pieLegendView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 170;
            break;
        case 1:
            return 60;
            break;
        case 2:
            return 280;
            break;
        default:
            break;
    }
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataDic) {
        return 3;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *mark = [NSString stringWithFormat:@"%@%ld",_selBtnStr,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0:
        {
            _pieView = [[Example2PieView alloc]initWithFrame:CGRectMake(10,-20,162, 200)];
            if (SCREEN_WIDTH >= GL_IPHONE_6_SCREEN_WIDTH) {
                //                _pieView.width  = 200;
                //                _pieView.height = 200;
            }
            
            _pieView.backgroundColor = [UIColor clearColor];
            for(int i = 0; i < 3; i++){
                MyPieElement *elem = [MyPieElement pieElementWithValue:[@[[_dataDic getStringValue:@"高血糖数"],[_dataDic getStringValue:@"正常血糖数"],[_dataDic getStringValue:@"低血糖数"]][i] floatValue]color:@[TCOL_HIGHDATA,RGB(0.00, 207.00, 236.00),TCOL_LOWDATA][i]];
                elem.title = @[@"高血糖时间占比",@"正常血糖时间占比",@"低血糖时间占比"][i];
                [_pieView.layer addValues:@[elem] animated:NO];
            }
            [cell.contentView addSubview:_pieView];
            
            //mutch easier do this with array outside
            _pieView.layer.transformTitleBlock = ^(PieElement* elem){
                return [(MyPieElement*)elem title];
            };
            _pieView.layer.showTitles = ShowTitlesNever;
            
            UIView *view = [UIView new];
            view.backgroundColor = RGB(255, 255, 255);
            view.cornerRadius    = (_pieView.width - 40)/2;
            [_pieView addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(_pieView.width - 40, _pieView.width - 40));
                make.centerY.equalTo(_pieView);
                make.centerX.equalTo(_pieView).offset(-2);
            }];
            
            UILabel *numLbl  = [UILabel new];
            numLbl.text      = [@(count) stringValue];
            numLbl.font      = GL_FONT_B(30);
            numLbl.textColor = TCOL_NORMALETEXT;
            [view addSubview:numLbl];
            
            UILabel *tipLbl  = [UILabel new];
            tipLbl.text      = @"测量次数";
            tipLbl.textColor = TCOL_SUBHEADTEXT;
            tipLbl.font      = GL_FONT(14);
            [view addSubview:tipLbl];
            
            [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view).offset(15);
                make.centerX.equalTo(view);
            }];
            
            [tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(numLbl.mas_bottom).offset(5);
                make.centerX.equalTo(numLbl);
            }];
            
            //图例
            for (NSInteger i = 0;i < 3;i++) {
                UIButton *btn = [UIButton new];
                NSInteger num = [@[[_dataDic getStringValue:@"正常血糖数"],[_dataDic getStringValue:@"高血糖数"],[_dataDic getStringValue:@"低血糖数"]][i] floatValue];
                UIColor *color = @[RGB(0.00, 207.00, 236.00),TCOL_HIGHDATA,TCOL_LOWDATA][i];
                
                CGFloat percentageNum = (num*1.0f)/(count*1.0f) * 100;
                if (isnan(percentageNum)) {
                    percentageNum = 0;
                }
                [btn setTitle:[NSString stringWithFormat:@"%@%.1lf%%",@[@"正常",@"偏高",@"偏低"][i],percentageNum] forState:UIControlStateNormal];
                [btn setTitleColor:color forState:UIControlStateNormal];
                [btn setCornerRadius:5];
                [btn setBorderColor:color];
                [btn setBorderWidth:2];
                [btn.titleLabel setFont:GL_FONT(16)];
                
                UILabel *lbl  = [UILabel new];
                lbl.text      = [NSString stringWithFormat:@"%ld次",num];
                lbl.textColor = color;
                lbl.font      = GL_FONT(16);
                lbl.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:btn];
                [cell.contentView addSubview:lbl];
                
                [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.contentView.mas_right).offset(-2);
                    make.top.equalTo(_pieView).offset(40 + i * 40);
                    make.size.mas_equalTo(CGSizeMake(50, 30));
                }];
                
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(lbl);
                    make.right.equalTo(lbl.mas_left).offset(-20);
                    make.size.mas_equalTo(CGSizeMake(100, 30));
                }];
            }
        }
            break;
        case 1:
        {
            NSString *averageValueStr    = [NSString stringWithFormat:@"%.1lfmmol/L\n血糖平均值",[_dataDic getFloatValue:@"平均血糖"]];
            NSString *volatilityValueStr = [NSString stringWithFormat:@"%.2lfmmol/L\n血糖波动系数",[_dataDic getFloatValue:@"血糖波动系数"]];
            
            //平均值，波动系数提示文本改变字符颜色
            NSMutableAttributedString *averageValueMutableStr    = [NSMutableAttributedString setAllText:averageValueStr andSpcifiStr:@"血糖平均值" withColor:RGB(153,153,153) specifiStrFont:GL_FONT(14)];
            NSMutableAttributedString *volatilityValueMutableStr = [NSMutableAttributedString setAllText:volatilityValueStr andSpcifiStr:@"血糖波动系数" withColor:RGB(153, 153, 153) specifiStrFont:GL_FONT(14)];
            
            //设置行间距
            NSMutableParagraphStyle *warnParagraph = [[NSMutableParagraphStyle alloc] init];
            warnParagraph.lineSpacing = 1;
            [averageValueMutableStr addAttribute:NSParagraphStyleAttributeName value:warnParagraph range:NSMakeRange(0, averageValueMutableStr.length)];
            [volatilityValueMutableStr addAttribute:NSParagraphStyleAttributeName value:warnParagraph range:NSMakeRange(0, volatilityValueMutableStr.length)];
            
            for (NSInteger i = 0;i < 2;i++) {
                UIView *line = [UIView new];
                UILabel *lbl = [UILabel new];
                
                [cell.contentView addSubview:line];
                [cell.contentView addSubview:lbl];
                
                line.backgroundColor = TCOL_MAIN;
                
                lbl.font             = GL_FONT(17);
                lbl.textColor        = TCOL_MAIN;
                lbl.numberOfLines    = 2;
                lbl.attributedText   = @[averageValueMutableStr,volatilityValueMutableStr][i];
                lbl.textAlignment    = NSTextAlignmentCenter;
                
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (!i) {
                        make.top.equalTo(cell.contentView);
                    } else {
                        make.bottom.equalTo(cell.contentView.mas_bottom);
                    }
                    make.centerX.equalTo(cell.contentView);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
                }];
                
                [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(SCREEN_WIDTH/2);
                    make.centerY.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView).offset(SCREEN_WIDTH/2 * i);
                }];
            }
            
            UIView *vLine = [UIView new];
            [cell.contentView addSubview:vLine];
            vLine.backgroundColor = TCOL_LINE;
            [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).offset(6);
                make.bottom.equalTo(cell.contentView.mas_bottom).offset(-6);
                make.centerX.equalTo(cell.contentView);
                make.width.mas_equalTo(0.5);
            }];
        }
            break;
        case 2:
        {
            for (NSInteger i = 0;i < 2;i++) {
                UUChart *barChart = [[UUChart alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH/2, 30 + 18, SCREEN_WIDTH/2, 220 - 18) dataSource:self style:UUChartStyleBar];
                barChart.tag = 90 + i;
                [barChart showInView:cell.contentView];
                
                UILabel *titleLbl      = [UILabel new];
                [cell.contentView addSubview:titleLbl];
                titleLbl.font          = GL_FONT(14);
                titleLbl.textColor     = TCOL_SUBHEADTEXT;
                titleLbl.text          = @[@"参比血糖误差",@"最低最高值(mmol/L)"][i];
                titleLbl.textAlignment = NSTextAlignmentCenter;
                
                [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.contentView).offset(16);
                    make.left.equalTo(cell.contentView).offset(SCREEN_WIDTH/2 * i);
                    make.width.mas_equalTo(SCREEN_WIDTH/2);
                }];
            }
            
            UIView *vLine = [UIView new];
            [cell.contentView addSubview:vLine];
            vLine.backgroundColor = TCOL_LINE;
            [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).offset(30);
                make.bottom.equalTo(cell.contentView.mas_bottom).offset(-50);
                make.centerX.equalTo(cell.contentView);
                make.width.mas_equalTo(0.5);
            }];
            
        }
            break;
        default:
            break;
    }

    
    
    return cell;
}

#pragma mark - UUChartDataSource
///图案下标题
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart
{
    switch (chart.tag) {
        case 90: //参比血糖误差柱状图
            return @[@"参比血糖",@"平台血糖"];
            break;
        case 91: //最高最低值柱状图
            return @[@"最高值",@"最低值"];
            break;
        default:
            break;
    }
    return @[];
}
///数值数组
- (NSArray *)chartConfigAxisYValue:(UUChart *)chart
{
    switch (chart.tag) {
        case 90:
        {
            NSDictionary *dayLastReferceDic = [self.referenceDic objectForKey:_selBtnStr];

            if (!dayLastReferceDic) {
                return @[@[@"无"],@[@"0"]];
            }
            //取当天的最后一条参比血糖值字典
            NSString *beforeValue   = [@([GLTools getLastBloodValueForTime:[dayLastReferceDic getStringValue:@"collectedtime"] WithBloodArr:self.bloodValueArr]) stringValue];
            return @[@[[dayLastReferceDic getStringValue:@"value"]],@[beforeValue]];
        }
            break;
        case 91:
            return @[@[[NSString stringWithFormat:@"%.1lf",[_dataDic getFloatValue:@"最高血糖值"]]],@[[NSString stringWithFormat:@"%.1lf",[_dataDic getFloatValue:@"最低血糖值"]]]];
            break;
        default:
            break;
    }
    return @[];
}

//颜色数组
- (NSArray *)chartConfigColors:(UUChart *)chart
{
    return @[TCOL_HIGHDATA,TCOL_LOWDATA];
}

- (CGRange)chartRange:(UUChart *)chart
{
    UUChart *chat1 = [UUChart new];
    chat1.tag = 90;
    UUChart *chat2 = [UUChart new];
    chat2.tag = 91;
    
    NSArray *arr1 = [self chartConfigAxisYValue:chat1];
    NSArray *arr2 = [self chartConfigAxisYValue:chat2];
    
    NSArray *tmpArr = [NSArray arrayWithObjects:arr1[0][0],arr1[1][0],arr2[0][0],arr2[1][0],nil];
    
    CGFloat tmpValue = 0;
    for (NSString *valueStr in tmpArr) {
        if (tmpValue < [valueStr floatValue]) {
            tmpValue = [valueStr floatValue];
        }
    }
    
    if (tmpValue>=33) {
        tmpValue = 33 - 5;
    }
    
    //每次显示范围为最大值加5
    return CGRangeMake(tmpValue + 5, 0.0f);
}


- (void)dayBtnClick:(GLButton *)sender
{
    for (UIView *view in self.tvHeaderSV.subviews) {
        if ([view isKindOfClass:[GLButton class]]) {
            //日期按钮
            GLButton *btn   = (GLButton *)view;
            btn.selected    = false;
            btn.borderColor = RGB(204, 204, 204);
            btn.borderWidth = 1;
            
            //星期标签
            UILabel *lbl  = [UILabel new];
            lbl           = [self.view viewWithTag:300 + btn.tag - 30];
            lbl.textColor = TCOL_NORMALETEXT;
        }
    }
    
    __block UILabel *selectLbl = [UILabel new];
    [UIView animateWithDuration:0.3f animations:^{
        sender.selected     = true;
        sender.borderWidth  = 3;
        sender.borderColor  = RGB(9, 170, 129);
        selectLbl           = [self.view viewWithTag:300 + sender.tag - 30];
        selectLbl.textColor = TCOL_MAIN;
    }];
    
    _selBtnStr = sender.text;
    [self changeTableviewData];
}

- (NSMutableDictionary *)referenceDic
{
    if (!_referenceDic) {
        _referenceDic = [NSMutableDictionary dictionary];
    }
    return _referenceDic;
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
