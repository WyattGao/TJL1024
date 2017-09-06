//
//  RingTimeHelpView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/9/6.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "RingTimeHelpView.h"
#import "RingTimeHelpCell.h"

@implementation RingTimeHelpView

- (void)createUI
{
    [self registerClass:[RingTimeHelpCell class] forCellReuseIdentifier:@"mark"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = [tableView fd_heightForCellWithIdentifier:@"mark" configuration:^(RingTimeHelpCell *cell) {
        cell.hintLbl.attributedText = [[NSAttributedString alloc]initWithString:[self.hintTextArr objectAtIndex:indexPath.row]];
    }];
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RingTimeHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mark"];
    if (!cell) {
        cell = [[RingTimeHelpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mark"];
    }
    
    cell.hintLbl.attributedText = [[NSAttributedString alloc]initWithString:[self.hintTextArr objectAtIndex:indexPath.row]];

    return cell;
}

- (NSArray *)hintTextArr
{
    if (!_hintTextArr) {
        _hintTextArr = @[@"一共有24个圆点，表示一天中24个小时的时间段",@"绿色圆点代表此时间段内血糖未出现过异常",@"红色圆点代表此时间段内血糖出现过异常",@"灰色圆点代表尚未监测的时间段",@"闪动的圆点代表当前正在监测的时间段",@"点击圆点查看此时间段的统计结果"];
    }
    return _hintTextArr;
}

- (NSArray *)hintHighlightTextArr
{
    if (!_hintHighlightTextArr) {
        _hintHighlightTextArr = @[@[@"圆点",@"表示",@"24个小时",@"时间段"],@[@"绿色圆点",@"未出现过异常"],@[@"红色圆点",@"出现过异常"],@[@"灰色圆点",@"尚未监测"],@[@"闪动的圆点",@"当前"],@"点击圆点",@"统计结果"];
    }
    return _hintHighlightTextArr;
}

- (NSArray *)hintHighlightColor
{
    if (!_hintHighlightColor) {
        _hintHighlightColor = @[TCOL_MAIN,TCOL_RINGTIMEWAR,TCOL_MAIN,TCOL_RINGTIMENOR,TCOL_MAIN,TCOL_RINGTIMENOR];
    }
    return _hintHighlightColor;
}

//- (NSArray *)hintHighlightIndexArr
//{
//    if (_hintHighlightIndexArr) {
////        _hintHighlightIndexArr = @[@[@(6),@()]]
//    }
//}


@end
