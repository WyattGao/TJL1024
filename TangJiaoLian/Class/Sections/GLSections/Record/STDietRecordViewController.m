//
//  STDietRecordViewController.m
//  Diabetes
//
//  Created by 高临原 on 16/3/2.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "STDietRecordViewController.h"
#import "STDietRecordCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "STSelectDateView.h"
#import "STSelPickerView.h"

@interface STDietRecordViewController ()<STDietRecordCellDelegate,UITextViewDelegate,SelecteDateDelegate,GetSelTextDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CGFloat cell1TextHeight;
    CGFloat tfRectY;
    CGFloat cell3Height;
    NSIndexPath *selIndexPath;
}
@property (nonatomic,strong) UITableView *mainTV;
@property (nonatomic,strong) UIButton *saveBtn;

@property (nonatomic,copy) NSString *saveDate;
@property (nonatomic,strong) UIView *selDinesThePointView;


@end

@implementation STDietRecordViewController


- (void)viewDidLoad
{
    [self initData];
    [self initNav];
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
}
- (void)initData
{
    cell1TextHeight = 0;
    cell3Height     = 50;
    
    if (!_entity) {
        _entity = [DiningRecordEntity new];
        NSInteger nowHour =  [[[NSDate date] toString:@"HH"] integerValue];
        if (nowHour <= 10 && nowHour >= 4) {
            _entity.DIETTYPE = @"早餐";
        } else if (nowHour > 10 && nowHour <= 14){
            _entity.DIETTYPE = @"午餐";
        } else if (nowHour > 14 && nowHour <= 22){
            _entity.DIETTYPE = @"晚餐";
        } else {
            _entity.DIETTYPE = @"早餐";
        }
        
        _entity.DIETTIME = [[NSDate date] toString:@"yyyy-MM-dd HH:mm:ss"];
    }
}

- (void)initNav
{
    [self setNavTitle:@"饮食"];
    [self setLeftBtnImgNamed:nil];
}

- (void)initUI
{
    _mainTV  = [UITableView new];
    
    UIView *footView = [UIView new];
    _saveBtn = [UIButton new];
    [self addSubView:_mainTV];
    [self addSubView:footView];
    [footView addSubview:_saveBtn];
    
    self.view.backgroundColor   = TCOL_BGGRAY;
    
    _mainTV.delegate            = self;
    _mainTV.dataSource          = self;
    _mainTV.separatorStyle      = UITableViewCellSeparatorStyleNone;
    _mainTV.backgroundColor     = TCOL_BGGRAY;
    _mainTV.rowHeight           = UITableViewAutomaticDimension;
    _mainTV.showsVerticalScrollIndicator = true;
    
    footView.hidden             = _isHidSaveBtn;
    footView.backgroundColor    = RGB(246, 246, 250);
    
    _saveBtn.layer.cornerRadius = 5.0f;
    _saveBtn.clipsToBounds      = YES;
    _saveBtn.backgroundColor    = TCOL_MAIN;
    _saveBtn.titleLabel.font    = GL_FONT(15);
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    
    [_saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    if (_isHidSaveBtn) {
        _saveBtn.hidden = YES;
    }
    
    [_mainTV registerClass:[STDietRecordCell class] forCellReuseIdentifier:@"0"];
    
    WS(ws);
    [_mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view);
        make.centerX.equalTo(ws.view);
        make.width.equalTo(ws.view);
        if (_isHidSaveBtn) {
            make.height.mas_equalTo(SCREEN_HEIGHT);
        } else {
            make.height.mas_equalTo(SCREEN_HEIGHT - 85);
        }
    }];
    
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 80 + 5));
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(footView).offset(-40);
        make.centerX.equalTo(footView);
        make.size.mas_equalTo(CGSizeMake(300, 40));
    }];
}

