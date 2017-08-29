//
//  XueTangLineViewEntity.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/28.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XueTangLineViewEntity : NSObject

@property (nonatomic,strong) NSArray<NSDictionary *> *bloodGlucoseArr; /**< 血糖值数组 */

@property (nonatomic,strong) NSArray<NSDictionary *> *referenceArr;    /**< 参比血糖数组 */

@property (nonatomic,strong) NSArray<NSDictionary *> *dietArr;         /**< 记录饮食数组 */

@property (nonatomic,strong) NSArray<NSDictionary *> *medicatedArr;    /**< 记录用药数组 */

@property (nonatomic,strong) NSArray<NSDictionary *> *insulinArr;      /**< 记录胰岛素数组 */

@property (nonatomic,strong) NSArray<NSDictionary *> *sportsArr;       /**< 记录运动数组 */

@property (nonatomic,strong) NSArray<NSString *> *xAxisTimeArr;        /**< x轴时间 */

@end
