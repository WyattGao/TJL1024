//
//  GLTableViewCell.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLTableViewCell.h"

@implementation GLTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI{}

- (void)addSubviewByCellFrame:(UIView *)view
{
    [self.contentView addSubview:view];
    
    WS(ws);
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(ws);
        make.center.equalTo(ws);
    }];
}

@end
