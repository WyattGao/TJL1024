//
//  XueTangLineView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/20.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangLineView.h"


@interface XueTangLineView ()



@end

@implementation XueTangLineView

- (void)createUI
{
    [self addSubview:self.lineChat];
    [self addSubview:self.cutlineView];
    
    WS(ws);
    
    [self.lineChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws);
        make.bottom.equalTo(ws.mas_bottom).offset(-25);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.centerX.equalTo(ws);
    }];
    
    [self.cutlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.lineChat.mas_bottom).offset(11);
        make.right.equalTo(ws.mas_right).offset(-18);
        make.size.mas_equalTo(CGSizeMake(170, 9));
    }];
}


- (void)refreshLineView{
    
    self.lineColor.chartLine_PointArr       = @[[GLCache readCacheArrWithName:SamBloodValueArr]];

    self.lineColor.chartLine_bigPointArr    = [GLCache readCacheArrWithName:SamReferenceArr];

    self.lineColor.chartLine_Xarr           = [TimeManage XAllTimeAndStarTime:CGM_Start_Time andEndTime:CGM_Ending_Time];
//    self.lineColor.chartLine_Xarr           = [TimeManage XAllTimeAndStarTime:CGM_Start_Time andEndTime:[[[self.lineColor.chartLine_PointArr lastObject] lastObject] getStringValue:@"collectedtime"]];

    self.lineColor.chartLine_pointAndPointX = 20 * [GLTools refreshChatLineScaling];
    
    [SVProgressHUD show];
    
    [self.lineChat refreshChartLine:self.lineColor];
    
    [SVProgressHUD dismiss];
}

- (void)wearRecordrefreshLineView
{
    [self.lineChat refreshChartLine:self.lineColor];
}

- (XQDColor *)lineColor
{
    if (!_lineColor) {
        _lineColor                          = [XQDColor new];
        _lineColor.chartLine_leftDistance   = 0.0;
        _lineColor.chartLine_rightDistance  = 0.0;
        _lineColor.chartLine_yWith          = 35;
        _lineColor.chartLine_XYColor        = CHARTLINE_Y_LINE_COLOR;
        _lineColor.chartLine_YMax           = 27.5;//y轴最大值
        _lineColor.chartLine_Yarr           = @[@"25",@"20",@"15",@"11.1",@"7.8",@"6.1",@"3.9",@"1.7",@"0"];
        _lineColor.chartLine_YLineArr       = @[@"20",@"15",@"11.1",@"7.8",@"6.1",@"3.9",@"1"];
        _lineColor.chartLine_XYTextColor    = RGB(74, 74, 74);
        _lineColor.chartLine_Xarr           = [TimeManage XAllTimeAndStarTime:CGM_Start_Time andEndTime:CGM_Ending_Time];
        _lineColor.chartLine_PointArr       = @[[GLCache readCacheArrWithName:SamBloodValueArr]];
        _lineColor.chartLine_LineColorArr   = @[RGB(67, 230, 250)];
        _lineColor.chartLine_pointAndPointX = 20.0f * [GLTools refreshChatLineScaling];
        _lineColor.chartLine_isSetGraph     = NO;
        _lineColor.chartLine_duration       = 0;
        _lineColor.chartLine_tap            = YES;
        _lineColor.chartLine_Color          = [UIColor whiteColor];
        _lineColor.chartLine_bigPointArr    = [GLCache readCacheArrWithName:SamReferenceArr];
        _lineColor.chartLine_foot_h         = 10;
        _lineColor.isShowDate               = true;
    }
    return _lineColor;
}

- (XQDLineChart *)lineChat
{
    if (!_lineChat) {
        _lineChat = [[XQDLineChart alloc] initWithFrame:CGRectMake(0, 128.8, SCREEN_WIDTH, 342) andXQDColor:self.lineColor];
        [_lineChat initLineChart];
    }
    return _lineChat;
}

//折线图图例
- (UIView *)cutlineView
{
    if (!_cutlineView) {
        _cutlineView = [UIView new];
        
        __block MASViewAttribute *tmpRight = [MASViewAttribute new];
        
        [@[@"胰岛素",@"用药",@"饮食",@"运动"]  enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *iv = [[UIImageView alloc]initWithImage:GL_IMAGE(obj)];
            UILabel *lbl  = [UILabel new];
            
            [_cutlineView addSubview:iv];
            [_cutlineView addSubview:lbl];
            
            lbl.text      = obj;
            lbl.font      = GL_FONT(10);
            lbl.textColor = RGB(153, 153, 153);
            
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(9, 9));
                if (!idx) {
                    make.left.equalTo(_cutlineView);
                } else {
                    make.left.equalTo(tmpRight).offset(10);
                }
                make.centerY.equalTo(_cutlineView);
            }];
            
            [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(iv);
                make.left.equalTo(iv.mas_right).offset(3);
            }];
            
            tmpRight = lbl.mas_right;
        }];
        
    }
    return _cutlineView;
}

@end
