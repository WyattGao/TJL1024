//
//  GLReloadView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/4/11.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"

#define GL_ReloadView [GLReloadView share]

typedef void(^Reload)();

@interface GLReloadView : GLView

@property (nonatomic,strong) UIButton *reloadBtn; /**< 重新加载按钮 */
@property (nonatomic,copy) Reload reload; /**< 刷新回调 */

+ (instancetype)share;
- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
