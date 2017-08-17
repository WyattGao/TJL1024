//
//  GLPointScroollView.m
//  newCGM
//
//  Created by 高临原 on 2016/12/7.
//  Copyright © 2016年 随糖. All rights reserved.
//

#import "GLPointScrollView.h"

@interface GLPointScrollView ()
{
    NSMutableArray *layer_lineArr;
    NSMutableArray *path_lineArr;
    //    CAShapeLayer *layer_line;
    //    UIBezierPath *path_line;
    CAShapeLayer *layer_x;
    UIBezierPath *path_x;
    UIBezierPath *path_Y;

}

@end

@implementation GLPointScrollView

-(instancetype)initWithFrame:(CGRect)frame andXQDColor:(XQDColor *)xqdColor;
{
    if (isnan(frame.size.width)) {
        frame.size.width = 0;
    }
    self = [super initWithFrame:frame];
    if (self) {

        _xqdColor                   = xqdColor;
        self.backgroundColor        = _xqdColor.chartLine_Color;
        self.backgroundColor        = [UIColor clearColor];
        layer_x                     = [CAShapeLayer layer];
        path_x                      = [UIBezierPath bezierPath];
        path_Y                      = [UIBezierPath bezierPath];

        [self setChartLine_PointArr:_xqdColor.chartLine_PointArr];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    [self drawX];
    
    [self drawline];
    
    [self drawPoint];
    
    [self drawSegment];
}


//x轴
- (void)drawX{
    //x轴
    CGFloat x_w = _xqdColor.chartLine_Xarr.count*_xqdColor.chartLine_pointAndPointX;
    CGFloat x_h = _xqdColor.chartLine_fream.size.height-20-_xqdColor.chartLine_foot_h+1;
    
    // 创建layer并设置属性
    //    CAShapeLayer *layer = [CAShapeLayer layer];
    layer_x.fillColor = [UIColor redColor].CGColor;
    layer_x.lineWidth =  1.0f;
    layer_x.lineCap = kCALineCapRound;
    layer_x.lineJoin = kCALineJoinRound;
    layer_x.strokeColor = _xqdColor.chartLine_XYColor.CGColor;
    [self.layer addSublayer:layer_x];
    
    //    UIBezierPath *path = [UIBezierPath bezierPath];
    [path_x removeAllPoints];
    [path_x moveToPoint:CGPointMake(CHARTLINE_Y_LEFT,x_h)];
    [path_x addLineToPoint:CGPointMake(x_w, x_h)];
    [path_x closePath];
    
    layer_x.path = path_x.CGPath;
    
    //阴影区域
    if (!_xqdColor.isMoreLine) {
        CGFloat y1 = (x_h - (x_h/_xqdColor.chartLine_YMax)*_xqdColor.target_YMax);
        CGFloat y2 = (x_h - (x_h/_xqdColor.chartLine_YMax)*_xqdColor.target_YMini);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(CHARTLINE_Y_LEFT, y1, x_w-CHARTLINE_Y_LEFT, y2-y1)];
        path.lineWidth     = 1.0;
        path.lineCapStyle  = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinBevel;
        UIColor *fillColor = CHARTLINE_Y_FILL_COLOR;
        [fillColor set];
        [path fill];
        [path stroke];
    }
    
    
    
    //y轴横线
    for (int i=0; i<_xqdColor.chartLine_YLineArr.count; i++) {
        CGFloat x = CHARTLINE_Y_LEFT;
        CGFloat y = (x_h - (x_h/_xqdColor.chartLine_YMax)*[_xqdColor.chartLine_YLineArr[i] floatValue]);
        
        //        CAShapeLayer *layer = [CAShapeLayer layer];
        //        layer.fillColor = [UIColor redColor].CGColor;
        //        layer.lineWidth =  1.0f;
        //        layer.lineCap = kCALineCapRound;
        //        layer.lineJoin = kCALineJoinRound;
        //        layer.strokeColor = _xqdColor.chartLine_XYColor.CGColor;
        //        [self.layer addSublayer:layer];
        //
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(x, y)];
        [path addLineToPoint:CGPointMake(x_w, y)];
        UIColor *fillColor = _xqdColor.chartLine_XYColor;
        [fillColor set];
        [path fill];
        [path stroke];
        //        layer_x.path = path_x.CGPath;
    }
    
    
    //x轴刻度
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSString *tmpStr = [[[_xqdColor.chartLine_Xarr firstObject] toDate:@"yyyy-MM-dd HH:mm:ss"] toString:@"dd"];
    for (int i=0; i<_xqdColor.chartLine_Xarr.count; i++) {
        CGFloat cout = 60/_xqdColor.chartLine_pointAndPointX;
        if (i%((int)cout*2)==0) {//每个x轴点的间隔数量
            //每天的第一个日期显示当天的号数
            NSString *str = _xqdColor.chartLine_Xarr[i];
            if (_xqdColor.isShowDate) {
                if (i) {
                    if ([[[str toDate:@"yyyy-MM-dd HH:mm:ss"] toString:@"dd"] isEqualToString:tmpStr]) {
                        str = [str substringWithRange:NSMakeRange(10, 6)];
                    } else {
                        tmpStr = [[str toDate:@"yyyy-MM-dd HH:mm:ss"] toString:@"dd"];
                        str = [[str toDate:@"yyyy-MM-dd HH:mm:ss"] toString:@"MM/dd HH:mm"];
                    }
                } else {
                    //第一个日期
                    str = [[str toDate:@"yyyy-MM-dd HH:mm:ss"] toString:@"MM/dd HH:mm"];
                }
            } else {
                str = [str substringWithRange:NSMakeRange(10, 6)];
            }
            
            CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
            
            //计算时间的宽度
            UILabel *tmpWidthLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 20)];
            tmpWidthLbl.text = str;
            
            CGFloat strX = 0+i*_xqdColor.chartLine_pointAndPointX;
            
            if (_xqdColor.isMoreLine) {
                if (strX < self.width && strX + [tmpWidthLbl getLabelWidth] > self.width) {
                    strX = self.width - [tmpWidthLbl getLabelWidth];
                }
            }
            
            [str drawInRect:CGRectMake(strX /* - [tmpWidthLbl getLabelWidth]*/, x_h + 2, [tmpWidthLbl getLabelWidth], 20) withAttributes:@{NSFontAttributeName:GL_FONT(CHARTLINE_Y_FONT),NSForegroundColorAttributeName:_xqdColor.chartLine_XYTextColor}];
        }
    }
}

