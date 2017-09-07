//
//  SlideRuleView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"
#import "TRSDialScrollView.h"

typedef void(^GetSelectValue)(CGFloat value);
typedef void(^GetSlectReferenceValueDic)(NSDictionary *valueDic);
typedef void(^DeleteValue)();

typedef NS_ENUM(NSInteger,GLSlideRuleViewType) {
    GLSlideRuleViewFingerBloodType = 0, /**< 指尖血 */
    GLSlideRuleViewReferenceBloodType   /**< 参比血糖 */
};

@interface SlideRuleView : UIView

///标尺
@property (nonatomic,strong) TRSDialScrollView *dialScrollView;

///提示标签
@property (nonatomic,strong) UILabel *hintLbl;

///血糖单位
@property (nonatomic,strong) UILabel *unitLbl;

///标尺刻度线
@property (nonatomic,strong) UIImageView *scaleIV;

///当前选中的血糖值
@property (nonatomic,strong) UILabel *valueLbl;

///加号按钮
@property (nonatomic,strong) GLButton *addBtn;

///减号按钮
@property (nonatomic,strong) GLButton *deductBtn;

@property (nonatomic,copy) GetSelectValue selectValue;

@property (nonatomic,copy) DeleteValue deleteValue;

@property (nonatomic,strong) UIView *mainView; /**< 存放组件的主View */

@property (nonatomic,assign,readonly) GLSlideRuleViewType type;

@property (nonatomic,strong) UILabel *titleLbl; /**< 正上方标题标签 */

@property (nonatomic,strong) GLButton *timeBtn; /**< 时间选择按钮 */

@property (nonatomic,copy) GetSlectReferenceValueDic getSlectReferenceValueDic;

//显示滑尺
- (void)showWithCurrentValue:(CGFloat)currentValue;
//关闭滑尺
- (void)dismiss;

//提交值
- (void)getValue:(GetSelectValue)selectValue;

- (void)getSlectReferenceValueDic:(GetSlectReferenceValueDic)valueDic;

- (void)deleteValue:(DeleteValue)deleteValue;

+ (instancetype)slideRuleViewWithType:(GLSlideRuleViewType)type;

@end
