//
//  STSelectDateView.h
//  Diabetes
//
//  Created by 高临原 on 15/12/9.
//  Copyright © 2015年 hlcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STSelectDateView;

@protocol SelecteDateDelegate <NSObject>

@optional
- (void)getSelecteDataYeaer:(NSString *)Year WithMoth:(NSString *)Moth WithDay:(NSString *)day;

- (void)getSelecteDataWithDate:(NSDate *)date;

- (void)getSelecteDataWithSelecteView:(STSelectDateView *)selDateView;

@end

typedef NS_ENUM(NSInteger) {
    Default        = 0,
    ISAge          = 1,
    OnlyYeaer      = 2,/**< 年数 */
    DateTime       = 3,
    ParticularYear = 4/**< 年份 */
} SELECT_DATAVIEW_TYPE;


@interface STSelectDateView : UIView

- (instancetype)initWithType:(SELECT_DATAVIEW_TYPE)type;

- (instancetype)initDatePickerView;

- (void)show;

- (void)dismiss;

@property (nonatomic,weak) id<SelecteDateDelegate> delegate;

@property (nonatomic) BOOL isOnlyYeaer;

@property (nonatomic) BOOL isOnlyAge;

@property (nonatomic) BOOL isParticularYear;

@property (nonatomic,copy) NSString *selectDay;
@property (nonatomic,copy) NSString *selectYear;
@property (nonatomic,copy) NSString *selectMoth;
@property (nonatomic,copy) NSDate   *selectDeate;

@property (nonatomic,strong) UIView *datePickView;

@property (nonatomic,strong) UIButton *backGroundBtn;

@property (nonatomic) BOOL replaceRemoveWithHidden;

@end
