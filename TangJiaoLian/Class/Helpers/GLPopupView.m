//
//  GLPopupView.m
//  newCGM
//
//  Created by 高临原 on 2016/11/11.
//  Copyright © 2016年 xuqidong. All rights reserved.
//

#import "GLPopupView.h"
#import "STDietRecordViewController.h"
#import "STMedicationController.h"
#import "STSportController.h"

GLPopupView *popView = nil;

@interface GLPopupView ()

@property (nonatomic,strong) UIImageView  *popIV;/**< 气泡背景 */
@property (nonatomic,strong) UILabel      *popLbl;/**< 气泡文字Lable */
@property (nonatomic,strong) UIImageView  *picIV; /**< 饮食记录的图片 */

@property (nonatomic,assign) RecordType   recordType;/**< 气泡的类型 */
@property (nonatomic,strong) RecordEntity *recordEntity;/**< 记录运动用药饮食的模型数据源 */

@end

@implementation GLPopupView

+ (instancetype)share
{
    @synchronized (self) {
        if (!popView) {
            popView = [GLPopupView new];
            popView.recordType = 0;
        }
    }
    
    return popView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.alpha           = 0;
        self.hidden          = true;
        
        [self addSubview:self.popIV];
        [self.popIV addSubview:self.popLbl];
    }
    return self;
}

- (UILabel *)popLbl
{
    if (!_popLbl) {
        _popLbl               = [UILabel new];
        _popLbl.font          = GL_FONT(13);
        _popLbl.textAlignment = NSTextAlignmentCenter;
    }
    
    return _popLbl;
}

- (UIImageView *)popIV
{
    if(!_popIV) {
        _popIV                        = [UIImageView new];
        _popIV.userInteractionEnabled = true;
        UITapGestureRecognizer *gest  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popIVClick:)];
        [_popIV addGestureRecognizer:gest];
    }
    
    return _popIV;
}

- (UIImageView *)picIV
{
    if (!_picIV) {
        _picIV = [[UIImageView alloc]initWithImage:GL_IMAGE(@"图片占位")];
    }
    return _picIV;
}

- (void)setPopText:(NSString *)popText
{
    _popText = popText;
    
    _popLbl.text = popText;
}

+ (void)showBloodValueForView:(UIView *)view WithText:(NSString *)text
{
    popView = [GLPopupView share];
    popView.recordType = 0;
    
    popView.popIV.userInteractionEnabled = true;
    
    if (text.length) {
        if (!popView.hidden) {
            [popView removeFromSuperview];
        }
        
        [[view superview] addSubview:popView];
        
        popView.popLbl.text          = text;
        popView.popLbl.textColor     = RGB(255, 255, 255);
        popView.popLbl.textAlignment = NSTextAlignmentCenter;
        
        popView.popIV.image          = GL_IMAGE(@"参比血糖-pop");
        popView.hidden               = false;
        
        CGFloat tmpX = view.x - [popView.popLbl getLabelWidth]/2;
        
        [popView.popIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(XT(58), XT(66)));
            make.center.equalTo(popView);
        }];
        
        popView.alpha = 0;
        [UIView animateWithDuration:0.3f animations:^{
            [popView layoutIfNeeded];
            popView.alpha = 1;
        }];
        
        [popView.popLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(popView.popIV).offset(5);
            make.centerX.equalTo(popView.popIV);
        }];
        
        [popView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(popView.popIV);
            make.bottom.equalTo(view.mas_top).offset(10);
            if (tmpX <= 0) {
                make.left.mas_equalTo(0);
            } else {
                make.centerX.equalTo(view);
            }
        }];
    }
}

