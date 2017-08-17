//
//  FuWuTableView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/30.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "FuWuTableView.h"
#import "FuWuDoctorCell.h"

@implementation FuWuTableView

- (void)createUI
{
    self.sectionView         = self.headerView;
    self.sectionHeaderHeight = self.headerView.height;
}

- (FuWuTableViewSectionHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[FuWuTableViewSectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 162)];
    }
    return _headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FuWuDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:[@(indexPath.row) stringValue]];
    if (!cell) {
        cell = [[FuWuDoctorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[@(indexPath.row) stringValue]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:return 187;break;
        default:break;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

@end
