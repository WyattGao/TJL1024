//
//  WoTableView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/30.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLTableView.h"
#import "WoInfoHeaderView.h"
#import "WoInfoFooterView.h"

@interface WoTableView : GLTableView

@property (nonatomic,strong) WoInfoHeaderView *infoHeaderView;

@property (nonatomic,strong) WoInfoFooterView *infoFooterView;

@end
