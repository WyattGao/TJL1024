//
//  GLPointScroollView.h
//  newCGM
//
//  Created by 高临原 on 2016/12/7.
//  Copyright © 2016年 随糖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQDColor.h"
#import "XQDApi.h"
#import "GLPopupView.h"

@protocol GLPointScrollViewDelegate <NSObject>

- (void)reloadMainSVWithPointX:(CGFloat)pointX;

@end

@interface GLPointScrollView : UIScrollView

@property (nonatomic,strong) XQDColor *xqdColor;

@property (nonatomic,weak) id<GLPointScrollViewDelegate> glPonintDelegate;

-(instancetype)initWithFrame:(CGRect)frame andXQDColor:(XQDColor *)xqdColor;

@end
