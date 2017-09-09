//
//  XueTangLineView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/20.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangLineView.h"

//定义折线图上显示的数据类型
typedef NS_ENUM(NSInteger,LineType) {
    LineBloodGlucose = 0,//血糖曲线
    LineReference    = 1,//参比血糖
    LineDiet         = 2,//饮食
    LineMedicated    = 3,//用药
    LineInsulin      = 4,//胰岛素
    LineSports       = 5 //运动
};


@interface XueTangLineView ()<ChartViewDelegate>

@property (nonatomic,strong) ChartMarkerView *chartMarkerView;

@end

@implementation XueTangLineView

#pragma mark - ChartViewDelegate
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
    
    self.lineColor.chartLine_PointArr       = @[self.entity.bloodGlucoseArr];
    
    self.lineColor.chartLine_bigPointArr    = self.entity.referenceArr;
    
    self.lineColor.chartLine_Xarr           = self.entity.xAxisTimeArr;
    
    self.lineColor.chartLine_oneFloorArr    = self.entity.dietArr;
    
    self.lineColor.chartLine_twoFloorArr    = self.entity.sportsArr;
    
    self.lineColor.chartLine_threeFloorArr  = self.entity.medicatedArr;
    
    self.lineColor.chartLine_fourFloorArr   = self.entity.insulinArr;
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

- (XueTangLineViewEntity *)entity
{
    if (!_entity) {
        _entity = [XueTangLineViewEntity new];
    }
    return _entity;
}

#if 0
//刷新折线图数据
- (void)refreshLineView
{
    [self setCoordinatePoint:self.entity];
    
    self.lineChartView.xAxis.valueFormatter = [[ChartsDateValueFormatter alloc]initWithArr:self.entity.xAxisTimeArr];
}


//设置坐标点
- (void)setCoordinatePoint:(XueTangLineViewEntity *)entity
{
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0;i < 1;i++) {
        NSMutableArray *values = [[NSMutableArray alloc] init];
        NSArray *tmpArr = [NSArray array];
        UIImage *img    = [UIImage new];
        
        switch (i) {
            case LineBloodGlucose: //血糖
                tmpArr = entity.bloodGlucoseArr;
                break;
            case LineReference: //参比
                tmpArr = entity.referenceArr;
                img = [UIImage imageNamed:@"参比血糖"];
                break;
            case LineDiet:
                tmpArr = entity.dietArr;
                img = [UIImage imageNamed:@"饮食"];
                break;
            case LineMedicated:
                tmpArr = entity.medicatedArr;
                img = [UIImage imageNamed:@"用药"];
                break;
            case LineInsulin:
                tmpArr = entity.insulinArr;
                img = [UIImage imageNamed:@"胰岛素"];
                break;
            case LineSports:
                tmpArr = entity.sportsArr;
                img = [UIImage imageNamed:@"运动"];
                break;
            default:
                break;
        }
        
        
        for (NSInteger j = 0;j < tmpArr.count;j++) {
            NSDictionary *dic = [tmpArr objectAtIndex:j];
            if (i == LineBloodGlucose) {
                [values addObject:[[ChartDataEntry alloc]initWithX:j y:[dic getDoubleValue:@"value"] data:@{@"Type":@(i)}]];
            } else {
                [values addObject:[[ChartDataEntry alloc]initWithX:[TimeManage PointX:dic[@"collectedtime"]]*(j+1) y:[dic getDoubleValue:@"value"] icon:img data:@{@"Type":@(i)}]];
                DLog(@"values = %@",values);
            }
        }
        
        LineChartDataSet *set = nil;
        if (self.lineChartView.data.dataSetCount > 0)
        {
            set = (LineChartDataSet *)self.lineChartView.data.dataSets[i];
            set.values = values;
        }
        else
        {
            set = [[LineChartDataSet alloc] initWithValues:values label:@""]; //label:曲线图例名称


            if (i == LineBloodGlucose) {
                set.highlightLineDashLengths = @[@5.f, @2.5f];
                [set setColor:UIColor.blackColor];
                [set setCircleColor:UIColor.blackColor];
                set.lineWidth             = 2.0;  //折现宽/粗
                //        bloodGlucoseSet.circleRadius          = 2.0;  //数值圆点的半径
                set.formLineDashLengths   = @[@10.f, @2.5f];
                set.formLineWidth         = 1.0;
                set.formSize              = 15.0;
                set.mode                  = LineChartModeCubicBezier;
                set.drawCirclesEnabled    = false;//是否绘制圆点
                set.drawCircleHoleEnabled = false;
                set.drawFilledEnabled     = false;//是否绘制下方阴影
                set.drawValuesEnabled     = false;//是否绘制曲线上数值
                
                [set setColor:RGB(52, 229, 250)];
            } else {
                set.lineWidth = 0.0f;
                set.formSize = 15.0;
            }
            
            [dataSets addObject:set];
            
        }
    }
    
    if (self.lineChartView.data.dataSetCount > 0) {
        [self.lineChartView.data notifyDataChanged];
        [self.lineChartView notifyDataSetChanged];
    } else {
        LineChartData *data     = [[LineChartData alloc] initWithDataSets:dataSets];
        self.lineChartView.data = data;
    }

    

    
//    [_lineChartView moveViewToX:entity.bloodGlucoseArr.count];// 移动到那个点
//    
//    [self.lineChartView setNeedsDisplay];
}


