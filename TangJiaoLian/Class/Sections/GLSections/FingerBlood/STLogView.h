//
//  STLogView.h
//  Diabetes
//
//  Created by xuqidong on 16/3/1.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol changeType <NSObject>

- (void)changeTypeIndex:(NSInteger)index;

@end

typedef void(^typeIndex) (NSInteger);

@interface STLogView : UIView

@property (nonatomic, assign)id <changeType> delegate;
@property (nonatomic, assign) id target;
@property(nonatomic, strong)typeIndex index;

//主main
+ (UIScrollView*)MainScrollView:(id)tager;
//血糖，饮食，用药，运动View
//- (UIView*)secondTypeView:(id)target andFrame:(CGRect)frame;
//饮食用药的header
+ (UIView*)eatHeaderViewTime:(NSString*)time andIndex:(NSInteger)index;
//血糖表格的表头
+ (UIView*)makeHeaderView;
//绘制表格
+ (UIScrollView*)makeBloodSugarScrollview:(UIScrollView*)TypeScrollview andSelectYear:(int)year andMonth:(int)month andData:(NSArray*)data;

//检测的heade
+ (UIView*)jianCeHeaderTitle:(NSString*)title;

@end
