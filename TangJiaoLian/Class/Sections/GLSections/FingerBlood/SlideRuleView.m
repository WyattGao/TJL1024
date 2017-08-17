//
//  SlideRuleView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//
///滑尺

#import "SlideRuleView.h"

typedef NS_ENUM(NSInteger,GLSlideBtnType){
    ///取消按钮
    GLCancelBtn = 0,
    ///删除按钮
    GLDeleteBtn,
    ///确定按钮
    GLConfirmBtn
};


SlideRuleView *slideRuleView;


@interface SlideRuleView ()<UIScrollViewDelegate>

@end

@implementation SlideRuleView


+ (void)showWithCurrentValue:(CGFloat)currentValue
{
    slideRuleView                             = [SlideRuleView share];
    slideRuleView.dialScrollView.currentValue = currentValue;

    if (![slideRuleView superview]) {
        slideRuleView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240);
        [GL_KEYWINDOW addSubview:slideRuleView];
        
        [UIView animateWithDuration:0.3f animations:^{
            slideRuleView.y = SCREEN_HEIGHT - 240;
        }];
    }
}

+ (void)dismiss
{
    slideRuleView = [SlideRuleView share];
    [UIView animateWithDuration:0.3f animations:^{
        slideRuleView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [slideRuleView removeFromSuperview];
    }];
}

- (void)changeVlaueString
{
    NSString *valueStr               = [NSString stringWithFormat:@"%.1lf mmol/L",self.dialScrollView.currentValue / 10.0f];
    NSDictionary *valueAttributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont systemFontOfSize:24.0f],NSFontAttributeName,nil];
    NSDictionary *unitAttributeDict  = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:18.0f],NSFontAttributeName,nil];
    
    NSMutableAttributedString *valueMutableString = [[NSMutableAttributedString alloc]initWithString:valueStr];
    [valueMutableString addAttributes:valueAttributeDict range:NSMakeRange(0, valueStr.length - 6)];
    [valueMutableString addAttributes:unitAttributeDict  range:NSMakeRange(valueStr.length - 7, 7)];
    _valueLbl.attributedText                      = valueMutableString;
}

- (void)btnClick:(UIButton *)sender
{
    switch (sender.tag - 10) {
        case GLCancelBtn:
            
            break;
        case GLDeleteBtn:
            
            break;
        case GLConfirmBtn:
            
            break;
        default:
            break;
    }
    [SlideRuleView dismiss];
}

- (void)changeCurrentValueClick:(GLButton *)sender
{
    slideRuleView = [SlideRuleView share];
    if (sender == self.addBtn) {
        [SlideRuleView showWithCurrentValue:self.dialScrollView.currentValue + 1];
    } else {
        [SlideRuleView showWithCurrentValue:self.dialScrollView.currentValue - 1];
    }
}

+ (instancetype)share
{
    @synchronized (self) {
        if (!slideRuleView) {
            slideRuleView = [SlideRuleView new];
        }
    }
    
    return slideRuleView;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeVlaueString];
}


#pragma mark - createUI
- (void)createUI
{
    
    self.backgroundColor    = RGB(247, 247, 247);
    self.layer.shadowColor  = RGB(0, 0, 0).CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -3);
    
    [self addSubview:self.dialScrollView];
    [self addSubview:self.hintLbl];
    [self addSubview:self.valueLbl];
    [self addSubview:self.unitLbl];
    [self addSubview:self.addBtn];
    [self addSubview:self.deductBtn];
    
    WS(ws);
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws);
        make.top.equalTo(ws.dialScrollView.mas_bottom).offset(10);
    }];
    
    [self.valueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws);
        make.top.equalTo(ws).offset(69.1);
    }];
    
    [self.deductBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.dialScrollView).offset(30);
        make.centerY.equalTo(self.valueLbl);
        make.size.mas_equalTo(CGSizeMake(20 + 30, 20 + 30));
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.dialScrollView.mas_right).offset(-30);
        make.centerY.equalTo(ws.valueLbl);
        make.size.mas_equalTo(CGSizeMake(20 + 30, 20 + 30));
    }];
    
    for (NSInteger i = 0;i < 3;i++) {
        GLButton *btn = [GLButton new];
        [self addSubview:btn];
        
        [btn setTitle:@[@"取消",@"删除",@"确定"][i] forState:UIControlStateNormal];
        [btn setTitleColor:@[RGB(102, 102, 102),RGB(255, 51, 0),RGB(0, 204, 153)][i] forState:UIControlStateNormal];
        [btn setFont:GL_FONT(14)];
        [btn setTextAlignment:NSTextAlignmentCenter];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:10 + i];
        
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws).offset(9);
            make.size.mas_equalTo(CGSizeMake(50, 40));
            switch (i) {
                case 0:
                    make.left.equalTo(ws).offset(20);
                    break;
                case 1:
                    make.centerX.equalTo(ws);
                    break;
                case 2:
                    make.right.equalTo(ws.mas_right).offset(-20);
                    break;
                default:
                    break;
            }
        }];
    }
    
    [self changeVlaueString];
}

