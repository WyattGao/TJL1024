//
//  WoInfoHeaderView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/30.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"

typedef void(^EditInfoClick)();

@interface WoInfoHeaderView : GLView

///用户头像
@property (nonatomic,strong) UIImageView *userPhotoIV;
///用户姓名标签
@property (nonatomic,strong) UILabel     *userNameLbl;
///编辑信息按钮
@property (nonatomic,strong) GLButton    *editInfoBtn;

@property (nonatomic,copy)   EditInfoClick editInfoClick;

@property (nonatomic,strong) UIImageView *backGroudIV; /**< 背景图 */

@property (nonatomic,strong) UIImageView *userPhotoMaskIV; /**< 头像背景遮罩 */


@end
