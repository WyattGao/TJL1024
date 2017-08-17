//
//  GLPopupView.h
//  newCGM
//
//  Created by 高临原 on 2016/11/11.
//  Copyright © 2016年 xuqidong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordEntity.h"

@interface GLPopupView : UIView

/**
 创建一个单例
 
 @return 返回一个单例
 */
+ (instancetype)share;

/**
 根据文字初始化一个弹出气泡

 @param text 气泡内文字
 @return 返回一个含一段文字的气泡
 */
+ (void)showBloodValueForView:(UIView *)view WithText:(NSString *)text;

+ (void)showRecordValueForView:(UIView *)view WithType:(RecordType)type WithEntity:(RecordEntity *)entity;

+ (void)dismiss;

@property (nonatomic,copy) NSString *popText;


@end

