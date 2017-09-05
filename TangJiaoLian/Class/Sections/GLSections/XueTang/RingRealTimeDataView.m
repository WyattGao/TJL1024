//
//  RingRealTimeDataView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/9/5.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "RingRealTimeDataView.h"

@implementation RingRealTimeDataView

- (void)setRealTimeLblTextByBloodValue:(NSString *)bloodValue
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[bloodValue stringByAppendingString:@" mmol/L"]];
    [attributedStr addAttribute:NSFontAttributeName
                          value:GL_FONT_BY_NAME(@"Courier", 36.0f)
                          range:NSMakeRange(0, attributedStr.length - 5)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIFont systemFontOfSize:18.0f]
                          range:NSMakeRange(attributedStr.length - 6, 5)];
    
    self.realTimeLbl.attributedText = attributedStr;
}

- (void)createUI
{
    [self addSubview:self.realTimeLbl];
    [self addSubview:self.dataAnalysisBtn];
    
    WS(ws);
    
    [self.realTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
    }];
    
    [self.dataAnalysisBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.realTimeLbl.mas_bottom).offset(20);
        make.centerX.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(70, 24));
    }];
}

- (UILabel *)realTimeLbl
{
    if (!_realTimeLbl) {
        _realTimeLbl               = [UILabel new];
        _realTimeLbl.textColor     = TCOL_BG;
        _realTimeLbl.textAlignment = NSTextAlignmentCenter;
        [self setRealTimeLblTextByBloodValue:@"0.0"];
    }
    return _realTimeLbl;
}

- (GLButton *)dataAnalysisBtn
{
    if (!_dataAnalysisBtn) {
        _dataAnalysisBtn = [GLButton new];
        [_dataAnalysisBtn setFont:GL_FONT(12)];
        [_dataAnalysisBtn setTitleColor:TCOL_HOMETEXTCOLOR forState:UIControlStateNormal];
        [_dataAnalysisBtn setTitle:@"数据分析" forState:UIControlStateNormal];
        [_dataAnalysisBtn setCornerRadius:13.0f];
        [_dataAnalysisBtn setBackgroundColor:TCOL_MAIN forState:UIControlStateNormal];
        [_dataAnalysisBtn setTextAlignment:NSTextAlignmentCenter];
    }
    return _dataAnalysisBtn;
}

@end
