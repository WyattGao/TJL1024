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
    self.sectionView    = nil;
    self.bounces        = false;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:return GL_IP6_H_RATIO(338) + 10;break; //+20 图例占10个像素 留白10个像素
        case 1:return SCREEN_HEIGHT - 64 - GL_IP6_H_RATIO(338) - 10;break;
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
            case 0:[cell addSubviewByCellFrame:self.lineView];break;
            case 1:[cell addSubviewByCellFrame:self.lishiZhiView];break;
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
