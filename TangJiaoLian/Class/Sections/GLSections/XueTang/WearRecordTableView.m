//
//  WearRecordTableView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/31.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WearRecordTableView.h"
#import "WearRecordHeaderView.h"

@interface WearRecordTableView ()

@property (nonatomic,strong) WearRecordHeaderView *headerView;

@end

@implementation WearRecordTableView

- (void)createUI
{
    [self setUpCellHeight:50
           CellIdentifier:nil
            CellClassName:NSStringFromClass([WearRecordCell class])];
    [self setSectionView:self.headerView];
    self.sectionHeaderHeight = 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *mark = [@(indexPath.row) stringValue];
    WearRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (!cell) {
        cell = [[WearRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    cell.entity = [self.tbDataSouce objectAtIndex:indexPath.row];
    WS(ws);
    //数据分析点击事件
    cell.dataAnalysisBtn.buttonClick = ^(GLButton *sender) {
        ws.cellButtonClick(RecordCellDataAnalysisClick, indexPath.row);
    };
    //详细记录点击事件
    cell.detailedRecordBtn.buttonClick = ^(GLButton *sender) {
        ws.cellButtonClick(RecordCelldetailedRecordClick, indexPath.row);
    };
    return cell;
}

- (WearRecordHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [WearRecordHeaderView new];
    }
    return _headerView;
}

@end
