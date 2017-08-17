//
//  STMedicationController.m
//  Diabetes
//
//  Created by 房克志 on 16/3/2.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "STMedicationController.h"
#import "STMedicationCell.h"
#import "STSelectDateView.h"
#import "STMedicineView.h"

@interface STMedicationController ()<UITextViewDelegate,SelecteDateDelegate,MedicationCellDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL isTextView;

@end

@implementation STMedicationController
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIButton *AddBtn;
    UIButton *continueBtn;
    NSInteger cellHeight;
    NSString *bzText;
    NSString *upLoadTime;
//    NSString *medicationID;
    UITextView *_textView;
    UILabel *_placeholderLabel;
    NSString * _medicineStr;/**<使用方法*/
    CGFloat tfRectY;
    NSIndexPath *selIndexPath;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatNav];
    [self creatView];
    [self setUpForDismissKeyboard];
    if (_dataDict != nil) {
        NSString *BZstr = [_dataDict getStringValue:@"REMARK"];
        bzText = BZstr;
        upLoadTime = [_dataDict getStringValue:@"MEDICATIONTIME"];
    } else {
        upLoadTime = [[NSDate date] toString:@"yyyy-MM-dd HH:mm:ss"];
        NSString *usage = _isYiDaoSu ? @"3" : @"1";
        NSDictionary *tmpDic = @{
                                 @"NAME" : @"",
                                 @"DOSE" : @"",
                                 @"USAGE": usage
                                 };
        _dataDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObject:tmpDic],@"DETAIL",@"",@"REMARK",upLoadTime,@"MEDICATIONTIME",nil];
    }

    if (!_rightBtnHidden) {
        [self setRightBtnImgNamed:@"iconfont-shujufenxi"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)creatNav
{
    [self setLeftBtnImgNamed:nil];
    if (self.isYiDaoSu) {
        [self setNavTitle:@"注射胰岛素"];
    }else{
        [self setNavTitle:@"口服药"];
    }
    if ([self.rightBtnHidden isEqualToString:@"YES"]) {
        [self setRightBtnHidden:@"iconfont-shujufenxi"];
    }
}
- (void)creatView
{
    bzText = @"";
    if (_isYiDaoSu) {
        _medicineStr = @"3";
    }else
    {
        _medicineStr = @"1";
    }
    _dataArray = [NSMutableArray new];
    _detailArray = [NSMutableArray new];
    cellHeight = 43*2+16;
    self.view.backgroundColor = TCOL_BGGRAY;
    
    _placeholderLabel = [UILabel new];
    _placeholderLabel.text = @"填写备注信息";
    _placeholderLabel.textColor = RGB(207, 206, 206);
    _placeholderLabel.font = GL_FONT(15);
    _placeholderLabel.frame = CGRectMake(10, 8, SCREEN_WIDTH-20, 20);
    _tableView = [UITableView new];
    _tableView.tableHeaderView = [self headerView];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = TCOL_BGGRAY;
    [self.view addSubview:_tableView];
    
    WS(ws);
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(8 + 64);
        make.centerX.equalTo(ws.view);
        make.bottom.equalTo(ws.view.mas_bottom).offset(-100);
        make.width.equalTo(ws.view);
    }];
    
    
    continueBtn = [UIButton new];
    continueBtn.layer.cornerRadius = 5.0f;
    continueBtn.clipsToBounds      = YES;
    [continueBtn setBackgroundColor:TCOL_MAIN];
    [continueBtn setTitle:@"保存" forState:UIControlStateNormal];

    [continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [continueBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueBtn];
    
    [continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view).offset(-40);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(300, 40));
    }];
    
    if ([self.AddBtnHidden isEqualToString:@"hidden"]) {
        continueBtn.hidden = YES;
        AddBtn.hidden = YES;
        
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.view.mas_bottom);
        }];
    }
//    _placeholderLabel
//    STMedicationCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_cellNum-2 inSection:0]];
//    if (cell.BZTextView.text.length>0) {
//        _placeholderLabel.hidden = YES;
//    }
}

