//
//  SpringsBoxView.m
//  Diabetes
//
//  Created by 高临原 on 15/11/17.
//  Copyright © 2015年 hlcc. All rights reserved.
//

#import "SpringsBoxView.h"

@interface SpringsBoxView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger number;
    NSMutableArray *numArr;
    NSMutableArray *numArr2;
    NSString *unitStr;
    NSString *leftStr;
    NSString *rightStr;
    MASViewAttribute *boom;
    NSArray *_detailsArr;
    NSInteger selectedType;
}

@property (nonatomic,strong) UILabel *myLbl;
@property (nonatomic,strong) UILabel *tfLbl;
@property (nonatomic,strong) UILabel *tfLbl2;
@property (nonatomic,strong) UILabel *delLbl;
@property (nonatomic,assign) NSInteger type;
@end

@implementation SpringsBoxView

- (instancetype)initWithTitle:(NSString *)title Num:(NSInteger )num lMiniScope:(NSInteger )mini TolMaxScope:(NSInteger)max rMiniScope:(NSInteger)rMini TorMaxScope:(NSInteger)rMax Unit:(NSString *)unit DetailsArr:(NSArray *)detailsArr
{
    self = [super init];
    
    if (self) {
        WS(ws);
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        self.alpha = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
        }];
        
        number    = num;
        numArr    = [NSMutableArray new];
        numArr2   = [NSMutableArray new];
        unitStr   = unit;
        _detailsArr = detailsArr;
        
        leftStr   = [@(mini) stringValue];
        rightStr  = [@(rMini) stringValue];
        
        //血糖值含小数
        if ([unitStr isEqualToString:@"mmol/L"]) {
            for (NSInteger i = mini;i <= max ;i++) {
                for (NSInteger y = 0;y <= 9;y++) {
                    [numArr addObject:[NSString stringWithFormat:@"%ld.%ld",i,y]];
                }
            }
            
            for (NSInteger i = rMini;i <= rMax; i++) {
                for (NSInteger y = 0;y <= 9;y++) {
                    [numArr2 addObject:[NSString stringWithFormat:@"%ld.%ld",i,y]];
                }
            }
        } else {
            for (NSInteger i = mini;i <= max ;i++) {
                [numArr addObject:@(i)];
            }
            
            for (NSInteger i = rMini;i <= rMax; i++) {
                [numArr2 addObject:@(i)];
            }
        }
        
        UIButton *backBtn      = [UIButton new];
        UILabel  *titleLbl     = [UILabel new];
        UIView   *mainView     = [UIView new];
        UIImageView *lineIV    = [UIImageView new];

        UIPickerView *pickView = [UIPickerView new];
        UIButton     *clenBtn  = [UIButton new];
        UIButton     *sureBtn  = [UIButton new];
        _tfLbl                 = [UILabel  new];
        
        [self     addSubview:backBtn];
        [self     addSubview:mainView];
        [mainView addSubview:titleLbl];
        [mainView addSubview:lineIV];
        
        [mainView addSubview:pickView];
        [mainView addSubview:clenBtn];
        [mainView addSubview:sureBtn];
        [mainView addSubview:_tfLbl];
        
        backBtn.backgroundColor  = [UIColor blackColor];
        backBtn.alpha            = 0.3;
        [backBtn setTag:100];
        [backBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        mainView.backgroundColor = [UIColor whiteColor];
        
        titleLbl.text            = title;
        titleLbl.font            = GL_FONT((XT(40)));
        titleLbl.textColor       = TCOL_MAIN;
        
        lineIV.backgroundColor   = RGB(245.00, 245.00, 249.00);
        
        _tfLbl.font              = GL_FONT((XT(34)));
        _tfLbl.textColor         = TCOL_MAIN;
        _tfLbl.text          = [NSString stringWithFormat:@"%ld",(long)mini];
        _tfLbl.textAlignment     = NSTextAlignmentCenter;
        
        pickView.delegate        = self;
        pickView.dataSource      = self;
        pickView.tag             = 1000;
        
        [clenBtn setTag:101];
        [sureBtn setTag:102];
        
        [clenBtn setCornerRadius:5];
        [clenBtn setBorderWidth :1];
        [clenBtn setBorderColor:TCOL_MAIN];
        [clenBtn setBackgroundColor:RGB(255, 255, 255)];
        
        [sureBtn setCornerRadius:5];
        [sureBtn setBackgroundColor:TCOL_MAIN];
        
        [clenBtn setTitle:@"取消" forState:UIControlStateNormal];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        
        [clenBtn setTitleColor:TCOL_MAIN forState:UIControlStateNormal];
        [sureBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        
        [clenBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [sureBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(ws);
            make.size.equalTo(ws);
        }];
        
        [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws).offset(13);
            make.right.equalTo(ws.mas_right).offset(-13);
            make.centerY.equalTo(ws);
            make.height.equalTo(@(XT(750)));
        }];
        
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mainView).offset(XT(40));
            make.centerX.equalTo(mainView);
        }];
        
        [lineIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(titleLbl.mas_bottom).offset(XT(40));
            make.height.equalTo(@(1));
            make.left.equalTo(ws).offset(13);
            make.right.equalTo(ws.mas_right).offset(-13);
            make.centerX.equalTo(mainView);
        }];
        
        [detailsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *lineIV2   = [UIImageView new];
            _delLbl                = [UILabel new];
            UILabel   *unitLbl     = [UILabel new];
            
            [mainView addSubview:lineIV2];
            [mainView addSubview:_delLbl];
            [mainView addSubview:unitLbl];
            
            _delLbl.text            = [detailsArr objectAtIndex:idx];
            _delLbl.font            = GL_FONT((XT(30)));
            _delLbl.textColor       = RGB(74, 74, 74);
            unitLbl.text            = unit;
            lineIV2.backgroundColor = [UIColor blackColor];
            
            if (!idx) {
                _tfLbl                 = [UILabel  new];
                [mainView addSubview:_tfLbl];
                _tfLbl.font              = GL_FONT((XT(34)));
                _tfLbl.textColor         = TCOL_MAIN;
                if ([unitStr isEqualToString:@"Kg"]) {
                    _tfLbl.text              = [NSString stringWithFormat:@"%ld.0",(long)mini];
                } else {
                    _tfLbl.text              = [NSString stringWithFormat:@"%ld",(long)mini];
                }
                _tfLbl.textAlignment     = NSTextAlignmentCenter;
            }
            
            if (detailsArr.count == 1) {
                
                unitLbl.font             = GL_FONT((XT(30)));
                
                [_delLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(lineIV2.mas_left).offset(-5);
                    make.bottom.equalTo(lineIV2.mas_bottom).offset(-1);
                }];
                
                [unitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(_delLbl);
                    make.left.equalTo(lineIV2.mas_right).offset(5);
                }];
                
                
                [lineIV2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(XT(100), 1.5));
                    make.centerX.mas_equalTo(mainView);
                    make.top.mas_equalTo(lineIV.mas_bottom).offset(XT(90));
                }];
                
                boom = lineIV2.mas_bottom;
                
                [_tfLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(_delLbl.mas_bottom);
                    make.centerX.equalTo(lineIV2);
                    make.width.equalTo(lineIV2);
                }];
            } else {
                _delLbl.font = GL_FONT((XT(28)));
                unitLbl.text = unit;
                unitLbl.font = GL_FONT((XT(28)));
                _tfLbl.font  = GL_FONT((XT(30)));
                _tfLbl2.font = GL_FONT((XT(34)));
                _tfLbl2.text = [NSString stringWithFormat:@"%ld",(long)rMini];
                
                [_delLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(lineIV2.mas_left).offset(-5);
                    make.bottom.equalTo(lineIV2.mas_bottom).offset(-1);
                }];
                
                [unitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(_delLbl);
                    make.left.equalTo(lineIV2.mas_right).offset(5);
                }];
                
                if (!idx) {
                    
                    UILabel *tipsLbl = [UILabel new];
                    [mainView addSubview:tipsLbl];
                    
                    tipsLbl.font      = GL_FONT((XT(26)));
                    tipsLbl.textColor = RGB(102, 102, 102);
                    if ([unitStr isEqualToString:@"mmol/L"]) {
                        tipsLbl.text  = @"最高血糖值不得小于最低血糖值";
                    } else {
                        tipsLbl.text  = @"收缩压值需大于舒张压";
                    }
                    
                    [lineIV2 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(XT(80), 1.5));
                        make.right.mas_equalTo(-(SCREEN_WIDTH/2 + 40));
                        make.top.mas_equalTo(lineIV.mas_bottom).offset(XT(130));
                    }];
                    [_tfLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(_delLbl.mas_bottom);
                        make.centerX.equalTo(lineIV2);
                        make.width.equalTo(lineIV2);
                    }];
                    
                    [tipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(mainView);
                        make.top.equalTo(lineIV.mas_bottom).offset(10);
                    }];
                } else {
                    _tfLbl2 = [UILabel new];
                    [mainView addSubview:_tfLbl2];
                    
                    _tfLbl2.font              = GL_FONT((XT(34)));
                    _tfLbl2.textColor         = TCOL_MAIN;
                    _tfLbl2.text              = [NSString stringWithFormat:@"%ld",(long)rMini];
                    _tfLbl2.textAlignment     = NSTextAlignmentCenter;
                    
                    
                    [lineIV2 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(XT(80), 1.5));
                        make.left.mas_equalTo(SCREEN_WIDTH/2 + 40);
                        make.top.mas_equalTo(lineIV.mas_bottom).offset(XT(130));
                    }];
                    [_tfLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(_delLbl.mas_bottom);
                        make.centerX.equalTo(lineIV2);
                        make.width.equalTo(lineIV2);
                    }];
                }
                
                boom = lineIV2.mas_bottom;
            }
            
        }];
        
        
        [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(boom).offset(0);
            make.width.equalTo(mainView);
            make.centerX.equalTo(mainView);
        }];
        
        [clenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mainView).offset(XT(50));
            make.bottom.equalTo(mainView.mas_bottom).offset(-XT(25));
            make.size.mas_equalTo(CGSizeMake(90, 30));
        }];
        
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(mainView.mas_right).offset(-XT(50));
            make.bottom.equalTo(clenBtn.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(90, 30));
        }];
        
        if ([unit isEqualToString:@"mmHg"]) {
            [pickView selectRow:120 - 50 inComponent:0 animated:YES];
            [pickView selectRow:80 - 50 inComponent:1 animated:YES];
            
            _tfLbl.text = @"120";
            _tfLbl2.text = @"80";
            
            leftStr = @"120";
            rightStr = @"50";
        } else if (!_isHideUnit) {
            _tfLbl.text = [NSString stringWithFormat:@"%ld.0",mini];
        }
        
        //        [pickView selectRow:0 inComponent:0 animated:YES];
        //        [pickView selectRow:0 inComponent:1 animated:YES];
        //
        //        [pickView reloadComponent:0];
        //        [pickView reloadComponent:1];
    }
    
    return self;
}

