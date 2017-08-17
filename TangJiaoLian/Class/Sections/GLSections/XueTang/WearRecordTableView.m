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

- (WearRecordHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [WearRecordHeaderView new];
    }
    return _headerView;
}

@end