- (UIView *)headerView
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43)];
    UIImageView *hederImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 22, 22)];
    [view addSubview:hederImg];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * YPXXLabel = [UILabel new];
    if (_isYiDaoSu) {
        YPXXLabel.text = @"胰岛素信息";
        hederImg.image = GL_IMAGE(@"用药-针头");
    }else
    {
        YPXXLabel.text = @"药品信息";
        hederImg.image = GL_IMAGE(@"用药-胶囊");
    }
    YPXXLabel.textColor = TCOL_MAIN;
    YPXXLabel.font      = GL_FONT(15);
    [view addSubview:YPXXLabel];
    [YPXXLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(10);
        make.left.equalTo(view).offset(43);
        make.size.mas_equalTo(CGSizeMake(150, 22));
    }];
    AddBtn = [UIButton new];
    [view addSubview:AddBtn];
    [AddBtn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [AddBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [AddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(1);
        make.right.equalTo(view).offset(-6);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [AddBtn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    //    UIButton *btn = [UIButton new];
    //    [view addSubview:btn];
    //    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(view);
    //        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 42));
    //    }];
    //    [btn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    if ( ([self.AddBtnHidden isEqualToString:@"hidden"])) {
    //        btn.userInteractionEnabled = false;
    //    }

   UILabel * lineLab1 = [UILabel new];
    lineLab1.backgroundColor = TCOL_BGGRAY;
    [view addSubview:lineLab1];
    [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(YPXXLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
//    [self creatLineView:view];
    return view;
}

- (void)creatLineView:(UIView *)view
{
    UILabel *lineLab = [UILabel new];
    lineLab.backgroundColor = TCOL_BGGRAY;
    [view addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(view);
        make.top.equalTo(view.mas_bottom).offset(-8);
        make.bottom.equalTo(view);
    }];
    
}

- (void)addBtnClick
{
    if (_cellNum==5) {
        return;
    }
//    self.dataDict = nil;
    _cellNum ++;
    
    if (_dataDict) {
        NSString *usage = _isYiDaoSu ? @"3" : @"1";
        NSDictionary *tmpDic = @{
                                 @"NAME" : @"",
                                 @"DOSE" : @"",
                                 @"USAGE": usage
                                 };
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:[_dataDict objectForKey:@"DETAIL"]];
        [tmpArr addObject:tmpDic];
        [_dataDict setObject:tmpArr forKey:@"DETAIL"];

    }
    
    [_tableView reloadData];
}

- (void)rightBtnDown:(UIButton *)btn
{
}
- (void)rightBtn:(UIButton *)btn
{
    [self.view endEditing:true];
    
    STMedicationCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_cellNum-2 inSection:0]];
    upLoadTime = [[cell1.timeLab.text toDate:@"aakk:mm yyyy-MM-dd"] toString:@"yyyy-MM-dd HH:mm:ss"];
    if (upLoadTime == nil||[upLoadTime isEqualToString:@"请选择使用时间"]) {
        GL_ALERT_1(@"请选择您的服药时间");
        return;
    }
    
    NSMutableArray *samArr = [NSMutableArray arrayWithCapacity:0];
    
    
    
    for (NSInteger i = 0; i<_cellNum-2; i++) {
     STMedicationCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell.cellLab1.text isEqualToString:@""]||[cell.textField.text isEqualToString:@""]||[cell.cellLab1.text isEqualToString:@"请添加药品名称"] ) {
            GL_ALERT_1(@"请填写完整的药品信息");
            return;
        }
        
        NSDictionary *dict;
        NSDictionary *dicc;
        if (self.isYiDaoSu) {
            _medicineStr = cell.leftBtn.selected?@"3":@"4";
            dict = @{@"NAME":cell.cellLab1.text,
                     @"DOSE":cell.textField.text,
                     @"USAGE":_medicineStr
                     };

            dicc = @{@"insulin":cell.cellLab1.text,
                     @"insulinUnit":cell.textField.text,
                     @"eventTime":[NSString stringWithFormat:@"%@:00",upLoadTime]};
        }else{
            _medicineStr = cell.leftBtn.selected?@"1":@"2";
            dict = @{@"NAME":cell.cellLab1.text,
                     @"DOSE":cell.textField.text,
                     @"USAGE":_medicineStr
                     };
            dicc = @{@"medicine":cell.cellLab1.text,
                     @"medicineUnit":cell.textField.text,
                     @"eventTime":[NSString stringWithFormat:@"%@:00",upLoadTime]};
        }
        
        
        [_detailArray addObject:dict];
        [samArr addObject:dicc];
    }
    
    
    if (_medicationID==nil) {
        _medicationID = @"";
    }
    
    NSDictionary *dict = @{
                           @"FuncName":@"saveBloodMedication",
                           @"InField":@{
                               @"DEVICE":@"1"		//0:android 1:ios
                           },
                           @"InTable":@{
                               @"ID":_medicationID,//用药id
                               @"ACCOUNT":USER_ACCOUNT,//用户账号
                               @"REMARK":bzText,//备注
                               @"MEDICATIONTIME":upLoadTime,
                               @"DURATIONTIME":@"",
                               @"DETAIL":_detailArray//用药明细
                           },
                           @"OutField":@[
                                       @"RETVAL",
                                       @"RETMSG"
                                       ]
                           };
    [GL_Requst postWithParameters:dict SvpShow:true success:^(GLRequest *request, id response) {
        if ([response[@"Tag"] isEqualToString:@"1"]) {
            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:nil message:[[response[@"Result"]objectForKey:@"OutField"] objectForKey:@"RETMSG"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 1000;
            [alertView show];
        }

    } failure:^(GLRequest *request, NSError *error) {
        GL_ALERT_E(@"数据上传失败");
    }];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    if (![text isEqualToString:@""])
    
    {
    
    _placeholderLabel.hidden = YES;
    
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        
        _placeholderLabel.hidden = NO;
        
    }
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        
//        if (_dataDict != nil) {
//        }
        
        if (_refreshBlock) {
            _refreshBlock();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellNum;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<_cellNum-2&&indexPath.row!=0&&![_AddBtnHidden isEqualToString:@"hidden"]) {
        return YES;
    }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cellNum--;
//    if (_detailArray[indexPath.row]!=nil) {
//        [_detailArray removeObjectAtIndex:[indexPath row]];  //删除_data数组里的数据
//
//    }
    
    if (_dataDict) {
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:[_dataDict objectForKey:@"DETAIL"]];
        [tmpArr removeObjectAtIndex:indexPath.row];
        [_dataDict setObject:tmpArr forKey:@"DETAIL"];
        
    }
    
    [_tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [_tableView reloadData];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row<_cellNum-2) {
        STMedicationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
        if (!cell) {
            cell = [[STMedicationCell alloc]initWithStyle1:UITableViewCellStyleDefault reuseIdentifier:@"1"];
        }
        cell.delegate = self;
        if ( ([self.AddBtnHidden isEqualToString:@"hidden"])) {
            cell.userInteractionEnabled = false;
        }
        
        if (_dataDict != nil) {
            cell.cellLab1.text      = [_dataDict[@"DETAIL"][indexPath.row] getStringValue:@"NAME"];
            cell.cellLab1.textColor = RGB(19, 19, 19);
            cell.textField.text     = [_dataDict[@"DETAIL"][indexPath.row] getStringValue:@"DOSE"];
            cell.textField.tag      = 2017 + indexPath.row;
            [cell.textField addTarget:self action:@selector(textfieldFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            NSString *str = [_dataDict[@"DETAIL"][indexPath.row] getStringValue:@"USAGE"];
            if ([str isEqualToString:@"1"]||[str isEqualToString:@"3"]) {
                cell.leftBtn.selected  = true;
                cell.rightBtn.selected = false;
            }else
            {
                cell.rightBtn.selected = true;
                cell.leftBtn.selected  = false;
            }
        } else {
//            cell.cellLab1.text      = @"";
//            cell.cellLab1.textColor = RGB(207, 206, 206);
//            cell.textField.text     = @"";
//            cell.textField.placeholder = @"如3";
//            cell.leftBtn.selected   = true;
//            cell.rightBtn.selected  = false;
//            if (_isYiDaoSu) {
//                _medicineStr = @"3";
//            }else
//            {
//                _medicineStr = @"1";
//            }
        }
//        cell.addBlock = ^(NSInteger indexNum){
//            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//            _cellNum+=2;
//            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//        };
        cell.segmentBlock = ^(NSString *medicineUse)
        {
            _medicineStr = medicineUse;
            
            if (_dataDict) {
                NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:[_dataDict objectForKey:@"DETAIL"]];
                NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:[tmpArr objectAtIndex:indexPath.row]];
                [tmpDic setObject:medicineUse forKey:@"USAGE"];
                [tmpArr replaceObjectAtIndex:indexPath.row withObject:tmpDic];
                [_dataDict setObject:tmpArr forKey:@"DETAIL"];
            }
        };
        
        if (_dataDict) {
            cell.medicBlock = ^(NSDictionary *dict){
                NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:[_dataDict objectForKey:@"DETAIL"]];
                NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:[tmpArr objectAtIndex:indexPath.row]];
                [tmpDic setObject:[dict getStringValue:@"name"] forKey:@"NAME"];
                [tmpArr replaceObjectAtIndex:indexPath.row withObject:tmpDic];
                [_dataDict setObject:tmpArr forKey:@"DETAIL"];
            };
        }
        
        return cell;
    }else if (indexPath.row == _cellNum-1)
    {
        STMedicationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"2"];
        if (!cell) {
            cell = [[STMedicationCell alloc]initWithStyle1:UITableViewCellStyleDefault reuseIdentifier:@"2"];
        }
        
        if ( ([self.AddBtnHidden isEqualToString:@"hidden"])) {
            cell.userInteractionEnabled = false;
        }
        
        [cell.BZTextView addSubview:_placeholderLabel];
        cell.BZTextView.delegate = self;
        if (_dataDict != nil) {
            _placeholderLabel.hidden = YES;
            NSString *BZstr = [_dataDict getStringValue:@"REMARK"];
            cell.BZTextView.text = BZstr;
            CGFloat tvHeight = [self heightForString:BZstr fontSize:15 andWidth:SCREEN_WIDTH - 15];
            
            if (tvHeight > 42) {
                if (cell.BZTextView.height != tvHeight) {
                    cellHeight = tvHeight +43+16;
                }
                cell.BZTextView.height = tvHeight;
//                [_tableView beginUpdates];
//                [_tableView endUpdates];
            }
            
        }
        return cell;
    }else if (indexPath.row == _cellNum-2)
    {
       __block STMedicationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"3"];
        
        if (!cell) {
         cell =  [[STMedicationCell alloc]initWithStyle1:UITableViewCellStyleDefault reuseIdentifier:@"3"];
        }
        
        cell.timeLab.text = [[upLoadTime toDate:@"yyyy-MM-dd HH:mm:ss"] toString:@"aakk:mm yyyy-MM-dd"];
        cell.timeLab.textColor = RGB(19, 19, 19);
        
        if (_dataDict != nil) {
            cell.timeLab.text = [[[_dataDict getStringValue:@"MEDICATIONTIME"] toDate:@"yyyy-MM-dd HH:mm:ss"] toString:@"aakk:mm yyyy-MM-dd"];
            cell.timeLab.textColor = RGB(19, 19, 19);
        }
        
        if ( ([self.AddBtnHidden isEqualToString:@"hidden"])) {
            cell.userInteractionEnabled = false;
        }

        
        cell.addBlock = ^(NSInteger num){
//            [_textView resignFirstResponder];
            selIndexPath = indexPath;
            [self.view endEditing:YES];
            STSelectDateView *selDateView = [[STSelectDateView alloc]initWithType:DateTime];
            [GL_KEYWINDOW addSubview:selDateView];
            selDateView.delegate = self;
            
            [selDateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(GL_KEYWINDOW);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
            }];
        };
        return cell;
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _cellNum-2) {
        return 43*3+8;
    }
    if (indexPath.row == _cellNum-2) {
        return 43;
    }
    if (indexPath.row == _cellNum - 1) {
        return cellHeight;
    }
    return cellHeight;
}