- (void)setEntity:(DiningRecordEntity *)entity
{
    _entity = entity;
    if (entity.DIETPIC.count>0) {
        NSMutableArray * dataArray = [NSMutableArray arrayWithCapacity:0];
        [entity.DIETPIC enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *data = [NSData dataWithContentsOfURL:GL_URL(obj)];
            if (!data) {
                UIImage *img = [UIImage imageNamed:@"图片占位"];
                data = UIImageJPEGRepresentation(img, 1.0);
            }
            NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [dataArray addObject:encodedImageStr];
        }];
        
        [self addObj:dataArray WithKey:@"DIETPIC"];
        //        _entity.DIETPIC = dataArray;
    }
    [_mainTV reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            case 0: return cell1TextHeight + [tableView fd_heightForCellWithIdentifier:@"0" configuration:^(id cell) {}];break;
            case 1: return 115 + 8; break;
            case 3: return cell3Height; break;
        default:return 50;break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *mark         = [@(indexPath.row) stringValue];
    STDietRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (!cell) {
        cell = [[STDietRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
        if (_isHidSaveBtn) {
            if (indexPath.row != 1) {
                cell.userInteractionEnabled = NO;
            }
        }
    }
    
    cell.isNotEdit = _isHidSaveBtn;
    
    if (!cell.delegate) {
        cell.delegate = self;
    }
    if (!cell.entity) {
        cell.entity   = _entity;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    selIndexPath = indexPath;
    switch (indexPath.row) {
            case 2:
        {
            
            STSelectDateView *selDateView = [[STSelectDateView alloc]initWithType:DateTime];
            [GL_KEYWINDOW addSubview:selDateView];
            selDateView.delegate = self;
            
            [selDateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(GL_KEYWINDOW);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
            }];
        }
            break;
            case 3:
        {
            //弹出用餐点选择
            [self crateSelDinesThePoint];
            
            //            STSelPickerView *pickerView = [[STSelPickerView alloc]initWithTextArr:@[@"早餐",@"午餐",@"晚餐",@"其它"]];
            //            pickerView.tag = 100;
            //            pickerView.delegate = self;
            //            [pickerView show];
        }
            break;
            case 4:
        {
            NSMutableArray *tmpArr = [NSMutableArray new];
            for (NSInteger i = 0;i < 24;i++) {
                [tmpArr addObject:[NSString stringWithFormat:@"%ld分钟",5 * (i + 1)]];
            }
            STSelPickerView *pickerView = [[STSelPickerView alloc]initWithTextArr:tmpArr];
            pickerView.tag = 101;
            pickerView.delegate = self;
            [pickerView show];
        }
            
        default:
            break;
    }
}

#pragma mark - DietRecordCellDelegate
- (void)reloadTextViewForCellWithHeight:(CGFloat)height
{
    cell1TextHeight = height;
}

#pragma mark - SELDateDelegate
- (void)getSelecteDataWithDate:(NSDate *)date
{
    STDietRecordCell *cell = [_mainTV cellForRowAtIndexPath:selIndexPath];
    cell.rightLbl.text  =  [date toString:@"aakk:mm yyyy-MM-dd"];
    
    _entity.DIETTIME = [date toString:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark - getSelLabelText
- (void)getSelText:(STSelPickerView *)picker
{
    STDietRecordCell *cell = [_mainTV cellForRowAtIndexPath:selIndexPath];
    cell.rightLbl.text     = picker.myLbl.text;
    _entity.DURATIONTIME   = [picker.myLbl.text substringToIndex:picker.myLbl.text.length - 2];
    DLog(@"%@",_entity.DURATIONTIME);
}

#pragma mark - KeyBoard
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (_isHidSaveBtn) {
        textView.editable = NO;
        return NO;
    }
    CGRect rect = [textView convertRect:textView.bounds toView:GL_KEYWINDOW];
    tfRectY     = rect.origin.y + rect.size.height + 10;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _entity.DIETSITUATION = textView.text;
}

#if 0
- (void)textViewDidChange:(UITextView *)textView
{
    if (self.keyBoradHeight > 0) {
        CGRect rect = [textView convertRect:textView.bounds toView:GL_KEYWINDOW];
        tfRectY     = rect.origin.y + rect.size.height + 10;
        
        if (tfRectY  > SCREEN_HEIGHT - self.keyBoradHeight) {
            
            DLog(@"tfRecty == %lf kbsize.heght = %lf max = %lf",tfRectY,self.keyBoradHeight,(SCREEN_HEIGHT - self.keyBoradHeight) - tfRectY);
            
            WS(ws);
            
            CGFloat heightDiff = (SCREEN_HEIGHT + 64 - self.keyBoradHeight) - tfRectY;
            
            [UIView animateWithDuration:0.25f animations:^{
                ws.view.y = heightDiff;
            }];
        }
    }
}
#endif

- (BOOL)isKeyboardListener
{
    return YES;
}

- (void)keyboardWillShowHandler2:(NSDictionary *)userInfo
{
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    if (tfRectY  > SCREEN_HEIGHT - kbSize.height) {
        DLog(@"tfRecty == %lf kbsize.heght = %lf max = %lf",tfRectY,kbSize.height,(SCREEN_HEIGHT - kbSize.height) - tfRectY);
        WS(ws);
        
        CGFloat heightDiff = (SCREEN_HEIGHT + 64 - kbSize.height) - tfRectY;
        
        //        [UIView animateWithDuration:0.25f animations:^{
        //            ws.view.y = heightDiff;
        //        }];
        
        [_mainTV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:false];
        
        [UIView animateWithDuration:0.25f animations:^{
            ws.view.y = -kbSize.height+64;
        } completion:^(BOOL finished) {
        }];
        
        //延时运行
        double delayInSeconds = 1.0f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [_mainTV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:false];
        });
    }
}

- (void)keyboardWillHideHandler2:(NSDictionary *)userInfo
{
    WS(ws);
    
    [UIView animateWithDuration:0.25f animations:^{
        ws.view.y = 64;
    }];
}

- (void)saveClick
{
    if (!_entity.DIETSITUATION.length) {
        GL_ALERT_E(@"食物描述不可为空");
        return;
    }
    if (!_entity.DIETTIME.length) {
        GL_ALERT_E(@"请选择用餐时间");
        return;
    }
    if (!_entity.DIETTYPE.length) {
        GL_ALERT_E(@"请选择用餐点");
        return;
    }
    
    NSDictionary *postDic = @{
                              FUNCNAME : @"saveBloodDiet",
                              INFIELD  : @{
                                      @"DEVICE" : @"1"
                                      },
                              INTABLE  : @{
                                      @"ID"           : _entity.ID.length ? _entity.ID : @"",
                                      @"ACCOUNT"      : USER_ACCOUNT,
                                      @"DIETTIME"     :_entity.DIETTIME,
                                      @"DIETSITUATION":_entity.DIETSITUATION,
                                      @"DIETPIC"      : _entity.DIETPIC,
                                      @"DURATIONTIME" :_entity.DURATIONTIME,
                                      @"DIETTYPE"     : _entity.DIETTYPE
                                      }
                              };
    //    [AFrequest postWithDataDic:postDic andTarget:self markStr:@"saveBloodDiet"];
    
    [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
        if ([response getIntegerValue:@"Tag"]) {
            if (_entity.ID.length) {
                if ([_delegate respondsToSelector:@selector(reloadDietRVCData)]) {
                    [_delegate reloadDietRVCData];
                }
            }
            
            if (_refreshDietRecord) {
                _refreshDietRecord();
            }
            
            GL_ALERT_S(@"保存成功");
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            GL_ALERT_E(@"保存失败，请稍后再试");
        }

    } failure:^(GLRequest *request, NSError *error) {
        GL_ALERT_E(@"保存失败，请稍后再试");

    }];
}


