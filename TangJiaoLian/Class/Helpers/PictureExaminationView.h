//
//  PictureExaminationView.h
//  Diabetes
//
//  Created by 高临原 on 15/11/20.
//  Copyright © 2015年 hlcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol picRemDelegate <NSObject>

@optional

- (void)picRemWithTag:(NSInteger)remPicTag;

@end

@interface PictureExaminationView : UIView

- (instancetype)initWithPics:(NSArray *)picArr Withindex:(NSInteger)index;

@property (nonatomic,weak) id<picRemDelegate> delegate;

@property (nonatomic,strong) UIButton *yBtn;

@end