- (void)setIsHideUnit:(BOOL)isHideUnit
{
    self -> _isHideUnit = isHideUnit;
    UIPickerView *pick = (UIPickerView *)[self viewWithTag:1000];
    [pick reloadAllComponents];
}

#pragma mark - PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return number;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (!component) {
        return numArr.count;
    } else {
        return numArr2.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    _myLbl = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 90, 30.0f)];
    _myLbl.textAlignment   = NSTextAlignmentCenter;
    _myLbl.textColor       = TCOL_MAIN;
    _myLbl.backgroundColor = RGB(255, 255, 255);
    _myLbl.font            = GL_FONT(XT(36));
    
    switch (component) {
        case 0:
            _myLbl.text = [[numArr firstObject] isKindOfClass:[NSString class]] ? [numArr objectAtIndex:row] : [[numArr objectAtIndex:row] stringValue];
            break;
        case 1:
            if (!_isHideUnit) {
                _myLbl.text = [NSString stringWithFormat:@".%ld%@",[[numArr2 objectAtIndex:row] integerValue],unitStr];
            } else {
                _myLbl.text = [[numArr2 firstObject] isKindOfClass:[NSString class]] ? [numArr2 objectAtIndex:row] : [[numArr2 objectAtIndex:row] stringValue];
            }
            break;
        default:
            break;
    }
    
    return _myLbl;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (!component) {
        leftStr = [[numArr firstObject] isKindOfClass:[NSString class]] ? [numArr objectAtIndex:row] : [[numArr objectAtIndex:row] stringValue];
    } else {
        rightStr = [[numArr2 firstObject] isKindOfClass:[NSString class]] ? [numArr2 objectAtIndex:row] : [[numArr2 objectAtIndex:row] stringValue];
    }
    
    if (_detailsArr.count > 1) {
        _tfLbl.text = [NSString stringWithFormat:@"%@",leftStr];
        _tfLbl2.text = [NSString stringWithFormat:@"%@",rightStr];
    } else {
        if ([unitStr isEqualToString:@"kg"] || [unitStr isEqualToString:@"cm"]) {
            _tfLbl.text = [NSString stringWithFormat:@"%@.%@",leftStr,rightStr];
        } else {
            _tfLbl.text = leftStr;
        }
    }
    
}


