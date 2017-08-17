//
//  STSportController.h
//  Diabetes
//
//  Created by 高临原 on 16/3/8.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "GLViewController.h"
#import "RecordEntity.h"

typedef void(^RefreshSportRecord)();

@interface STSportController : GLViewController

@property (nonatomic, assign) BOOL postSam;

@property (nonatomic,strong) SportsRecordEntity *entity;

@property (nonatomic,assign) BOOL isHideSavaBtn;

@property (nonatomic,copy) RefreshSportRecord refreshSportRecord;

@end
