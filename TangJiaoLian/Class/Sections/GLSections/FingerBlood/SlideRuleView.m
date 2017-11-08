//
//  SlideRuleView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//
///滑尺

#import "SlideRuleView.h"
#import "STSelectDateView.h"

SlideRuleView *slideRuleView;

@interface SlideRuleView ()<UIScrollViewDelegate,SelecteDateDelegate>

@property (nonatomic,assign,readwrite) GLSlideRuleViewType type;

@property (nonatomic,strong) GLButton *cancelBtn;/**< 取消按钮 */

@property (nonatomic,strong) GLButton *deleteBtn;/**< 删除按钮 */

@property (nonatomic,strong) GLButton *confirmBtn;/**< 确定按钮 */

@property (nonatomic,strong) STSelectDateView *selectDateView;/**< 时间选择 */

@property (nonatomic,strong) UISelectionFeedbackGenerator *generator; /**< 触觉反馈 */

@end

@implementation SlideRuleView

- (void)showWithCurrentValue:(CGFloat)currentValue
{   
    self.dialScrollView.currentValue = currentValue;

    [GL_KEYWINDOW addSubview:self];
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.3f);
        self.mainView.y      = SCREEN_HEIGHT - 240;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.0f);
        self.mainView.y      = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
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
    
//    [self.generator selectionChanged];
}

#pragma mark - 点击事件
//提交按钮点击事件
- (void)confirmButtonClick:(GLButton *)sender
{
    if (self.getSlectReferenceValueDic) {
        NSMutableDictionary *valueDic = [NSMutableDictionary dictionary];
        [valueDic setValue:[NSString stringWithFormat:@"%.1lf",self.dialScrollView.currentValue/10.0f] forKey:@"value"];
        [valueDic setValue:[self.timeBtn.lbl.text stringByAppendingString:@":00"] forKey:@"collectedtime"];
        
        self.getSlectReferenceValueDic(valueDic);
    }
    
    if (self.selectValue) {
        self.selectValue(_dialScrollView.currentValue);
    }
    
    [self dismiss];
}

//删除按钮点击事件
- (void)deleteButtionClick:(UIButton *)sender
{
    if (self.deleteValue) {
        self.deleteValue();
    }
    
    [self dismiss];
}

- (void)backgroundViewClick:(UIGestureRecognizer *)gesture
{
    [self dismiss];
}

- (void)changeCurrentValueClick:(GLButton *)sender
{
    if (sender == self.addBtn) {
        [self showWithCurrentValue:self.dialScrollView.currentValue + 1];
    } else {
        [self showWithCurrentValue:self.dialScrollView.currentValue - 1];
    }
}

- (void)timeBtnClick:(GLButton *)sender
{
    self.selectDateView.hidden = false;
}

#pragma mark - block回调事件
- (void)getValue:(GetSelectValue)selectValue
{
    self.selectValue = selectValue;
}

- (void)deleteValue:(DeleteValue)deleteValue
{
    self.deleteValue = deleteValue;
}

- (void)getSlectReferenceValueDic:(GetSlectReferenceValueDic)valueDic
{
    self.getSlectReferenceValueDic = valueDic;
}

#pragma mark - STSelectDateViewDelegate
- (void)getSelecteDataWithDate:(NSDate *)date
{
    _timeBtn.text = [date toString:@"yyyy-MM-dd HH:mm"];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeVlaueString];
}


#pragma mark - createUI
+ (instancetype)slideRuleViewWithType:(GLSlideRuleViewType)type
{
    slideRuleView = [SlideRuleView new];
    if (slideRuleView) {
        slideRuleView.type = type;
        [slideRuleView createUI];
    }
    return slideRuleView;
}