#pragma  mark - Click
- (void)btnClick:(UIButton *)sender
{
    //点击的是确定
    if (sender.tag == 102) {
        if ([unitStr isEqualToString:@"mmol/L"]) {
            if ([_tfLbl2.text floatValue] < [_tfLbl.text floatValue]) {
                GL_ALERT_1(@"最高血糖值不得小于最低血糖值");
                return;
            }
        }
        if ([unitStr isEqualToString:@"mmHg"]) {
            if ([_tfLbl.text integerValue] <= [_tfLbl2.text integerValue]) {
                GL_ALERT_1(@"收缩压值需大于舒张压值");
                return;
            }
            [self.delegate springsBoxViewSelectedWhitNumStr:[NSString stringWithFormat:@"高压%@ 低压%@",_tfLbl.text,_tfLbl2.text]];
        } else {
            [self.delegate springsBoxViewSelectedWhitNumStr:[NSString stringWithFormat:@"%@%@",_tfLbl.text,unitStr]];
        }
        
        _leftStr  = _tfLbl.text;
        _rightStr = _tfLbl2.text;
        
        if ([self.delegate2 respondsToSelector:@selector(springsBoxViewSelectedWhitBoxView:)]) {
            [self.delegate2 springsBoxViewSelectedWhitBoxView:self];
        }
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show
{
    [GL_KEYWINDOW addSubview:self];
}


@end
