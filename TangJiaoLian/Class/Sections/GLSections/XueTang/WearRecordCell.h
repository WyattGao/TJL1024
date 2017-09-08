//
//  WearRecordCell.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/31.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLTableViewCell.h"
#import "WearRecordEntity.h"

@interface WearRecordCell : GLTableViewCell

@property (nonatomic,strong) GLButton *dataAnalysisBtn;/**< 数据分析 */

@property (nonatomic,strong) GLButton *detailedRecordBtn;/**< 详细记录 */


@end
