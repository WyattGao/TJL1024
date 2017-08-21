//
//  STSelectDateView.m
//  Diabetes
//
//  Created by 高临原 on 15/12/9.
//  Copyright © 2015年 hlcc. All rights reserved.
//

#import "STSelectDateView.h"

@interface STSelectDateView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UILabel *myLbl;

@property (nonatomic,assign) SELECT_DATAVIEW_TYPE TYPE;

@end

@implementation STSelectDateView

- (instancetype)initWithType:(SELECT_DATAVIEW_TYPE)type;
{
    _TYPE = type;
    if (type == ISAge) {
        _isOnlyAge = YES;
    }
    if (type == 2) {
        _isOnlyYeaer = YES;
    }
    if (type == ParticularYear) {
        _isParticularYear = ParticularYear;
    }
    if (type == DateTime || type == Default) {
        return [self initDatePickerView];
    }

   return [self init];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _selectDay = _selectMoth = _selectYear =  @"0";
        if (_isOnlyYeaer||_isOnlyAge) {
            _selectYear = @"1";
        }
        
        [self createUI];
    }
    
    return self;
}

- (instancetype)initDatePickerView
{
    self = [super init];
    if (self) {
        _TYPE = Default;
        [self createUI];
    }

    return self;
}

- (void)createUI
{
    id datePicker = [self getDatePicker];
    
    [self addSubview:self.backGroundBtn];
    [self addSubview:self.datePickView];
    [self.datePickView addSubview:datePicker];
    
    WS(ws);
    
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.centerX.mas_equalTo(ws);
    }];
    
    
    //确定按钮和取消按钮
    for (NSInteger i = 0; i < 2; i++) {
        UIButton *button = [UIButton new];
        button.tag       = 120+i;
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:TCOL_MAIN forState:UIControlStateNormal];
        [button setTitle:@[@"取消",@"确定"][i] forState:UIControlStateNormal];
        [button.titleLabel setFont:GL_FONT(XT(34))];
        [button addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.datePickView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            if(!i){
                make.left.mas_equalTo(15);
            } else {
                make.right.mas_equalTo(-15);
            }
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        ws.backGroundBtn.alpha = 0.3;
        ws.datePickView.y      = SCREEN_HEIGHT - ws.datePickView.height;
    }];
}

- (UIView *)datePickView
{
    if (!_datePickView) {
        _datePickView                 = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT + 250, SCREEN_WIDTH, 250)];
        _datePickView.tag             = 26;
        _datePickView.backgroundColor = RGB(255, 255, 255);
    }
    return _datePickView;
}

