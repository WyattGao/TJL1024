//
//  GLNextBtn.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/25.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLButton.h"

typedef NS_ENUM(NSInteger,GLNextBtnType){
    GLNextBtnNormalType  = 0,
    GLFinishBtnNomalType = 1,
    GLSubmitBtnNormalType
};

typedef void(^GLNextBtnClick)();

@interface GLNextBtn : GLButton

- (instancetype)initWithType:(GLNextBtnType)type;

@property (nonatomic,copy) GLNextBtnClick glNextBtnClick;

@end
