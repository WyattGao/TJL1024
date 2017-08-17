//
//  DoctorEntity.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/4/20.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLEntity.h"

@interface DoctorEntity : GLEntity

@property (nonatomic,copy) NSString *USERNAME; /**< 医生姓名 */
@property (nonatomic,copy) NSString *ID;  /**< 医生ID */
@property (nonatomic,copy) NSString *HUAN_USERNAME; /**< 环信账号 */
@property (nonatomic,copy) NSString *JOB; /**< 职位 */
@property (nonatomic,copy) NSString *HOSPITAL; /**< 医院 */
@property (nonatomic,copy) NSString *PIC; /**< 医生头像 */

@end
