//
//  FuWuSearchBarView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/30.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"

typedef void(^SearchTFClick)();

@interface FuWuSearchBarView : GLView

///搜索框
@property (nonatomic,strong) GLTextField *searchTF;

@property (nonatomic,copy) SearchTFClick searchTFClick;

@end
