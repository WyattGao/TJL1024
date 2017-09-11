//
//  BloodGlucoseDateSelectionView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/9/11.
//  Copyright © 2017年 高临原♬. All rights reserved.
//
//  详细记录

#import "GLView.h"

@interface BloodGlucoseDateSelectionView : UIView

@property (nonatomic,strong) GLView   *mainView;/**< 主View */

@property (nonatomic,strong) GLButton *leftBtn;/**< 左箭头 */

@property (nonatomic,strong) GLButton *rightBtn;/**< 右箭头 */

@property (nonatomic,strong) GLButton *dateBtn;/**< 日历按钮 */

@property (nonatomic,copy)   NSDate *date;

@property (nonatomic,assign) BOOL isShow;

+ (instancetype)bloodGlucoseDateSelectionViewWithDate:(NSDate *)date;

- (void)showInView:(UIView *)view;

- (void)dismiss;

@end
