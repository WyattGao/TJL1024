//
//  XueTangTargerViewController.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/27.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLViewController.h"

typedef void(^RefreshTarget)();

@interface XueTangTargerViewController : GLViewController

///刷新主页面预警值
@property (nonatomic,copy) RefreshTarget refreshTarget;

//提示标签
@property (nonatomic,strong) UILabel *hintLbl;

@property (nonatomic,strong) UILabel *errorLbl;

@property (nonatomic,strong) GLButton *highTargetBtn; /**< 高预警值输入框 */

@property (nonatomic,strong) GLButton *lowTargetBtn; /**< 低预警值输入框 */

@property (nonatomic,strong) GLNextBtn *finishBtn;/**< 完成 */

@end
