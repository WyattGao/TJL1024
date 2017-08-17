//
//  STMedicationController.h
//  Diabetes
//
//  Created by 房克志 on 16/3/2.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "GLViewController.h"

typedef void(^REFRESH_DATA)(void);

@interface STMedicationController : GLViewController
@property (nonatomic,strong) NSMutableArray *detailArray;

@property (nonatomic,copy) NSString * medicationID;/**<药品ID 空的时候是添加 */

@property (nonatomic,copy) NSString * rightBtnHidden;/**<是否显示右按钮*/

@property (nonatomic,strong) NSMutableDictionary *dataDict;/**<数据数组*/

@property (nonatomic,assign)NSInteger cellNum;//几个cell

@property (nonatomic,copy)NSString *AddBtnHidden;//隐藏增加按钮

@property (nonatomic,copy) REFRESH_DATA  refreshBlock;

@property (nonatomic, assign) BOOL postSam; //上传圣美
@property (nonatomic, assign) BOOL isYiDaoSu;//注射胰岛素
@end