+ (void)showRecordValueForView:(UIView *)view WithType:(RecordType)type WithEntity:(RecordEntity *)entity
{
    popView = [GLPopupView share];
    
    popView.recordType = type;
    popView.recordEntity = entity;
    
    popView.popIV.userInteractionEnabled = true;
    
    if (!popView.hidden) {
        [popView removeFromSuperview];
    }
    
    [[view superview] addSubview:popView];
    
    __block NSString *tipStr = [NSString string];
    switch (type) {
        case DiningRecord: /**< 用餐 */
        {
            tipStr                   = entity.diningEntity.DIETTYPE;
            popView.popIV.image      = GL_IMAGE(@"饮食弹框");
            popView.popLbl.textColor = RGB(182, 153, 235);
        }
            break;
        case SportsRecord: /**< 运动 */
            if ([entity.sportsEnttiy.MOTIONTYPE isEqualToString:@"计步器"]) {
                tipStr = [NSString stringWithFormat:@"%@ %@步",entity.sportsEnttiy.MOTIONTYPE,entity.sportsEnttiy.STEPSNUM];
                popView.popIV.userInteractionEnabled = false;
            } else {
                tipStr = entity.sportsEnttiy.MOTIONTYPE;
            }
            popView.popIV.image      = GL_IMAGE(@"运动弹框");
            popView.popLbl.textColor = RGB(244, 182, 76);
            break;
        case MedicateRecord: /**< 用药 */
        {
            popView.popIV.image      = GL_IMAGE(@"用药弹框");
            popView.popLbl.textColor = RGB(46, 215, 184);
        }
            break;
        case InsulinRecord: /**< 胰岛素 */
            popView.popIV.image      = GL_IMAGE(@"胰岛素弹框");
            popView.popLbl.textColor = RGB(240, 123, 221);
            break;
        default:
            break;
    }
    
    //用药和胰岛素
    if (type == MedicateRecord || type == InsulinRecord) {
        [entity.medicateEntity.DETAIL enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx) {
                tipStr = [tipStr stringByAppendingString:[NSString stringWithFormat:@"\n%@",[obj getStringValue:@"NAME"]]];
            } else {
                tipStr = [obj getStringValue:@"NAME"];
            }
        }];
    }
    
    popView.popIV.image = [popView.popIV.image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    
    popView.popLbl.width         = 70;
    popView.popLbl.text          = tipStr;
    popView.popLbl.numberOfLines = 0;
    popView.popLbl.textAlignment = NSTextAlignmentCenter;
    
    popView.hidden = false;
    popView.alpha = 0;
    [UIView animateWithDuration:0.3f animations:^{
        popView.alpha = 1;
    }];
    
    CGFloat tmpX = view.x - 70/2;
    
    [popView.popLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(popView).offset(1);
        make.width.mas_equalTo(70);
        make.centerX.equalTo(popView.popIV);
    }];
    
    //饮食记录如果包含图片则显示第一张图片
    if (type == DiningRecord && entity.diningEntity.DIETPIC.count) {
        
        [popView.picIV sd_setImageWithURL:GL_URL([entity.diningEntity.DIETPIC firstObject])];
        [popView addSubview:popView.picIV];
        
        [popView.picIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(popView.popLbl.mas_bottom).offset(2);
            make.size.mas_equalTo(CGSizeMake(68, 68));
            make.centerX.equalTo(popView.popIV);
        }];
        
        [popView.popIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(73, [popView.popLbl getLabelHeight] + 6 + 72));
            make.center.equalTo(popView);
        }];
    } else {
        [popView.picIV removeFromSuperview];
        
        [popView.popIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(73, [popView.popLbl getLabelHeight] + 6));
            make.center.equalTo(popView);
        }];
        
    }
        
    [UIView animateWithDuration:0.3f animations:^{
        [popView layoutIfNeeded];
    }];
    
    
    [popView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(popView.popIV);
        make.bottom.equalTo(view.mas_top).offset(5);
        if (tmpX <= 0) {
            make.left.mas_equalTo(0);
        } else {
            make.centerX.equalTo(view).offset(-2);
        }
    }];
}

- (void)popIVClick:(UITapGestureRecognizer *)gesture
{
    switch (popView.recordType) {
        case DiningRecord:
        {
            STDietRecordViewController *drvc = [STDietRecordViewController new];
            drvc.isHidRightBtn               = YES;
            drvc.isHidSaveBtn                = true;
            drvc.hidesBottomBarWhenPushed    = true;
            [[[self getFormViewController] navigationController] pushViewController:drvc animated:true];
            drvc.entity                      = [[DiningRecordEntity alloc]initWithDictionary:[_recordEntity.diningEntity getAllPropertiesAndVaules]];
        }
            break;
        case MedicateRecord:
        {
            NSDictionary *dic                     = [_recordEntity.medicateEntity getAllPropertiesAndVaules];
            STMedicationController *medicationVC  = [STMedicationController new];
            medicationVC.rightBtnHidden           = @"NO";
            medicationVC.medicationID             = dic[@"ID"];
            medicationVC.dataDict                 = [NSMutableDictionary dictionaryWithDictionary:dic];
            medicationVC.AddBtnHidden             = @"hidden";
            [GL_USERDEFAULTS setObject:@"用药" forKey:@"medicationCell"];
            NSInteger num                         = [[dic objectForKey:@"DETAIL"]count]+2;
            medicationVC.cellNum                  = num;
            medicationVC.hidesBottomBarWhenPushed = true;
            [[[self getFormViewController] navigationController] pushViewController:medicationVC animated:true];
        }
            break;
        case InsulinRecord:
        {
            NSDictionary *dic                     = [_recordEntity.medicateEntity getAllPropertiesAndVaules];
            STMedicationController *medicationVC  = [STMedicationController new];
            medicationVC.rightBtnHidden           = @"NO";
            medicationVC.AddBtnHidden             = @"hidden";
            medicationVC.medicationID             = dic[@"ID"];
            medicationVC.dataDict                 = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSInteger num                         = [[dic objectForKey:@"DETAIL"]count]+2;
            medicationVC.cellNum                  = num;
            medicationVC.isYiDaoSu                = YES;
            [GL_USERDEFAULTS setObject:@"胰岛素" forKey:@"medicationCell"];
            medicationVC.hidesBottomBarWhenPushed = true;
            [[[self getFormViewController] navigationController] pushViewController:medicationVC animated:true];
        }
            break;
        case SportsRecord:
        {
            STSportController *sportVC       = [STSportController new];
            sportVC.entity                   = _recordEntity.sportsEnttiy;
            sportVC.isHideSavaBtn            = true;
            sportVC.hidesBottomBarWhenPushed = true;
            [[[self getFormViewController] navigationController] pushViewController:sportVC animated:true];
        }
            break;
        default:
        {
            WS(ws);
            [UIView animateWithDuration:0.3f animations:^{
                ws.alpha = 0;
            } completion:^(BOOL finished) {
                ws.hidden = true;
                [popView.popIV mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
            }];
        }
            break;
    }
}


+ (void)dismiss
{
    if (popView) {
        [UIView animateWithDuration:0.3f animations:^{
            popView.alpha  = 0;
        } completion:^(BOOL finished) {
            [popView.popIV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(0, 0));
            }];
            popView.hidden = true;
        }];
    }
}

@end