- (void)createUI
{
    self.frame           = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = RGBA(0, 0, 0, 0.0f);
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundViewClick:)];
    [self addGestureRecognizer:gesture];
    
    [self addSubview:self.mainView];
    [self.mainView addSubview:self.dialScrollView];
    [self.mainView addSubview:self.hintLbl];
    [self.mainView addSubview:self.valueLbl];
    [self.mainView addSubview:self.unitLbl];
    [self.mainView addSubview:self.addBtn];
    [self.mainView addSubview:self.deductBtn];
    [self.mainView addSubview:self.cancelBtn];
    [self.mainView addSubview:self.confirmBtn];
    
    WS(ws);
    
    [ws.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws);
        make.bottom.equalTo(ws.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 240));
    }];
    
    [self.hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws);
        make.top.equalTo(ws.dialScrollView.mas_bottom).offset(10);
    }];
    
    [self.valueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws);
        make.top.equalTo(ws.mainView).offset(69.1);
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
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mainView).offset(9);
        make.size.mas_equalTo(CGSizeMake(50, 40));
        make.left.equalTo(ws).offset(20);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.cancelBtn);
        make.size.equalTo(ws.cancelBtn);
        make.right.equalTo(ws).offset(-20);
    }];
    
    switch (self.type) {
        case GLSlideRuleViewFingerBloodType: //指尖血
        {
            [self.mainView addSubview:self.deleteBtn]; //添加删除按钮
            [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(ws.mainView);
                make.top.equalTo(ws.cancelBtn);
                make.size.equalTo(ws.cancelBtn);
            }];
            break;
        }
        case GLSlideRuleViewReferenceBloodType: //参比血糖
        {
            [self.mainView addSubview:self.titleLbl]; //添加标题
            [self.mainView addSubview:self.timeBtn];
            [self addSubview:self.selectDateView];
            
            [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(ws.mainView).offset(26);
                make.centerX.equalTo(ws.mainView);
            }];
            [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(ws.titleLbl.mas_bottom).offset(0);
                make.size.mas_equalTo(CGSizeMake(150, 30));
                make.centerX.equalTo(ws);
            }];
            [self.selectDateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(ws.mainView.mas_top).offset(-10);
                make.centerX.equalTo(ws);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
            }];

            break;
        }
        case GLSlideRuleViewTargetType:
        {
            [self.mainView addSubview:self.titleLbl]; //添加标题
            [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(ws.mainView).offset(26);
                make.centerX.equalTo(ws.mainView);
            }];
        }
            break;
        default:
            break;
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

- (UIView *)mainView
{
    if (!_mainView) {
        _mainView                        = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 240)];
        _mainView.backgroundColor        = [UIColor whiteColor];
        _mainView.backgroundColor        = RGB(247, 247, 247);
        _mainView.layer.shadowColor      = RGB(0, 0, 0).CGColor;
        _mainView.layer.shadowOffset     = CGSizeMake(0, -3);
        _mainView.userInteractionEnabled = true; //防止点击mainview关闭窗口
    }
    return _mainView;
}

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        _titleLbl               = [UILabel new];
        _titleLbl.text          = @"参比血糖";
        _titleLbl.font          = GL_FONT(18);
        _titleLbl.textColor     = RGB(51, 51, 51);
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

- (GLButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [GLButton new];
        _cancelBtn.font = GL_FONT(14);
        _cancelBtn.text = @"取消";
        [_cancelBtn setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (GLButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn           = [GLButton new];
        _deleteBtn.font      = GL_FONT(14);
        _deleteBtn.text      = @"删除";
        [_deleteBtn setTitleColor:RGB(255, 51, 0) forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteButtionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (GLButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn           = [GLButton new];
        _confirmBtn.font      = GL_FONT(14);
        _confirmBtn.text      = @"确定";
        [_confirmBtn setTitleColor:TCOL_MAIN forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (GLButton *)timeBtn
{
    if (!_timeBtn) {
        _timeBtn           = [GLButton new];
        _timeBtn.text      = [[NSDate date] toString:@"yyyy-MM-dd HH:mm"];
        _timeBtn.font      = GL_FONT(14);
        [_timeBtn setTitleColor:TCOL_RINGTIMEWAR forState:UIControlStateNormal];
        [_timeBtn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeBtn;
}

- (STSelectDateView *)selectDateView
{
    if (!_selectDateView) {
        _selectDateView                         = [[STSelectDateView alloc]initWithType:DateTime];
        _selectDateView.delegate                = self;
        _selectDateView.backGroundBtn.hidden    = true;
        _selectDateView.hidden                  = true;
        _selectDateView.replaceRemoveWithHidden = true;
    }
    return _selectDateView;
}

- (UISelectionFeedbackGenerator *)generator
{
    if (!_generator) {
        _generator = [UISelectionFeedbackGenerator new];
        [_generator prepare];
    }
    return _generator;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLbl.text = title;
}


@end
