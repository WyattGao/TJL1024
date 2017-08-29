//
//  RunChartView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/8/22.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "RunChartView.h"

typedef NS_ENUM(NSInteger,RunChartViewChildView) {
    LineView = 0,
    historicalValueView = 1
};

@implementation RunChartView

- (void)createUI
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case LineView:
            return 308;  //折线图
            break;
        default:
            return SCREEN_HEIGHT - 64 - 308; //
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mark"];
    if (!cell) {
        cell = [[GLTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mark"];
        switch (indexPath.row) {
            case LineView:
                [cell addSubviewByCellFrame:self.lineView];
                break;
            default:
                break;
        }
        
    }
    return cell;
}

- (XueTangLineView *)lineView
{
    if (!_lineView) {
        _lineView = [XueTangLineView new];
    }
    return _lineView;
}

@end