//画折线
- (void)drawline{
    CGFloat x_h = _xqdColor.chartLine_fream.size.height-20-_xqdColor.chartLine_foot_h+1;
    
    //记录最后一个点的有效位置
    CGFloat tmpX = 0;
    
    NSArray *oneLineArr;
    for (int i=0; i<_xqdColor.chartLine_PointArr.count; i++) {//数组里存放着多条线段的坐标点
        oneLineArr = _xqdColor.chartLine_PointArr[i];
        
        //        CAShapeLayer *layer_line = layer_lineArr[i];
        //
        //        //        layer = [CAShapeLayer layer];
        //        layer_line.fillColor = [UIColor clearColor].CGColor;
        //        layer_line.lineWidth =  2.0f;
        //        layer_line.lineCap = kCALineCapRound;
        //        layer_line.lineJoin = kCALineJoinRound;
        //        UIColor *col = _xqdColor.chartLine_LineColorArr[i];
        //        layer_line.strokeColor = col.CGColor;
        //        [self.layer addSublayer:layer_line];
        
        UIBezierPath *path_line = path_lineArr[i];
        path_line.lineWidth = 3.0f;
        path_line.lineCapStyle = kCGLineCapRound;
        path_line.lineJoinStyle = kCGLineJoinBevel;
        
        if (_xqdColor.chartLine_isSetGraph) {//曲线
            path_line = [self smoothedPathWithGranularity:5 andArr:oneLineArr];
        }else{//折线
            [path_line removeAllPoints];
            
            
            BOOL isMoveToPointed = NO;
            CGFloat last_x = 0;
            for (int j=0; j<oneLineArr.count; j++) {
                
                
                NSDictionary *dic = oneLineArr[j];
                CGFloat x;
                
                
                
                if ([dic[@"value"] floatValue]!=0) {//过滤掉为0的数值
                    
                    if (j%3==0 || (oneLineArr.count-1)==j) {//隔3个点显示一个,显示最后一个
                        
                        if (_xqdColor.isMoreLine) {//多曲线
                            x = [TimeManage morePointX:dic[@"collectedtime"]]*_xqdColor.chartLine_pointAndPointX;
                        }else{
                            x = [TimeManage PointX:dic[@"collectedtime"]]*_xqdColor.chartLine_pointAndPointX;
                            tmpX = x;
                        }
                        
                        CGFloat y = (x_h - (x_h/_xqdColor.chartLine_YMax)*[dic[@"value"] floatValue]);
                        if (isMoveToPointed) {
                            
                            if (x >= last_x) {
                                [path_line addLineToPoint:CGPointMake(x, y)];
                                last_x = x;
                            }
                            
                        }else{
                            [path_line moveToPoint:CGPointMake(x, y)];
                            isMoveToPointed = YES;
                        }
                        
                    }
                }
                
                
                
                
            }
        }
        
        //        layer_line.path = path_line.CGPath;
        
        
        
        
        UIColor *strokeColor = _xqdColor.chartLine_LineColorArr[i];
        [strokeColor set];
        [path_line stroke];
        
        
        //        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        //        animation.fromValue = @(0.0);
        //        animation.toValue = @(1.0);
        //        layer_line.autoreverses = NO;
        //        animation.duration = _chartLine_duration;
        //
        //        [layer_line addAnimation:animation forKey:nil];
        //        layer_line.strokeEnd = 1;
        
    }
    
    if (!_xqdColor.isMoreLine) {
        if ([_glPonintDelegate respondsToSelector:@selector(reloadMainSVWithPointX:)]) {
            [_glPonintDelegate reloadMainSVWithPointX:tmpX];
        }
    }
}


