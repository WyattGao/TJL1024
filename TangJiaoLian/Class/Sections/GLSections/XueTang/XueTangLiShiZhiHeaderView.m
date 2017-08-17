//
//  XueTangLiShiZhiHeaderView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/16.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangLiShiZhiHeaderView.h"

@interface XueTangLiShiZhiHeaderView ()



@end

@implementation XueTangLiShiZhiHeaderView

- (void)createUI
{
    self.backgroundColor = TCOL_BG;
    
    for (NSInteger i = 0;i < 3;i++) {
        UILabel *lbl      = [UILabel new];
        lbl.text          = @[@"时间",@"血糖值",@"电流值"][i];
        lbl.font          = GL_FONT(14);
        lbl.textColor     = TCOL_NORMALETEXT;
        lbl.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:lbl];
        
        WS(ws);
        
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH/3);
            make.left.equalTo(ws).offset(SCREEN_WIDTH/3 * i);
            make.centerY.equalTo(ws);
        }];
    }
}

@end
