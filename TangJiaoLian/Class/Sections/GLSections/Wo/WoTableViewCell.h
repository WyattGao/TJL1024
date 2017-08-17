//
//  WoTableViewCell.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/22.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLTableViewCell.h"
#import "WoTableViewEntity.h"

@interface WoTableViewCell : GLTableViewCell

@property (nonatomic,strong) UIImageView *iconIV;       /**< 图标 */
@property (nonatomic,strong) UILabel     *titleLbl;     /**< 名称 */
@property (nonatomic,strong) UIImageView *rightArrowIV; /**< 右箭头 */
@property (nonatomic,strong) UIView      *lineView;

@end