//画点
- (void)drawPoint{
    CGFloat x_h = _xqdColor.chartLine_fream.size.height-20-_xqdColor.chartLine_foot_h+1;
    for (int i=0; i<_xqdColor.chartLine_bigPointArr.count; i++) {
        NSDictionary *dic = _xqdColor.chartLine_bigPointArr[i];
        CGFloat x = [TimeManage PointX:dic[@"collectedtime"]]*_xqdColor.chartLine_pointAndPointX + 5;
        CGFloat y = (x_h - (x_h/_xqdColor.chartLine_YMax)*[dic[@"value"] floatValue])-10;
        
        //        UIImage *image = [UIImage imageNamed:@"参比血糖"];
        //        [image drawInRect:CGRectMake(x, y, 10, 16)];//在坐标中画出图片
        
        GLButton *btn =[[GLButton alloc]initWithFrame:CGRectMake(x - 5, y - 8, 10 * 2, 16 * 2)];
        [btn.lbl setHidden:true];
        [btn setGraphicLayoutState:PICCENTER];
        [btn addTarget:self action:@selector(checkReference:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:GL_IMAGE(@"参比血糖") forState:UIControlStateNormal];
        [btn setTitle:dic[@"value"] forState:UIControlStateNormal];
        [self addSubview:btn];
    }
}

//查看参比血糖
- (void)checkReference:(GLButton *)sender
{
    [GLPopupView showBloodValueForView:sender WithText:sender.lbl.text];
}

//画线段
- (void)drawSegment{
    CGFloat x_h = _xqdColor.chartLine_fream.size.height-20-_xqdColor.chartLine_foot_h+1;
    CGFloat y = (x_h - (x_h/_xqdColor.chartLine_YMax)*0.5)-8;
    CGFloat w = 20;
    
    //饮食
    for (int j=0; j<_xqdColor.chartLine_oneFloorArr.count; j++) {
        NSDictionary *dic = _xqdColor.chartLine_oneFloorArr[j];
        
        //        给长时间活动画背景色
        //        CGFloat y = x_h+20 ;
        //        CGFloat w = ([dic[@"DURATIONTIME"] intValue]/3+[dic[@"DURATIONTIME"] intValue]%3)*_xqdColor.chartLine_pointAndPointX;
        //
        //        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, w, CHARTLINE_FLOOR_H) cornerRadius:CHARTLINE_FLOOR_H/2];
        //        UIColor *fillColor = RGB(162, 115, 248);
        //        [fillColor set];
        //        [path fill];
        //
        //        UIColor *strokeColor = RGB(162, 115, 248);
        //        [strokeColor set];
        //        [path stroke];
        
        CGFloat x = [TimeManage PointX:dic[@"DIETTIME"]]*_xqdColor.chartLine_pointAndPointX + 10;
        //        CGFloat w = 15;
        //        UIImage *image = [UIImage imageNamed:@"参比血糖"];
        //        [image drawInRect:CGRectMake(x, y, 10, 16)];//在坐标中画出图片
        
        
        //图片
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x+w/2, y - 2.5, 15 + 5, 15 + 5)];
        [self addSubview:btn];
        [btn setTag:100000 + j];
        [btn setImage:GL_IMAGE(@"饮食") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(recordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
    
    //运动
    for (int j=0; j<_xqdColor.chartLine_twoFloorArr.count; j++) {
        NSDictionary *dic = _xqdColor.chartLine_twoFloorArr[j];
        CGFloat x = [TimeManage PointX:dic[@"MOTIONTIME"]]*_xqdColor.chartLine_pointAndPointX + 10;
        
        //        给长时间活动画背景色
        //        CGFloat y = x_h+20+18 ;
        //        CGFloat w = ([dic[@"DURATIONTIME"] intValue]/3+[dic[@"DURATIONTIME"] intValue]%3)*_xqdColor.chartLine_pointAndPointX;
        //        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, w, CHARTLINE_FLOOR_H) cornerRadius:CHARTLINE_FLOOR_H/2];
        //
        //        UIColor *fillColor = RGB(241, 175, 26);
        //        [fillColor set];
        //        [path fill];
        //
        //        UIColor *strokeColor = RGB(241, 175, 26);
        //        [strokeColor set];
        //        [path stroke];
        
        //图片
        //        UIImage *image = [UIImage imageNamed:@"运动"];
        ////        [image drawInRect:CGRectMake(x+w/2-5, y, 10, 15)];//在坐标中画出图片
        //        [image drawInRect:CGRectMake(x+w/2-5, y, 15, 15)];//在坐标中画出图片
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x , y, 15, 15)];
        [self addSubview:btn];
        [btn setTag:200000 + j];
        [btn setImage:GL_IMAGE(@"运动") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(recordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
    
    //用药
    for (int j=0; j<_xqdColor.chartLine_threeFloorArr.count; j++) {
        NSDictionary *dic = _xqdColor.chartLine_threeFloorArr[j];
        CGFloat x = [TimeManage PointX:dic[@"MEDICATIONTIME"]]*_xqdColor.chartLine_pointAndPointX + 10;
        //        CGFloat y = x_h+20+18+18;
        
        //图片
        //        UIImage *image = [UIImage imageNamed:@"用药"];
        //        [image drawInRect:CGRectMake(x-8, y, 15, 15)];//在坐标中画出图片
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y - 2.5, 15 + 5, 15 + 5)];
        [self addSubview:btn];
        [btn setTag:300000 + j];
        [btn setImage:GL_IMAGE(@"用药") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(recordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
    
    //胰岛素
    for (int j=0; j<_xqdColor.chartLine_fourFloorArr.count; j++) {
        NSDictionary *dic = _xqdColor.chartLine_fourFloorArr[j];
        CGFloat x = [TimeManage PointX:dic[@"MEDICATIONTIME"]]*_xqdColor.chartLine_pointAndPointX + 10;
        //        CGFloat y = x_h+20+18+18+18;
        
        //图片
        //        UIImage *image = [UIImage imageNamed:@"胰岛素"];
        //        [image drawInRect:CGRectMake(x-8, y, 15, 15)];//在坐标中画出图片
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y -2.5, 15 + 5, 15 + 5)];
        [self addSubview:btn];
        [btn setTag:400000 + j];
        [btn setImage:GL_IMAGE(@"胰岛素") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(recordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
    
}

//2016年11月15日16:07:14 活动记录的点击事件
- (void)recordBtnClick:(UIButton *)sender
{
    RecordEntity *entity = [RecordEntity new];
    RecordType    type   = DiningRecord;
    switch (sender.tag / 100000) {
        case 1: /**< 饮食 */
        {
            entity.diningEntity = [[DiningRecordEntity alloc]initWithDictionary:_xqdColor.chartLine_oneFloorArr[sender.tag - 100000]];
            type = DiningRecord;
        }
            break;
        case 2: /**< 运动 */
        {
            entity.sportsEnttiy = [[SportsRecordEntity alloc]initWithDictionary:_xqdColor.chartLine_twoFloorArr[sender.tag - 200000]];
            type = SportsRecord;
        }
            break;
        case 3: /**< 用药 */
        {
            entity.medicateEntity = [[MedicateRecordEntity alloc]initWithDictionary:_xqdColor.chartLine_threeFloorArr[sender.tag - 300000]];
            type = MedicateRecord;
        }
            break;
        case 4: /**< 胰岛素 */
        {
            entity.medicateEntity = [[MedicateRecordEntity alloc]initWithDictionary:_xqdColor.chartLine_fourFloorArr[sender.tag - 400000]];
            type = InsulinRecord;
        }
            break;
        default:
            break;
    }
    
    [GLPopupView showRecordValueForView:sender WithType:type WithEntity:entity];
}

#define POINT(_INDEX_) [self returnPoint:(_INDEX_) andArr:points]
- (UIBezierPath*)smoothedPathWithGranularity:(NSInteger)granularity andArr:(NSArray*)allArr;
{
    NSMutableArray *points = [NSMutableArray arrayWithArray:allArr];
    
    if (points.count < 4) return nil;
    
    // Add control points to make the math make sense
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    
    UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
    [smoothedPath removeAllPoints];
    smoothedPath.lineWidth     = 2.0f;
    smoothedPath.lineCapStyle  = kCGLineCapRound;
    smoothedPath.lineJoinStyle = kCGLineJoinBevel;
    
    [smoothedPath moveToPoint:POINT(0)];
    
    for (NSUInteger index = 1; index < points.count - 2; index++)
    {
        CGPoint p0 = POINT(index - 1);
        CGPoint p1 = POINT(index);
        CGPoint p2 = POINT(index + 1);
        CGPoint p3 = POINT(index + 2);
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++)
        {
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            [smoothedPath addLineToPoint:pi];
        }
        
        // Now add p2
        [smoothedPath addLineToPoint:p2];
    }
    
    // finish by adding the last point
    [smoothedPath addLineToPoint:POINT(points.count - 1)];
    
    return smoothedPath;
}
- (CGPoint)returnPoint:(NSInteger)index andArr:(NSArray*)allArr{
    NSDictionary *dic = allArr[index];
    CGFloat x_h = _xqdColor.chartLine_fream.size.height-20-_xqdColor.chartLine_foot_h+1;
    CGFloat x = [TimeManage PointX:dic[@"collectedtime"]]*_xqdColor.chartLine_pointAndPointX;
    CGFloat y = (x_h - (x_h/_xqdColor.chartLine_YMax)*[dic[@"value"] floatValue])-10;
    return CGPointMake(x, y);
}

- (void)setChartLine_Color:(UIColor *)chartLine_Color
{
    self.backgroundColor = chartLine_Color;
    _xqdColor.chartLine_Color = chartLine_Color;
}

-(void)setChartLine_pointAndPointX:(CGFloat)chartLine_pointAndPointX
{
    _xqdColor.chartLine_pointAndPointX1 = chartLine_pointAndPointX;
    _xqdColor.chartLine_pointAndPointX = chartLine_pointAndPointX;
}

- (void)setChartLine_PointArr:(NSArray *)chartLine_PointArr{
    _xqdColor.chartLine_PointArr = chartLine_PointArr;
    
    layer_lineArr = [NSMutableArray arrayWithCapacity:0];
    path_lineArr = [NSMutableArray arrayWithCapacity:0];
    
    for (int i=0; i<chartLine_PointArr.count; i++) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [layer_lineArr addObject:layer];
        [path_lineArr addObject:path];
    }
}


- (void)refreshView:(CGRect)frame{
    self.frame = frame;
    [self setNeedsDisplay];
}


@end
