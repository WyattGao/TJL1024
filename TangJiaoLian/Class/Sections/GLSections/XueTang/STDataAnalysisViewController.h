//
//  STDataAnalysisViewController.h
//  Diabetes
//
//  Created by 高临原 on 16/3/21.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "GLViewController.h"

@interface STDataAnalysisViewController : GLViewController

///佩戴开始时间
@property (nonatomic,strong) NSString *startTimeStr;
///佩戴结束时间
@property (nonatomic,strong) NSString *endTimeStr;

@property (nonatomic,strong) NSMutableDictionary *referenceDic; /**< 参比血糖字典 */

@property (nonatomic,strong) NSMutableArray *bloodValueArr; /**< 每日血糖数组 */


@end
