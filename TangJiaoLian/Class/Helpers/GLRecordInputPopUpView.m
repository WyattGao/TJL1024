//
//  GLInputPopUpView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/24.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLRecordInputPopUpView.h"
#import "STSelectDateView.h"

@interface GLRecordInputPopUpView () <SelecteDateDelegate,GLTextFieldDelegate>

///弹框视图
@property (nonatomic,strong) UIView *popView;
///取消按钮
@property (nonatomic,strong) GLButton *cancelBtn;
///提交按钮
@property (nonatomic,strong) GLButton *submitBtn;
///补录按钮
@property (nonatomic,strong) GLButton *addBtn;
///时间选择按钮
@property (nonatomic,strong) GLButton *timeBtn;
///血糖值录入框1
@property (nonatomic,strong) GLTextField *recordTF1;
///血糖值录入框2
@property (nonatomic,strong) GLTextField *recordTF2;
///标题下分割线
@property (nonatomic,strong) UIView  *line;
///标题
@property (nonatomic,strong) UILabel *titleLbl;
///完成后返回的字典
@property (nonatomic,strong) NSMutableDictionary *dataDic;
///提示lbl1
@property (nonatomic,strong) UILabel *tipLbl1;
///提示lbl2
@property (nonatomic,strong) UILabel *tipLbl2;
///单位lbl1
@property (nonatomic,strong) UILabel *unitLbl1;
///单位lbl2
@property (nonatomic,strong) UILabel *unitLbl2;


@end

@implementation GLRecordInputPopUpView

- (instancetype)initWithPopUpViewType:(GLInputPopUpViewType)type
{
    self.type = type;
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)createUI
{
    self.frame           = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = TCOL_MASKBG;
    
    [self addSubview:self.popView];
    
    WS(ws);
    
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws).offset(-30);
        make.centerX.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(300, 220));
    }];
}

- (void)show
{
    [GL_KEYWINDOW addSubview:self];
    
    WS(ws);
    [UIView animateWithDuration:0.3f animations:^{
        ws.popView.alpha = 1;
    }];
}

