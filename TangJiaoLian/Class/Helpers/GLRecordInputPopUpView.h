//
//  GLInputPopUpView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/24.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"

typedef NS_ENUM(NSInteger,GLInputPopUpViewType) {
    GLPopUpViewBlood,
    GLPopUpViewTarget
};

typedef void(^PopUpViewSubmit)(NSDictionary *dic);

@interface GLRecordInputPopUpView : GLView

- (instancetype)initWithPopUpViewType:(GLInputPopUpViewType)type;
- (void)show;
- (void)close;
- (void)popUpViewSubmit:(PopUpViewSubmit)popUpViewSubmit;

@property (nonatomic,copy) PopUpViewSubmit popUpViewSubmit;
@property (nonatomic,assign) GLInputPopUpViewType type;



@end
