//
//  XueTangRingTimeView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/8.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"

@interface XueTangRingTimeView : GLView

typedef void(^ConnectBtnClick)();

@property (nonatomic,strong) UILabel *hintLbl; /**< 异常提示 */

@property (nonatomic,strong) GLButton *connectionBtn;

@property (nonatomic,copy) ConnectBtnClick connectBtnClick;

@end