- (void)close
{
    WS(ws);
    [UIView animateWithDuration:0.3f animations:^{
        ws.popView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)submitBtnClick:(GLButton *)sender
{
    if (self.type == GLPopUpViewBlood) {
        [self.dataDic setValue:_recordTF1.text forKey:@"value"];
        [self.dataDic setValue:[self.timeBtn.lbl.text stringByAppendingString:@":00"] forKey:@"collectedtime"];
    } else {
        if ([_recordTF1.text floatValue] < [_recordTF2.text floatValue]) {
            GL_ALERT_E(@"最小预警值不得大于最大预警值")
            return;
        }
        [self.dataDic setValue:_recordTF1.text forKey:@"height"];
        [self.dataDic setValue:_recordTF2.text forKey:@"low"];
    }
    _popUpViewSubmit(self.dataDic);
    [self close];
}

- (void)timeClick:(GLButton *)sender
{
    if (self.type == GLPopUpViewTarget) {
        [self close];
    } else {
        [[self getFormViewController].view endEditing:true];
        STSelectDateView *selDateView = [[STSelectDateView alloc] initWithType:DateTime];
        [selDateView show];
        selDateView.delegate = self;
    }
}

- (void)popUpViewSubmit:(PopUpViewSubmit)popUpViewSubmit
{
    _popUpViewSubmit = popUpViewSubmit;
}

#pragma mark - SelectDateDelegate
- (void)getSelecteDataWithDate:(NSDate *)date
{
    [self.timeBtn setTitle:[date toString:@"yyyy-MM-dd HH:mm"] forState:UIControlStateNormal];
    [self.dataDic setValue:[date toStringyyyyMMddHHmmss] forKey:@"collectedtime"];
}

#pragma mark - GLTextFeildDelegate
- (void)textfieldFieldDidChange:(UITextField *)textField
{
    if (_type == GLPopUpViewBlood) {
        if (textField == _recordTF1) {
            if ([textField.text floatValue] > 33.0f) {
                GL_ALERT_E(@"参比血糖最大只能录入33.0f");
                textField.text = @"33.0";
            } else if([textField.text floatValue] < 0) {
                textField.text = @"0";
                GL_ALERT_E(@"参比血糖不得为0");
            }
        }
    } else {
        if ([textField.text floatValue] > 33.0f) {
            GL_ALERT_E(@"预警值最大只能录入33.0f");
            textField.text = @"33.0";
        } else if([textField.text floatValue] < 0) {
            textField.text = @"0";
            GL_ALERT_E(@"预警值不得小于0");
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    }

    return true;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[self getFormViewController] view] endEditing:true];
}

#pragma mark - 初始化控件
- (UIView *)popView
{
    if (!_popView) {
        _popView = [UIView new];
        
        _popView.alpha           = 0;
        _popView.cornerRadius    = 6;
        _popView.backgroundColor = RGB(255, 255, 255);
        
        [_popView addSubview:self.titleLbl];
        [_popView addSubview:self.line];
        [_popView addSubview:self.recordTF1];
        [_popView addSubview:self.addBtn];
        [_popView addSubview:self.submitBtn];
        [_popView addSubview:self.tipLbl1];
        [_popView addSubview:self.tipLbl2];
        [_popView addSubview:self.unitLbl1];
        
        WS(ws);

        if (_type == GLPopUpViewTarget) {
            self.titleLbl.text = @"血糖预警值设置";
            self.tipLbl1.text  = @"请输入高血糖值";
            self.tipLbl2.text  = @"请输入低血糖值";
            self.recordTF1.text = [GL_USERDEFAULTS getStringValue:SamTargetHeight];
            self.recordTF2.text = [GL_USERDEFAULTS getStringValue:SamTargetLow];

            [_popView addSubview:self.tipLbl2];
            [_popView addSubview:self.recordTF2];
            [_popView addSubview:self.unitLbl2];
            
            [_addBtn setTitle:@"取消" forState:UIControlStateNormal];
            
            [self.recordTF1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_popView).offset(78);
                make.right.equalTo(_popView.mas_right).offset(-77);
                make.size.mas_equalTo(CGSizeMake(80, 30));
            }];
            
            [self.recordTF2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(ws.recordTF1.mas_bottom).offset(21);
                make.right.equalTo(ws.recordTF1.mas_right);
                make.size.equalTo(ws.recordTF1);
            }];
            
            [self.tipLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(ws.recordTF2);
                make.left.equalTo(_popView).offset(19);
            }];
            
            [self.tipLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(ws.recordTF1);
                make.left.equalTo(_popView).offset(19);
            }];
            
            [self.unitLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(ws.recordTF1.mas_right).offset(-2);
                make.centerY.equalTo(ws.recordTF1);
            }];
            
            [self.unitLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(ws.recordTF2.mas_right).offset(-2);
                make.centerY.equalTo(ws.recordTF2);
            }];
        } else {
            self.titleLbl.text  = @"记录参比血糖";
            self.tipLbl1.text   = @"时间";
            self.tipLbl2.text   = @"参比血糖";
            [_popView addSubview:self.timeBtn];
            [_popView addSubview:self.cancelBtn];

            [_addBtn setTitle:@"补录" forState:UIControlStateNormal];
            
            [self.recordTF1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_popView).offset(104);
                make.right.equalTo(_popView.mas_right).offset(-80);
                make.size.mas_equalTo(CGSizeMake(80, 30));
            }];
            
            [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_popView.mas_right).offset(-19);
                make.top.equalTo(_popView).offset(68);
            }];
            
            [self.tipLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(ws.timeBtn);
                make.left.equalTo(_popView).offset(19);
            }];
            
            
            [self.tipLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(ws.recordTF1);
                make.left.equalTo(_popView).offset(19);
            }];
            
            [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_popView).offset(10);
                make.left.equalTo(_popView).offset(8);
                make.size.mas_equalTo(CGSizeMake(30, 30));
            }];
            
            [self.unitLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(ws.timeBtn.mas_right);
                make.centerY.equalTo(ws.recordTF1);
            }];
        }
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_popView);
            make.top.equalTo(_popView).offset(18);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_popView).offset(54);
            make.centerX.equalTo(_popView);
            make.size.mas_equalTo(CGSizeMake(260, 2));
        }];
        
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_popView).offset(34);
            make.bottom.equalTo(_popView.mas_bottom).offset(-17.5);
            make.size.mas_equalTo(CGSizeMake(90, 35));
        }];
        
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_popView.mas_right).offset(-37);
            make.size.mas_equalTo(CGSizeMake(90, 35));
            make.bottom.equalTo(ws.addBtn.mas_bottom);
        }];

    }
    return _popView;
}

