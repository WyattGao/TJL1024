//
//  STPersonInfoViewController.h
//  SuiTangNew
//
//  Created by 高临原 on 16/7/4.
//  Copyright © 2016年 高临原♬. All rights reserved.
//

#import "GLViewController.h"

@interface STPersonInfoViewController : GLViewController

@property (nonatomic,strong) NSMutableDictionary *userBaseDic; /**< 用户基本信息 */

@property (nonatomic,strong) NSMutableDictionary *patientDic;  /**< 用户扩展信息 */


@end
