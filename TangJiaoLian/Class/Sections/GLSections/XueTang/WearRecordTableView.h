//
//  WearRecordTableView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/31.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLTableView.h"
#import "WearRecordCell.h"


typedef NS_ENUM(NSInteger,RecordCellButtonClickType) {
    RecordCellDataAnalysisClick = 0,
    RecordCelldetailedRecordClick
};

typedef void(^CellButtonClick)(RecordCellButtonClickType clickType,NSInteger row);


@interface WearRecordTableView : GLTableView

@property (nonatomic,copy) CellButtonClick cellButtonClick;

@end
