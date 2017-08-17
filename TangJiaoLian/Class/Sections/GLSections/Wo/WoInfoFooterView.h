//
//  WoInfoFooterView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/26.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"

typedef void(^ExitBtnClick)();

@interface WoInfoFooterView : GLView

@property (nonatomic,strong) GLButton *exitBtn;

@property (nonatomic,copy) ExitBtnClick exitBtnClick;

@end
