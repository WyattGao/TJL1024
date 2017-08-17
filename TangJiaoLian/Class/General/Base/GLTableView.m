//
//  GLTableView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLTableView.h"

@interface GLTableView ()

@property (nonatomic,assign) CGFloat   cellHeight;
@property (nonatomic,copy)   NSString  *cellIdentifier;
@property (nonatomic,copy)   NSString  *cellClassName;


@end

@implementation GLTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
        self.dataSource     = self;
        self.delegate       = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)createUI{}

- (void)setSectionView:(UIView *)sectionView
{
    _sectionView             = sectionView;
    self.sectionHeaderHeight = sectionView.height;
}

- (void)setUpCellHeight:(CGFloat)height CellIdentifier:(NSString *)identifier CellClassName:(NSString *)className
{
    _cellHeight     = height;
    _cellIdentifier = identifier;
    _cellClassName  = className;
    
    [self reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tbDataSouce.count == 0 ? self.cellNumbers : self.tbDataSouce.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = _cellIdentifier;
    if (!_cellIdentifier) {
        identifier = [@(indexPath.row) stringValue];
    }
    GLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSClassFromString(_cellClassName) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (_tbDataSouce.count > indexPath.row) {
        cell.entity = _tbDataSouce[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (self.tableViewDidSelect) {
        self.tableViewDidSelect(indexPath);
    }
}

- (void)tableViewDidSelect:(TableViewDidSelect)tableViewDidSelect
{
    _tableViewDidSelect = tableViewDidSelect;
}

- (NSMutableArray *)tbDataSouce
{
    if (!_tbDataSouce) {
        _tbDataSouce = [NSMutableArray array];
    }
    return _tbDataSouce;
}

- (void)setCellNumbers:(NSInteger)cellNumbers
{
    _cellNumbers = cellNumbers;    
    [self reloadData];
}




@end
