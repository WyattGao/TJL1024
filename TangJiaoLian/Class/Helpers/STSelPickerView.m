//
//  STSelPickerView.m
//  Diabetes
//
//  Created by 高临原 on 16/3/3.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "STSelPickerView.h"

@interface STSelPickerView () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIPickerView *datePicker;
@property (nonatomic,strong) NSArray *textArr;

@end

@implementation STSelPickerView

- (instancetype)initWithTextArr:(NSArray *)textArr
{
    self = [super init];
    
    if (self) {
        
        _textArr = textArr;
        
        UIButton *backGroundBtn    = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];/**< 透明背景 */
        UIView *datePickView       = [UIView new];                 /**< 放置控件背景View */
        _datePicker   = [UIPickerView new];                        /**< 日期PickerView */
        
        [self         addSubview:backGroundBtn];
        [self         addSubview:datePickView];
        [datePickView addSubview:_datePicker];
        
        datePickView.tag              = 16;
        datePickView.backgroundColor  = RGB(255, 255, 255);
        backGroundBtn.tag             = 15;
        backGroundBtn.backgroundColor = [UIColor blackColor];
        backGroundBtn.alpha           = 0;
        [backGroundBtn addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
        _datePicker.backgroundColor   = [UIColor whiteColor];
        _datePicker.delegate          = self;
        _datePicker.dataSource        = self;
        
        
        WS(ws);
        
        [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(35);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 250 - 35));
            make.centerX.mas_equalTo(ws);
        }];
        
        datePickView.frame = CGRectMake(0,SCREEN_HEIGHT + 250, SCREEN_WIDTH, 250);
        
        //确定按钮和取消按钮
        for (NSInteger i = 0; i < 2; i++) {
            UIButton *button = [UIButton new];
            button.tag = 120+i;
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:TCOL_MAIN forState:UIControlStateNormal];
            [button setTitle:@[@"取消",@"确定"][i] forState:UIControlStateNormal];
            [button.titleLabel setFont:GL_FONT(17)];
            [button addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];

            [datePickView addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if (!i) {
                    make.left.mas_equalTo(15);
                } else {
                    make.right.mas_equalTo(-15);
                }
                make.top.mas_equalTo(20);
            }];
        }
        
        for (NSInteger i = 0;i < 2;i++) {
            UIView *line = [UIView new];
            [_datePicker addSubview:line];
            line.backgroundColor = TCOL_LINE;
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i) {
                    make.centerY.equalTo(_datePicker).offset(-12);
                } else {
                    make.centerY.equalTo(_datePicker).offset(12);
                }
                make.centerX.equalTo(_datePicker);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
            }];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            backGroundBtn.alpha = 0.3;
            datePickView.y = SCREEN_HEIGHT - datePickView.height;
        }];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _textArr.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    _myLbl = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 90, 30.0f)];
    _myLbl.textAlignment   = NSTextAlignmentCenter;
    _myLbl.backgroundColor = RGB(255, 255, 255);
    _myLbl.font            = GL_FONT_B(20);
    _myLbl.text            = _textArr[row];
    return _myLbl;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _myLbl.text = [_textArr objectAtIndex:row];
}

//时间选择Click
- (void)dateClick:(UIButton *)sender
{
    //保存按钮
    if (sender.tag == 121) {
        [self.delegate getSelText:self];
    }

    
    [UIView animateWithDuration:0.3 animations:^{
        [self viewWithTag:15].alpha = 0;
        [self viewWithTag:16].y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show
{
    [GL_KEYWINDOW addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(GL_KEYWINDOW);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
    }];
}


@end