- (UIButton *)backGroundBtn
{
    if (!_backGroundBtn) {
        _backGroundBtn                 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backGroundBtn.tag             = 25;
        _backGroundBtn.backgroundColor = [UIColor blackColor];
        _backGroundBtn.alpha           = 0;
        [_backGroundBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

    }
    return _backGroundBtn;
}

- (id)getDatePicker
{
    if (self.TYPE == DEFAULT || self.TYPE == DateTime) {
        UIDatePicker *datePicker   = [UIDatePicker new]; /**< 日期PickerView */
        datePicker.tag                = 2000;
        datePicker.backgroundColor    = [UIColor whiteColor];
        if (_TYPE == DateTime) {
            datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        } else {
            datePicker.datePickerMode = UIDatePickerModeDate;
        }
        datePicker.maximumDate        = [NSDate date];
        NSTimeInterval times          = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] - (NSTimeInterval)24*60*60*365*150;
        datePicker.minimumDate        = [NSDate dateWithTimeIntervalSince1970:times];
        return datePicker;
    } else {
        UIPickerView *datePicker   = [UIPickerView new];                        /**< 日期PickerView */
        
        [self addSubview:self.backGroundBtn];
        [self addSubview:self.datePickView];
        [self.datePickView addSubview:datePicker];
        
        datePicker.backgroundColor   = [UIColor whiteColor];
        datePicker.delegate          = self;
        datePicker.dataSource        = self;
        if (_isParticularYear) {
            [datePicker selectRow:[self pickerView:datePicker numberOfRowsInComponent:0] - 1 inComponent:0 animated:true];
            _selectYear = [[NSDate date] toString:@"yyyy"];
        }
        return datePicker;
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_isOnlyYeaer||_isOnlyAge||_isParticularYear) {
        return 1;
    }
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            if (_isOnlyYeaer || _isOnlyAge) {
                return 100;
            } else if(_isParticularYear){
                return [[[NSDate date] toString:@"yyyy"] integerValue] - 1920 + 1;
            } else {
                return _isOnlyYeaer||_isOnlyAge ? 100 : 101;
            }
            break;
         case 1:
            return 13;
            break;
        case 2:
            return 32;
            break;
        default:
            break;
    }
    
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *unitStr;
    switch (component) {
        case 0:{
            if (_isOnlyAge) {
                unitStr = @"岁";
            }else
            {
                unitStr = @"年";
            }
            break;
        }
        case 1:unitStr = @"月";break;
        case 2:unitStr = @"天";break;
    }
    
    _myLbl = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 90, 30.0f)];
    _myLbl.textAlignment   = NSTextAlignmentCenter;
    _myLbl.backgroundColor = RGB(255, 255, 255);
    _myLbl.font            = GL_FONT_B(XT(38));
    if (_isOnlyAge||_isOnlyYeaer) {
        _myLbl.text = [NSString stringWithFormat:@"%ld%@",(long)row + 1,unitStr];
    } else if(_isParticularYear) {
        _myLbl.text = [NSString stringWithFormat:@"%ld%@",(long)row + 1920,unitStr];
    } else {
        _myLbl.text = [NSString stringWithFormat:@"%ld%@",(long)row,unitStr];
    }
    return _myLbl;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            if (_isOnlyYeaer || _isOnlyAge) {
                _selectYear = [NSString stringWithFormat:@"%ld",(long)row + 1];
            } else if(_isParticularYear){
                _selectYear = [NSString stringWithFormat:@"%ld",(long)row + 1920];
            } else {
                _selectYear = [NSString stringWithFormat:@"%ld",(long)row];
            }
            break;
        case 1:
            _selectMoth = [NSString stringWithFormat:@"%ld",(long)row];
            break;
        case 2:
            _selectDay  = [NSString stringWithFormat:@"%ld",(long)row];
            break;
    }
}

//时间选择Click
- (void)dateClick:(UIButton *)sender
{
    [[[self getFormViewController] view] endEditing:YES];
    
    if (sender.tag == 121) {
        if (self.TYPE == DEFAULT || self.TYPE == DateTime) {
            UIDatePicker *datePicker = (UIDatePicker *)[self viewWithTag:2000];
            _selectYear              = [datePicker.date toString:@"yyyy"];
            _selectMoth              = [datePicker.date toString:@"MM"];
            _selectDay               = [datePicker.date toString:@"dd"];
            _selectDeate             = datePicker.date;
            
            
            if ([self.delegate respondsToSelector:@selector(getSelecteDataYeaer:WithMoth:WithDay:)]) {
                [self.delegate getSelecteDataYeaer:_selectYear WithMoth:_selectMoth WithDay:_selectDay];
            }
            if ([self.delegate respondsToSelector:@selector(getSelecteDataWithDate:)]) {
                [self.delegate getSelecteDataWithDate:datePicker.date];
            }
            if ([self.delegate respondsToSelector:@selector(getSelecteDataWithSelecteView:)]) {
                [self.delegate getSelecteDataWithSelecteView:self];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(getSelecteDataYeaer:WithMoth:WithDay:)]) {
                [self.delegate getSelecteDataYeaer:_selectYear WithMoth:_selectMoth WithDay:_selectDay];
            }
            if ([self.delegate respondsToSelector:@selector(getSelecteDataWithSelecteView:)]) {
                [self.delegate getSelecteDataWithSelecteView:self];
            }
        }
    }

    [self dismiss];
}

- (void)show
{
    [GL_KEYWINDOW addSubview:self];
    
    WS(ws);
    
    [UIView animateWithDuration:0.3f animations:^{
        [ws viewWithTag:25].alpha = 0.3f;
        [ws viewWithTag:26].y     = SCREEN_HEIGHT  - [ws viewWithTag:26].height;
    }];
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(GL_KEYWINDOW);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
    }];    
}

- (void)dismiss
{
    WS(ws);
    
    [UIView animateWithDuration:0.3 animations:^{
        [ws viewWithTag:25].alpha = 0;
        [ws viewWithTag:26].y     = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