- (GLButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [GLButton new];
        [_cancelBtn setImage:GL_IMAGE(@"关闭") forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setGraphicLayoutState:PICCENTER];
    }
    return _cancelBtn;
}

- (UIView *)line
{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = TCOL_LINE;
    }
    return _line;
}

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        _titleLbl           = [UILabel new];
        _titleLbl.font      = GL_FONT(16);
        _titleLbl.textColor = TCOL_NORMALETEXT;
    }
    return _titleLbl;
}

- (GLButton *)timeBtn
{
    if (!_timeBtn) {
        _timeBtn = [GLButton new];
        [_timeBtn setTitle:[[NSDate date] toString:@"yyyy-MM-dd HH:mm"] forState:UIControlStateNormal];
        [_timeBtn setTitleColor:TCOL_NORMALETEXT forState:UIControlStateNormal];
        [_timeBtn setFont:GL_FONT(15)];
        [_timeBtn addTarget:self action:@selector(timeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeBtn;
}

- (GLTextField *)recordTF1
{
    if (!_recordTF1) {
        _recordTF1               = [GLTextField new];
        _recordTF1.borderWidth   = 1;
        _recordTF1.borderColor   = RGB(213, 213, 213);
        _recordTF1.returnKeyType = UIReturnKeyDone;
        _recordTF1.limitType     = GLTextFieldTypeDecimalPointAndDigital;
        _recordTF1.glDelegate    = self;
        _recordTF1.keyboardType  = UIKeyboardTypeDecimalPad;
        _recordTF1.textAlignment = NSTextAlignmentCenter;
    }
    return _recordTF1;
}

- (GLTextField *)recordTF2
{
    if (!_recordTF2) {
        _recordTF2               = [GLTextField new];
        _recordTF2.borderWidth   = 1;
        _recordTF2.borderColor   = RGB(213, 213, 213);
        _recordTF2.returnKeyType = UIReturnKeyDone;
        _recordTF2.limitType     = GLTextFieldTypeDecimalPointAndDigital;
        _recordTF2.glDelegate    = self;
        _recordTF2.keyboardType  = UIKeyboardTypeDecimalPad;
        _recordTF2.textAlignment = NSTextAlignmentCenter;
    }
    return _recordTF2;
}

- (GLButton *)addBtn
{
    if (!_addBtn) {
        _addBtn                 = [GLButton new];
        _addBtn.cornerRadius    = 5;
        _addBtn.borderColor     = TCOL_BORDER;
        _addBtn.borderWidth     = 1;
        _addBtn.backgroundColor = RGB(255, 255, 255);
        [_addBtn setFont:GL_FONT(15)];
        [_addBtn setGraphicLayoutState:TEXTCENTER];
        [_addBtn addTarget:self action:@selector(timeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addBtn;
}

- (GLButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn                 = [GLButton new];
        _submitBtn.cornerRadius    = 5;
        [_submitBtn setFont:GL_FONT(15)];
        [_submitBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_submitBtn setGraphicLayoutState:TEXTCENTER];
        [_submitBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:TCOL_MAIN forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (UILabel *)tipLbl1
{
    if (!_tipLbl1) {
        _tipLbl1           = [UILabel new];
        _tipLbl1.font      = GL_FONT(15);
        _tipLbl1.textColor = TCOL_NORMALETEXT;
    }
    return _tipLbl1;
}

- (UILabel *)tipLbl2
{
    if (!_tipLbl2) {
        _tipLbl2           = [UILabel new];
        _tipLbl2.font      = GL_FONT(15);
        _tipLbl2.textColor = TCOL_NORMALETEXT;
    }
    return _tipLbl2;
}

- (UILabel *)unitLbl1
{
    if (!_unitLbl1) {
        _unitLbl1           = [UILabel new];
        _unitLbl1.font      = GL_FONT(15);
        _unitLbl1.textColor = TCOL_NORMALETEXT;
        _unitLbl1.text      = @"mmol/L";
    }
    return _unitLbl1;
}

- (UILabel *)unitLbl2
{
    if (!_unitLbl2) {
        _unitLbl2           = [UILabel new];
        _unitLbl2.font      = GL_FONT(15);
        _unitLbl2.textColor = TCOL_NORMALETEXT;
        _unitLbl2.text      = @"mmol/L";
    }
    return _unitLbl2;
}

- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

@end
