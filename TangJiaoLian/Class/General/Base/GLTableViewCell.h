//
//  GLTableViewCell.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cellMark = @"cellMark";

@interface GLTableViewCell : UITableViewCell

@property (nonatomic,strong) id entity;

- (void)createUI;

- (void)addSubviewByCellFrame:(UIView *)view;

@end
