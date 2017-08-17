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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:return 46.0f;break;
        case 1:return 214.0f;break;
        case 2:return 382.0f;break;
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
            case 0:{
                [cell addSubviewByCellFrame:self.dataAnalysisView.dataAnalysisBtn];
                self.dataAnalysisView.dataAnalysisBtn.backgroundColor        = TCOL_BGGRAY;
                self.dataAnalysisView.dataAnalysisBtn.userInteractionEnabled = false;
                WS(ws);
                [self.dataAnalysisView.dataAnalysisBtn.iv mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(ws.dataAnalysisView.dataAnalysisBtn.mas_centerX).offset(-13);
                    make.centerY.equalTo(ws.dataAnalysisView.dataAnalysisBtn);
                    make.size.mas_equalTo(CGSizeMake(16, 16));
                }];
                [self.dataAnalysisView.dataAnalysisBtn.lbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(ws.dataAnalysisView.dataAnalysisBtn.mas_centerX).offset(0);
                    make.centerY.equalTo(ws.dataAnalysisView.dataAnalysisBtn);
                }];
                break;
            }
            case 1:[cell addSubviewByCellFrame:self.lishiZhiView];break;
            case 2:[cell addSubviewByCellFrame:self.lineView];break;
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

- (XueTangDataAnalysisAndMonitoringTargetView *)dataAnalysisView
{
    if (!_dataAnalysisView) {
        _dataAnalysisView = [XueTangDataAnalysisAndMonitoringTargetView new];
    }
    return _dataAnalysisView;
}

- (XueTangLineView *)lineView
{
    if (!_lineView) {
        _lineView = [XueTangLineView new];
    }
    return _lineView;
}

@end
