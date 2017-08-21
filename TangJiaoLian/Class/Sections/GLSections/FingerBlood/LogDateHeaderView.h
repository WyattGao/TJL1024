//
//  LogDateHeaderView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/16.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"

typedef void(^DateChange)();

@interface LogDateHeaderView : GLView

///日期左标签
@property (nonatomic,strong) GLButton *leftDateBtn;

///日期右标签
@property (nonatomic,strong) GLButton *rightDateBtn;

@property (nonatomic,copy) DateChange dateChange;


@end
