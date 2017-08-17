//
//  SpringsBoxView.h
//  Diabetes
//
//  Created by 高临原 on 15/11/17.
//  Copyright © 2015年 hlcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpringsBoxView;
@protocol SpringsBoxViewDelegate <NSObject>

@required
- (void)springsBoxViewSelectedWhitNumStr:(NSString *)numStr;
@end

@protocol SpringsBoxViewBLDelegate <NSObject>

- (void)springsBoxViewSelectedWhitBoxView:(SpringsBoxView *)BoxView;

@end

@interface SpringsBoxView : UIView

@property (nonatomic,weak) id<SpringsBoxViewDelegate> delegate;
@property (nonatomic,weak) id<SpringsBoxViewBLDelegate> delegate2;
@property (nonatomic) BOOL isHideUnit;
@property (nonatomic,copy) NSString *leftStr;
@property (nonatomic,copy) NSString *rightStr;

- (void)show;

- (instancetype)initWithTitle:(NSString *)title Num:(NSInteger )num lMiniScope:(NSInteger )mini TolMaxScope:(NSInteger)max rMiniScope:(NSInteger)rMini TorMaxScope:(NSInteger)rMax Unit:(NSString *)unit DetailsArr:(NSArray *)detailsArr;

@end
