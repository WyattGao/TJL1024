//
//  GLPicReincarnationView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/4/1.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"

typedef void(^PicReClick)(NSInteger clickIndex);

@interface GLPicReincarnationView : GLView

- (instancetype)initWithFrame:(CGRect)frame WithPics:(NSArray *)picsArr WithTitles:(NSArray *)titlesArr;
- (void)setImageArr:(NSArray *)imageArr WithTilteArr:(NSArray *)titleArr;
/**
 图片点击回调
 */
- (void)PicReClick:(PicReClick)picReClick;

@property (nonatomic,strong) UIPageControl *pageContr;
@property (nonatomic,copy) PicReClick picReClick;

@end