//点击折线数据
- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {
    
//    _markY.text = [NSString stringWithFormat:@"%ld",(NSInteger)entry.y];
//    //将点击的数据滑动到中间
//    [self.lineChartView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[self.lineChartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
//    
//    UIView *someView = [[UIView alloc]initWithFrame:CGRectMake(entry.x * 5.0f + 30, entry.y * self.lineChartView.scaleY - 15, 20, 20)];
//    someView.backgroundColor = [UIColor blueColor];
//    [self.chartMarkerView addSubview:someView];
}

//缩放
- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY
{
    
}

//拖动
- (void)chartTranslated:(ChartViewBase * _Nonnull)chartView dX:(CGFloat)dX dY:(CGFloat)dY
{
    
}

- (void)createUI
{
    [self addSubview:self.lineChartView];
    
    WS(ws);
    
    [self.lineChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(ws);
        make.center.equalTo(ws);
    }];
}

- (LineChartView *)lineChartView
{
    if (!_lineChartView) {
        _lineChartView                          = [LineChartView new];
        _lineChartView.delegate                 = self;//设置代理
        _lineChartView.scaleYEnabled            = false;//不缩放Y轴
        _lineChartView.descriptionText          = @"糖教练";//右下角版权信息
        _lineChartView.noDataText               = @"暂无数据";
        _lineChartView.data.highlightEnabled    = true;
        _lineChartView.dragEnabled              = true;//启用拖拽图标
        _lineChartView.legend.enabled           = false;//不显示图例说明

        //设置X轴样式
        ChartXAxis *xAxis                   = _lineChartView.xAxis;
        xAxis.labelPosition                 = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
        xAxis.drawGridLinesEnabled          = false;//是否绘制网格线
        xAxis.labelTextColor                = RGB(74, 74, 74);//label文字颜色
        xAxis.gridColor                     = RGB(208, 233, 255);
        xAxis.granularityEnabled            = true;//设置的值不管放大多多少不会重复显示
        xAxis.gridAntialiasEnabled          = false;//是否开启网格抗锯齿
        xAxis.avoidFirstLastClippingEnabled = true;  //避免x轴标签超出折线图范围
        xAxis.labelCount                    = [@(SCREEN_WIDTH/80) integerValue];
        xAxis.forceLabelsEnabled            = true;
        
        ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:[GL_USERDEFAULTS getFloatValue:SamTargetHeight] label:@"监控目标最大值"];
        ll1.lineWidth       = 2.0;
        ll1.lineDashLengths = @[@10.f, @5.f];
        ll1.labelPosition   = ChartLimitLabelPositionRightTop;
        ll1.valueFont       = [UIFont systemFontOfSize:10.0];

        ChartLimitLine *ll2 = [[ChartLimitLine alloc] initWithLimit:[GL_USERDEFAULTS getFloatValue:SamTargetLow] label:@"监控目标最小值"];
        ll2.lineWidth       = 2.0;
        ll2.lineDashLengths = @[@10.f, @5.f];
        ll2.labelPosition   = ChartLimitLabelPositionRightBottom;
        ll2.valueFont       = [UIFont systemFontOfSize:10.0];
        
        ChartLimitLine *ll3 = [[ChartLimitLine alloc]initWithLimit:([GL_USERDEFAULTS getFloatValue:SamTargetHeight] + [GL_USERDEFAULTS getFloatValue:SamTargetLow])/2 label:@""];
        ll3.lineWidth       = 100;
        ll3.lineColor       = CHEX(0xE4F9F4);
        
        //设置Y轴样式
        self.lineChartView.rightAxis.enabled     = NO;//不绘制右边轴
        ChartYAxis *leftAxis                     = self.lineChartView.leftAxis;//获取左边Y轴
        leftAxis.labelCount                      = 9;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        leftAxis.forceLabelsEnabled              = true;//强制绘制指定数量的label
        leftAxis.axisMinValue                    = 0;//设置Y轴的最小值
        leftAxis.axisMaxValue                    = 25;//设置Y轴的最大值
        leftAxis.inverted                        = NO;//是否将Y轴进行上下翻转
        leftAxis.axisLineWidth                   = 1;//Y轴线宽
        leftAxis.axisLineColor                   = RGB(208, 233, 255);//Y轴颜色
        leftAxis.gridColor                       = RGB(208, 233, 255);//Y轴横线颜色
        leftAxis.gridLineWidth                   = 1;
        leftAxis.labelPosition                   = YAxisLabelPositionOutsideChart;//label位置
        leftAxis.labelTextColor                  = RGB(74, 74, 74);//文字颜色
        leftAxis.labelFont                       = [UIFont systemFontOfSize:10.0f];//文字字体
        leftAxis.gridAntialiasEnabled            = false;//开启抗锯齿
        leftAxis.drawLimitLinesBehindDataEnabled = false;//设置警告线显示前后
        
        [leftAxis addLimitLine:ll1];
        [leftAxis addLimitLine:ll2];
        [leftAxis addLimitLine:ll3];
        
        [_lineChartView animateWithYAxisDuration:2.0f];
    }
    return _lineChartView;
}


- (ChartMarkerView *)chartMarkerView
{
    if (!_chartMarkerView) {
        _chartMarkerView           = [ChartMarkerView new];
        _chartMarkerView.offset    = CGPointMake(-999, -8);
        _chartMarkerView.chartView = _lineChartView;
        self.lineChartView.marker  = _chartMarkerView;
    }
    return _chartMarkerView;
}

- (XueTangLineViewEntity *)entity
{
    if (!_entity) {
        _entity = [XueTangLineViewEntity new];
    }
    return _entity;
}
#endif

@end
