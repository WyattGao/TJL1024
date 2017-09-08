//
//  GLNextBtn.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/25.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLNextBtn.h"

@implementation GLNextBtn

- (instancetype)initWithType:(GLNextBtnType)type
{
    self = [super init];
    if (self) {
        self.frame           = CGRectMake(40/2, 0, SCREEN_WIDTH - 40, 40);
        self.backgroundColor = TCOL_MAIN;
        self.font            = GL_FONT(16);
        self.cornerRadius    = 5;
        [self setTitleColor:TCOL_WHITETEXT forState:UIControlStateNormal];
        [self addTarget:self action:@selector(glNextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setBackgroundColor:TCOL_MAIN forState:UIControlStateSelected];
        [self setBackgroundColor:TCOL_BTNUNAVAILABLE forState:UIControlStateNormal];
        
        switch (type) {
            case GLNextBtnNormalType:
                [self setTitle:@"下一步" forState:UIControlStateNormal];
                break;
            case GLFinishBtnNomalType:
                [self setTitle:@"完成" forState:UIControlStateNormal];
                break;
            case GLSubmitBtnNormalType:
                [self setTitle:@"提交" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    return  self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.userInteractionEnabled = true;
    } else {
        self.userInteractionEnabled = false;
    }
}

- (void)glNextBtnClick:(GLNextBtn *)sender
{
    if (self.glNextBtnClick) {
        self.glNextBtnClick();
    }
}

@end
