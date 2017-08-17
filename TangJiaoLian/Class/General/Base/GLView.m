//
//  GLView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"

@implementation GLView

- (instancetype)initWithModel:(GLEntity *)entity
{
    self = [super init];
    if (self) {
        [self createUI];
        [self createData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self createData];
    }
    return self;
}

- (void)createUI{}

- (void)createData{};

- (void)refresh{};

@end
