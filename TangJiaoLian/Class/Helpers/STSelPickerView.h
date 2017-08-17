//
//  STSelPickerView.h
//  Diabetes
//
//  Created by 高临原 on 16/3/3.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STSelPickerView;
@protocol GetSelTextDelegate <NSObject>

- (void)getSelText:(STSelPickerView *)picker;

@end

@interface STSelPickerView : UIView

@property (nonatomic,weak) id<GetSelTextDelegate> delegate;

@property (nonatomic,strong) UILabel *myLbl;

- (instancetype)initWithTextArr:(NSArray *)textArr;
- (void)show;

@end