- (void)textfieldFieldDidChange:(UITextField *)sender
{

    if (_dataDict) {
        NSInteger idx               = sender.tag - 2017;
        NSMutableArray *tmpArr      = [NSMutableArray arrayWithArray:[_dataDict objectForKey:@"DETAIL"]];
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:[tmpArr objectAtIndex:idx]];
        [tmpDic setObject:sender.text forKey:@"DOSE"];
        [tmpArr replaceObjectAtIndex:idx withObject:tmpDic];
        [_dataDict setObject:tmpArr forKey:@"DETAIL"];

    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _isTextView = false;
    CGRect rect = [textField convertRect:textField.bounds toView:GL_KEYWINDOW];
    tfRectY     = rect.origin.y + rect.size.height;
    return true;
}
#pragma  mark -- texeViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *tmpStr = textView.text;
    CGFloat tvHeight = [self heightForString:textView.text fontSize:15 andWidth:SCREEN_WIDTH - 15];
    if (tvHeight > 42) {
        if (textView.height != tvHeight) {
            
        }
    } else if(tvHeight <= 42){
        tvHeight = 42;
    }
    
    cellHeight = tvHeight +43+16;

    [_tableView beginUpdates];
    [_tableView endUpdates];
    
    textView.height = tvHeight;
    
    if (_dataDict) {
        [_dataDict setObject:textView.text forKey:@"REMARK"];
    }

}

