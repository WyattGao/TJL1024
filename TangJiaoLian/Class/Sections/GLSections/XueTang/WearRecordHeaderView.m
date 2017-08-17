//
//  WearRecordHeaderView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/31.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WearRecordHeaderView.h"

@interface WearRecordHeaderView ()

@property (nonatomic,strong) UILabel *cgmNameLbl;
@property (nonatomic,strong) UILabel *startLbl;
@property (nonatomic,strong) UILabel *endLbl;

@end

@implementation WearRecordHeaderView

- (void)createUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    WS(ws);

    for (NSInteger i = 0;i < 3;i++) {
        UILabel *lbl = [UILabel new];
        [self addSubview:lbl];
        
        lbl.font          = GL_FONT(16);
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor     = RGB(153, 153, 153);
        lbl.text          = @[@"发射器编号",@"开始时间",@"结束时间  "][i];
        
        
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws);
            if (i == 2) {
                make.right.equalTo(ws.mas_right).offset(-GL_IP6_W_RATIO(37.9));
            } else {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3, 50));
                make.left.equalTo(ws).offset(SCREEN_WIDTH/3 * i);
            }
        }];
    }
    
    UIView *line         = [UIView new];
    line.backgroundColor = TCOL_LINE;
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
}

@end
