//
//  XueTangLiShiZhiCellTableViewCell.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/16.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLTableViewCell.h"
#import "XueTangZhiEntity.h"

@interface XueTangLiShiZhiCellTableViewCell : GLTableViewCell

///获取数值时间
@property (nonatomic,strong) UILabel *timeLbl;
///对应血糖值
@property (nonatomic,strong) UILabel *bloodValueLbl;
///对应电流值
@property (nonatomic,strong) UILabel *currentValueLbl;

@end
