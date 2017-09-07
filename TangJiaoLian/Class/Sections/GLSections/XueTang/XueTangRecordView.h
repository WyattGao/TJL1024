//
//  XueTangRecordView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/17.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"
#import "XueTangRecordBtn.h"

typedef NS_ENUM(NSInteger,GLRecordType){
    ///记录参比血糖
    GLRecordBloodType = 0,
    ///记录饮食
    GLRecordFoodType,
    ///记录用药
    GLRecordRrugs,
    ///记录胰岛素
    GLRecordInsulin,
    ///记录运动
    GLRecordSport,
    ///记录监测目标
    GLRecordTarget
};


typedef void (^RecordViewClick)(GLRecordType type);

@interface XueTangRecordView : GLView

    @property (nonatomic,assign) GLRecordType type;

@property (nonatomic,copy) RecordViewClick recordViewClick;

///连接设备按钮
@property (nonatomic,strong) UIView   *recordView;

///监测目标标签
@property (nonatomic,strong) UILabel *targetLbl;

///分割线标签
@property (nonatomic,strong) UILabel *cutLbl;

///分割线
@property (nonatomic,strong) UIView *cutLine;

///刷新监控目标值
- (void)realodTargetData;


/**
 刷新纪录按钮状态

 @param status 状态
 @param type 按钮类型
 */
- (void)realodRecordBtnStatus:(GLRecordBtnStatus)status WithType:(GLRecordType)type;


/**
 修改按钮的显示状态
 */
- (void)changeDisplayStatus;

@end
