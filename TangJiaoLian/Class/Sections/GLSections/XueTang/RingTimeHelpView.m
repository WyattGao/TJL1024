//
//  RingTimeHelpView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/9/6.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "RingTimeHelpView.h"
#import "RingTimeHelpCell.h"

#define degreesToRadians(degrees) ((degrees * (float)M_PI) / 180.0f)

@implementation RingTimeHelpView

- (void)createUI
{
    self.translatesAutoresizingMaskIntoConstraints = false;
    [self registerClass:[RingTimeHelpCell class] forCellReuseIdentifier:@"mark"];
    [self setSectionView:self.ringHeaderView];
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
    
    NSString *text = [self.hintTextArr objectAtIndex:indexPath.row];
    NSMutableAttributedString *tmpStr = [[NSMutableAttributedString alloc]initWithString:text];
    NSArray *indexArr = self.hintHighlightIndexArr[indexPath.row];
    for (NSInteger i = 0; i < [indexArr count]; i += 2) {
        NSRange range = NSMakeRange([indexArr[i] integerValue], [indexArr[i + 1] integerValue]);
        [tmpStr addAttribute:NSForegroundColorAttributeName value:self.hintHighlightColor[indexPath.row] range:range];
    }
    cell.hintLbl.attributedText = tmpStr;

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
        _hintHighlightColor = @[TCOL_MAIN,TCOL_MAIN,TCOL_RINGTIMEWAR,TCOL_RINGTIMENOR,TCOL_MAIN,TCOL_RINGTIMESEL];
    }
    return _hintHighlightColor;
}

- (NSArray *)hintHighlightIndexArr
{
    if (!_hintHighlightIndexArr) {
        _hintHighlightIndexArr = @[/* 1 */@[@(6),@(2),@(9),@(2),@(14),@(5),@(20),@(3)],
        /* 2 */ @[@(0),@(4),@(13),@(6)],
        /* 3 */@[@(0),@(4),@(13),@(5)],
        /* 4 */@[@(0),@(4),@(6),@(4)],
        /* 5 */@[@(0),@(5),@(7),@(2)],
        /* 6 */ @[@(0),@(4),@(11),@(4)]];
    }
    return _hintHighlightIndexArr;
}

- (UIView *)ringHeaderView
{
    if (!_ringHeaderView) {
        _ringHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
        _ringHeaderView.backgroundColor = [UIColor whiteColor];
        
        UILabel *hintLbl       = [UILabel new];
        UIImageView *gestureIV = [[UIImageView alloc]initWithImage:GL_IMAGE(@"点击手势")];
        [_ringHeaderView addSubview:hintLbl];
        [_ringHeaderView addSubview:gestureIV];
        
        hintLbl.text          = @"20点到21点间\n您的血糖共出现\n0次异常";
        hintLbl.textColor     = TCOL_MAIN;
        hintLbl.font          = GL_FONT(18);
        hintLbl.numberOfLines = 0;
        hintLbl.textAlignment = NSTextAlignmentCenter;
        
        [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_ringHeaderView);
        }];
        
        float dist = 104;//半径
        for (int i= 1; i<= 24;i++) {
            float angle = degreesToRadians((360 / 24) * i);
            float y = cos(angle) * dist;
            float x = sin(angle) * dist;
            
            GLButton *btn           = [GLButton buttonWithType:UIButtonTypeCustom];
            btn.width               = 16;
            btn.height              = 16;
            btn.tag                 = 30 + i;
            btn.layer.cornerRadius  = 8;
            btn.layer.masksToBounds = true;
            btn.highlighted         = false;
            [btn.lbl setFont:GL_FONT(8)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            if (i == 24) {
                [btn setTitle:@"0" forState:UIControlStateNormal];
            } else {
                [btn setTitle:[@(i) stringValue] forState:UIControlStateNormal];
            }
            
            [btn setBackgroundColor:TCOL_RINGTIMESEL forState:UIControlStateSelected];
            
            
            if ([btn.text integerValue] == 9) {
                [btn setBackgroundColor:TCOL_RINGTIMEWAR forState:UIControlStateNormal];
            } else if([btn.text integerValue] == 20){
                [btn setBackgroundColor:TCOL_RINGTIMESEL forState:UIControlStateNormal];
            } else if ([btn.text integerValue] >= 8 && [btn.text integerValue] <= 21) {
                [btn setBackgroundColor:TCOL_MAIN forState:UIControlStateNormal];
            } else {
                [btn setBackgroundColor:TCOL_RINGTIMENOR forState:UIControlStateNormal];
                btn.userInteractionEnabled = false;
            }
            
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            
            CGPoint center = CGPointMake(SCREEN_WIDTH/2 + x,240/2 -  y);
            btn.center     = center;
            
            [_ringHeaderView addSubview:btn];
            
            if (i == 20) {
                [gestureIV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(btn.mas_bottom).offset(-5);
                    make.left.equalTo(btn.mas_left).offset(-3.5);
                }];
            }
        }
        
        [_ringHeaderView bringSubviewToFront:gestureIV];

    }
    return _ringHeaderView;
}

@end
