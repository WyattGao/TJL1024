//
//  RecordEntity.h
//  newCGM
//
//  Created by 高临原 on 2016/11/15.
//  Copyright © 2016年 随糖. All rights reserved.
//

#import "GLEntity.h"

/**
 记录的活动类型 :饮食 运动 用药 胰岛素
 */
typedef NS_ENUM(NSUInteger, RecordType) {
    DiningRecord   = 100000,/**< 饮食 */
    SportsRecord   = 200000,/**< 运动 */
    MedicateRecord = 300000,/**< 用药 */
    InsulinRecord  = 400000/**< 胰岛素 */
};


@class DiningRecordEntity;
@class SportsRecordEntity;
@class MedicateRecordEntity;

@interface RecordEntity : GLEntity

@property (nonatomic,strong) DiningRecordEntity   *diningEntity;
@property (nonatomic,strong) SportsRecordEntity   *sportsEnttiy;
@property (nonatomic,strong) MedicateRecordEntity *medicateEntity;

@end

//记录用餐模型
@interface DiningRecordEntity : GLEntity

@property (nonatomic,copy) NSString *ID;                   /**< ID */
@property (nonatomic,copy) NSString *DIETSITUATION;        /**< 描述 */
@property (nonatomic,strong) NSArray<NSString *> *DIETPIC; /**< 保存的食物图片 */
@property (nonatomic,copy) NSString *DIETTIME;             /**< 用餐时间 */
@property (nonatomic,copy) NSString *DURATIONTIME;         /**< 用餐时长（分） */
@property (nonatomic,copy) NSString *DIETTYPE;             /**< 用餐类型 */

@end

//记录运动模型
@interface SportsRecordEntity : GLEntity

@property (nonatomic,copy) NSString *ID;           /**< ID */
@property (nonatomic,copy) NSString *STEPSNUM;     /**< 步数 */
@property (nonatomic,copy) NSString *MOTIONTIME;   /**< 时间 */
@property (nonatomic,copy) NSString *MOTIONTYPE;   /**< 类型：休闲运动,剧烈运动,放松运动,计步器 */
@property (nonatomic,copy) NSString *DURATIONTIME; /**< 运动时长 */

@end

//记录用药和记录胰岛素模型
@interface MedicateRecordEntity : GLEntity

@property (nonatomic,copy) NSString *ID;             /**< ID */
@property (nonatomic,copy) NSString *REMARK;         /**< 备注 */
@property (nonatomic,copy) NSString *MEDICATIONTIME; /**< 用药时间 */
@property (nonatomic,copy) NSString *DURATIONTIME;   /**< 持续时长 */
@property (nonatomic,copy) NSArray  *DETAIL;         /**< 存放用药数组 */

@end