- (TRSDialScrollView *)dialScrollView
{
    if (!_dialScrollView) {
        _dialScrollView                        = [[TRSDialScrollView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 275)/2, 128, 275, 60)];
        _dialScrollView.borderColor            = TCOL_MAIN;
        _dialScrollView.borderWidth            = 2;
        _dialScrollView.cornerRadius           = 8;
        _dialScrollView.minorTicksPerMajorTick = 10; //主刻度包含的小刻度数
        _dialScrollView.majorTickLength        = 30; //主刻度长度
        _dialScrollView.majorTickWidth         = 2;  //主刻度宽度
        _dialScrollView.majorTickColor         = TCOL_SUBHEADTEXT; //主刻度色值
        _dialScrollView.minorTickDistance      = 4;  //小刻度之间的间隔
        _dialScrollView.minorTickLength        = 15; //小刻度长度
        _dialScrollView.minorTickWidth         = 2;  //小刻度宽度
        _dialScrollView.minorTickColor         = TCOL_SUBHEADTEXT; //小刻度色值
        _dialScrollView.labelFillColor         = TCOL_SUBHEADTEXT;
        _dialScrollView.labelFont              = GL_FONT(12);
        _dialScrollView.zoom                   = 10;
        _dialScrollView.backgroundColor        = RGB(255, 255, 255);
        _dialScrollView.delegate               = self;
        
        [_dialScrollView setDialRangeFrom:0 to:330];
        _dialScrollView.currentValue           = 100;

        [_dialScrollView addSubview:self.scaleIV];
        
        [self.scaleIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_dialScrollView);
            make.centerX.equalTo(_dialScrollView).offset(-0.5);
        }];
    }
    return _dialScrollView;
}

- (UIImageView *)scaleIV
{
    if (!_scaleIV) {
        _scaleIV = [UIImageView new];
        [_scaleIV setImage:GL_IMAGE(@"指针")];
        
    }
    return _scaleIV;
}

- (UILabel *)unitLbl
{
    if (!_unitLbl) {
        _unitLbl               = [UILabel new];
        _unitLbl.font          = GL_FONT(18);
        _unitLbl.textColor     = TCOL_MAIN;
        _unitLbl.textAlignment = NSTextAlignmentCenter;
        _unitLbl.text          = @"mmol/L";
    }
    return _unitLbl;
}

- (UILabel *)valueLbl
{
    if (!_valueLbl) {
        _valueLbl               = [UILabel new];
        _valueLbl.font          = GL_FONT(24);
        _valueLbl.textColor     = TCOL_MAIN;
        _valueLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _valueLbl;
}

- (UILabel *)hintLbl
{
    if (!_hintLbl) {
        _hintLbl               = [UILabel new];
        _hintLbl.font          = GL_FONT(12);
        _hintLbl.textColor     = TCOL_SUBHEADTEXT;
        _hintLbl.textAlignment = NSTextAlignmentCenter;
        _hintLbl.text          = @"滑动标尺设置血糖值";
    }
    return _hintLbl;
}

- (GLButton *)deductBtn
{
    if (!_deductBtn) {
        _deductBtn = [GLButton new];
        [_deductBtn setGraphicLayoutState:PICCENTER];
        [_deductBtn setImage:GL_IMAGE(@"减") forState:UIControlStateNormal];
        [_deductBtn addTarget:self action:@selector(changeCurrentValueClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deductBtn;
}

- (GLButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [GLButton new];
        [_addBtn setGraphicLayoutState:PICCENTER];
        [_addBtn setImage:GL_IMAGE(@"加") forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(changeCurrentValueClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

@end
