//
//  BloodGlucoseDateSelectionView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/9/11.
//  Copyright © 2017年 高临原♬. All rights reserved.
//
//  详细记录

#import "GLView.h"
#import "STSelectDateView.h"

typedef void(^TimeSelected)(NSDate *startDate,NSDate *endDate);

@interface BloodGlucoseDateSelectionView : UIView

@property (nonatomic,strong) GLView            *mainView;/**< 主View */

@property (nonatomic,strong) GLButton          *leftBtn;/**< 左箭头 */

@property (nonatomic,strong) GLButton          *rightBtn;/**< 右箭头 */

@property (nonatomic,strong) GLButton          *dateBtn;/**< 日历按钮 */

@property (nonatomic,assign) BOOL              isShow;/**< 页面是否在显示中 */

@property (nonatomic,strong) STSelectDateView  *selectDeteView;/**< 日期选择View */

@property (nonatomic,copy  ) TimeSelected       timeSelected;


+ (instancetype)bloodGlucoseDateSelectionViewWithStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate;

- (void)showInView:(UIView *)view;

- (void)dismiss;

@end