- (void)crateSelDinesThePoint
{
    if (!_selDinesThePointView) {
        _selDinesThePointView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 80)];
        
        STDietRecordCell *cell = [_mainTV cellForRowAtIndexPath:selIndexPath];
        
        [cell.contentView addSubview:_selDinesThePointView];
        
        _selDinesThePointView.hidden = YES;
        
        _selDinesThePointView.backgroundColor = RGB(246, 246, 250);
        
        for (NSInteger i = 0;i < 6;i++) {
            UIButton *btn = [UIButton new];
            [_selDinesThePointView addSubview:btn];
            
            btn.layer.cornerRadius = 5;
            btn.tag = i + 500;
            [btn addTarget:self action:@selector(selDinesClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@[@"早餐",@"早餐加餐",@"午餐",@"午餐加餐",@"晚餐",@"晚餐加餐"][i] forState:UIControlStateNormal];
            [btn setTitleColor:RGB(155, 155, 155) forState:UIControlStateNormal];
            [btn setTitleColor:RGB(255, 255, 255) forState:UIControlStateSelected];
            [btn setBackgroundColor:RGB(255, 255, 255)];
            [btn.titleLabel setFont:GL_FONT(15)];
            if ([btn.titleLabel.text isEqualToString:cell.rightLbl.text]) {
                [self selDinesClick:btn];
            }
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(70, 30));
                if (i < 3) {
                    make.top.mas_equalTo(10);
                } else {
                    make.top.mas_equalTo(10 + 30 + 10);
                }
                
                if (i == 0 || i == 3) {
                    make.left.mas_equalTo(30);
                }
                if (i == 1 || i == 4) {
                    make.centerX.mas_equalTo(cell.contentView);
                }
                if (i == 2 || i == 5) {
                    make.right.mas_equalTo(- 30);
                }
            }];
        }
    }
    
    if (_selDinesThePointView.hidden) {
        cell3Height = 80 + 50;
    } else {
        cell3Height = 50;
    }
    
    [_mainTV beginUpdates];
    [_mainTV endUpdates];
    _selDinesThePointView.hidden = !_selDinesThePointView.hidden;
}

- (void)selDinesClick:(UIButton *)sender
{
    if (!sender.selected) {
        for (NSInteger i = 0;i < 6;i++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:500 + i];
            btn.selected = NO;
            [btn setBackgroundColor:RGB(255, 255, 255)];
        }
        sender.selected = YES;
        [sender setBackgroundColor:TCOL_MAIN];
        
        STDietRecordCell *cell = [_mainTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell.rightLbl.text = sender.titleLabel.text;
        _entity.DIETTYPE = sender.titleLabel.text;
    }
}

- (void)addObj:(id)obj WithKey:(NSString *)key
{
    [_entity setValue:obj forKey:key];
}



@end
