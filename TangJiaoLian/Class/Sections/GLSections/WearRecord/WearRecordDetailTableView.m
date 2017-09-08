//
//  WearRecordDetailTableView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/4/1.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WearRecordDetailTableView.h"

@interface WearRecordDetailTableView ()


@end

@implementation WearRecordDetailTableView

- (void)createUI
{
    self.separatorStyle = UITableViewCellStyleDefault;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:return 214.0f;break;
        case 1:return 382.0f;break;
        default:break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mark"];
    if (!cell) {
        cell = [[GLTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mark"];
        switch (indexPath.row) {
            case 0:[cell addSubviewByCellFrame:self.lishiZhiView];break;
            case 1:[cell addSubviewByCellFrame:self.lineView];break;
            default:
                break;
        }
    }
    return cell;
}

- (XueTangLiShiZhiView *)lishiZhiView
{
    if (!_lishiZhiView) {
        _lishiZhiView = [XueTangLiShiZhiView new];
    }
    return _lishiZhiView;
}

- (XueTangLineView *)lineView
{
    if (!_lineView) {
        _lineView = [XueTangLineView new];
    }
    return _lineView;
}

@end