- (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _isTextView = true;
    CGRect rect = [textView convertRect:textView.bounds toView:GL_KEYWINDOW];
    tfRectY     = rect.origin.y + rect.size.height;
    return true;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    bzText = textView.text;
    _textView = textView;

}

- (BOOL)isKeyboardListener
{
    return true;
}


- (void)keyboardWillShowHandler2:(NSDictionary *)userInfo
{
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    if (tfRectY  > SCREEN_HEIGHT - kbSize.height) {
        DLog(@"tfRecty == %lf kbsize.heght = %lf max = %lf",tfRectY,kbSize.height,(SCREEN_HEIGHT - kbSize.height) - tfRectY);
        WS(ws);
        
        
//        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self tableView:_tableView numberOfRowsInSection:0] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:false];
        
        if (_isTextView) {
            [_tableView setContentOffset:CGPointMake(0, _tableView.contentSize.height - _tableView.height + 20) animated:false];
            
            [UIView animateWithDuration:0.25f animations:^{
                ws.view.y = -kbSize.height+64;
            } completion:^(BOOL finished) {
            }];
            
            //延时运行
            double delayInSeconds = 0.5f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [_tableView setContentOffset:CGPointMake(0, _tableView.contentSize.height - _tableView.height + 20)];
            });
        } else {
            CGFloat heightDiff = (SCREEN_HEIGHT + 64 - kbSize.height) - tfRectY;
            [UIView animateWithDuration:0.25f animations:^{
                [_tableView setContentOffset:CGPointMake(0,-heightDiff + 64)];
            }];
        }
    }

}

- (void)keyboardWillHideHandler2:(NSDictionary *)userInfo
{
//    [_tableView setContentOffset:CGPointMake(0, _tableView.contentSize.height - _tableView.height + 20) animated:false];
    
    if (_isTextView) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_tableView numberOfRowsInSection:0] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:true];
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.view.y = 64;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击收起键盘

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

#pragma mark - DateSelectDelegate
- (void)getSelecteDataWithDate:(NSDate *)date
{
    STMedicationCell *cell = [_tableView cellForRowAtIndexPath:selIndexPath];

    cell.timeLab.text      = [date toString:@"aakk:mm yyyy-MM-dd"];
    cell.timeLab.textColor = RGB(19, 19, 19);
    
    upLoadTime = [date toString:@"yyyy-MM-dd HH:mm:ss"];
    
    if (_dataDict) {
        [_dataDict setObject:upLoadTime forKey:@"MEDICATIONTIME"];
    }
}


- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

- (void)dealloc
{
    _dataDict = nil;
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
