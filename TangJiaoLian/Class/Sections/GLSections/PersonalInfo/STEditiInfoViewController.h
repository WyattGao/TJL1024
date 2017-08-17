//
//  STEditiInfoViewController.h
//  Diabetes
//
//  Created by 高临原 on 16/3/4.
//  Copyright © 2016年 hlcc. All rights reserved.
//  修改信息页

#import "GLViewController.h"

typedef enum{
    NikeName      = 0,/**< 设置昵称 */
    BingDingPhone = 1,/**< 绑定手机号 */
} EDITIVCSTYLE;

@class STEditiInfoViewController;
@protocol EditiInfoDelegate <NSObject>

- (void)getEditiContent:(NSString *)editiStr;

@end

@interface STEditiInfoViewController : GLViewController

@property (nonatomic,weak) id<EditiInfoDelegate> delegate;

@property (nonatomic,assign) EDITIVCSTYLE editiStyle;  /**< 编辑页面的类型 */

- (instancetype)initWithType:(EDITIVCSTYLE)style;

@property (nonatomic,copy) NSString *tf1Str;
@property (nonatomic,copy) NSString *tf2Str;

@end
