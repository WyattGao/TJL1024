//
//  XueTangRecordBtn.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/14.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLButton.h"

typedef NS_ENUM(NSInteger,GLRecordBtnStatus){
    GLRecordBtnNormal = 0,
    ///记录成功
    GLRecordBtnSuccess,
    ///记录成功计时中
    GLRecordBtnTimings
};

@interface XueTangRecordBtn : GLButton

@property (nonatomic,assign) GLRecordBtnStatus status;

@property (nonatomic,strong) UIView *successHintView;

@property (nonatomic,strong) UILabel *hintLbl;

@property (nonatomic,strong) UIImageView *hintIV;

@end
