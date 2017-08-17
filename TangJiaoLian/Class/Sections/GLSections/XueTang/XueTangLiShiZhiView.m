//
//  XueTangLiShiZhiView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/16.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangLiShiZhiView.h"
#import "XueTangLiShiZhiHeaderView.h"
#import "XueTangLiShiZhiCellTableViewCell.h"

@interface XueTangLiShiZhiView ()

@property (nonatomic,strong) XueTangLiShiZhiHeaderView *headerView;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation XueTangLiShiZhiView

- (void)createUI
{
    self.sectionView         = self.headerView;
    self.sectionHeaderHeight = 31.5;
    
    [self setUpCellHeight:30 CellIdentifier:nil CellClassName:NSStringFromClass([XueTangLiShiZhiCellTableViewCell class])];
}

- (void)reloadDataWithBloodArr:(NSArray *)bloodArr
{
    [self.tbDataSouce removeAllObjects];
    if (ISBINDING && bloodArr) {
        if (!bloodArr.count) {
            bloodArr = [NSArray arrayWithObject:@{@"value":@"暂无数据",@"collectedtime":@"暂无数据",@"currentvalue":@"暂无数据"}];
        }
    }
    
    WS(ws);
    [bloodArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XueTangZhiEntity *entity = [[XueTangZhiEntity alloc]initWithDictionary:obj];
        [ws.tbDataSouce addObject:entity];
    }];
    [super reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setContentOffset:CGPointMake(0, 0)];
    });
}


- (XueTangLiShiZhiHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[XueTangLiShiZhiHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 31.5)];
    }
    return _headerView;
}

@end
