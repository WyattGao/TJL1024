//
//  XQDLineChart.m
//  XQDLineGraph
//
//  Created by 徐其东 on 16/7/14.
//  Copyright © 2016年 xuqidong. All rights reserved.
//

#import "XQDLineChart.h"
#import "TimeManage.h"
#import "XQDPointView.h"

@interface XQDLineChart()<PointViewDelegate>
{
    NSMutableArray *layer_lineArr;
    NSMutableArray *path_lineArr;
//    CAShapeLayer *layer_line;
//    UIBezierPath *path_line;
    CAShapeLayer *layer_x;
    UIBezierPath *path_x;
    UIBezierPath *path_Y;
    XQDPointView *point;
    
    BOOL isAmplification;
    
    NSInteger countNum;
}

@end


@implementation XQDLineChart

- (instancetype)initWithFrame:(CGRect)frame andXQDColor:(XQDColor*)xqdColor
{
    self = [super initWithFrame:frame];
    if (self) {
        _xqdColor = xqdColor;
        
        self.backgroundColor = _xqdColor.chartLine_Color;
        _chartLine_fream = frame;
        _xqdColor.chartLine_fream = frame;
        _xqdColor.chartLine_pointAndPointX1 = _xqdColor.chartLine_pointAndPointX;
        _xqdColor.chartLine_pointAndPointX = _xqdColor.chartLine_pointAndPointX;
        
        layer_x    = [CAShapeLayer layer];
        path_x     = [UIBezierPath bezierPath];
        path_Y     = [UIBezierPath bezierPath];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    DLog(@"drawRect");
    [self drawY];
}

- (void)initLineChart{
    
    WS(ws);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(_xqdColor.chartLine_leftDistance+_xqdColor.chartLine_yWith,
                                                                  0, _chartLine_fream.size.width-_xqdColor.chartLine_leftDistance-_xqdColor.chartLine_rightDistance-_xqdColor.chartLine_yWith,
                                                                  _chartLine_fream.size.height)];
            _mainScroll.backgroundColor = _xqdColor.chartLine_Color;
            _mainScroll.backgroundColor = [UIColor clearColor];
            [self addSubview:_mainScroll];
            _mainScroll.contentSize = CGSizeMake(_xqdColor.chartLine_Xarr.count*_xqdColor.chartLine_pointAndPointX, _chartLine_fream.size.height);
            
            point = [[XQDPointView alloc] initWithFrame:CGRectMake(0, 0, _mainScroll.contentSize.width, _mainScroll.contentSize.height) andXQDColor:_xqdColor];
            [_mainScroll addSubview:point];
            
            if (_xqdColor.chartLine_tap) {
                // 1. 创建一个"轻触手势对象"
                
                //双击手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
                
                // 点击几次
                tap.numberOfTapsRequired = 2;
                [_mainScroll addGestureRecognizer:tap];
                
                //单击手势
                UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
                oneTap.numberOfTapsRequired = 1;
                [_mainScroll addGestureRecognizer:oneTap];
                
                
                // 2. 捏合手势
                UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
                [_mainScroll addGestureRecognizer:pinch];
            }

            
        });
        
    });
}
//刷新图
- (void)refreshChartLine:(XQDColor*)xqdColor{
    _xqdColor = xqdColor;
    
    if (!_xqdColor.isMoreLine) {
        _xqdColor.chartLine_pointAndPointX = 20 * [self refreshChatLineScaling];
    }
   


    _mainScroll.contentSize = CGSizeMake(_xqdColor.chartLine_Xarr.count * _xqdColor.chartLine_pointAndPointX, _chartLine_fream.size.height);
    
    if (_mainScroll.contentSize.width < _mainScroll.width) {
        _xqdColor.chartLine_pointAndPointX = _mainScroll.frame.size.width/_xqdColor.chartLine_Xarr.count;
        _mainScroll.contentSize = CGSizeMake(_mainScroll.frame.size.width, _mainScroll.frame.size.height);
    }
    
    WS(ws);

    
    dispatch_async(dispatch_get_main_queue(), ^{
        [point removeFromSuperview];
        
        point = [[XQDPointView alloc] initWithFrame:CGRectMake(0, 0, _mainScroll.contentSize.width, _mainScroll.contentSize.height) andXQDColor:_xqdColor];
        point.delegate = ws; //刷新住sv的代理
        [_mainScroll addSubview:point];
    });

    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        point.xqdColor = _xqdColor;
        [point setChartLine_PointArr:_xqdColor.chartLine_PointArr];
        point.frame = CCR(0, 0, _mainScroll.contentSize.width, _mainScroll.contentSize.height);
        [point setNeedsDisplay];
    });
   
     /*
    //延时运行
    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [ws setRefresh];
    });
     */
}

- (CGFloat)refreshChatLineScaling
{
    NSInteger day = [TimeManage dayToDay:CGM_Start_Time andEnd:CGM_Ending_Time];
    
    if (day > 2  && day <= 4) {
        return 1.2f;
    } else if(day > 4 && day <= 5){
        return 1.0f;
    } else if(day > 5 && day <= 7){
        return 0.6f;
    } else if(day > 7){
        return 0.4f;
    } else {
        return 1.5f;
    }
}

//将scrollview定位到当前的时间点(将当前时间点定位到中间位置)
- (void)goToNowPoint{
    CGFloat count = [TimeManage PointX:[[NSDate date] toString:@"yyyy-MM-dd HH:mm:ss"]];
    CGFloat ww = _xqdColor.chartLine_pointAndPointX*count-(SCREEN_WIDTH-_xqdColor.chartLine_leftDistance)/2-_xqdColor.chartLine_leftDistance;
    _mainScroll.contentOffset = CGPointMake(ww, 0);
}


//y轴
- (void)drawY{
    NSString *str = @"(mmol/L)";
    [str drawInRect:CGRectMake(5, 5, 100, 20) withAttributes:@{NSFontAttributeName:GL_FONT(10),NSForegroundColorAttributeName:_xqdColor.chartLine_XYTextColor}];
    
    if (!_xqdColor.isMoreLine) {
        NSString *str1 = @"绿色区域为正常范围";
        [str1 drawInRect:CGRectMake(SCREEN_WIDTH-130, 5, 130, 20) withAttributes:@{NSFontAttributeName:GL_FONT(12),NSForegroundColorAttributeName:RGB(168, 168, 168)}];
    }

    
    //最上层的线
    //最下层的线
    for (int i=0; i<2; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0,i*_chartLine_fream.size.height)];
        [path addLineToPoint:CGPointMake(SCREEN_WIDTH, i*_chartLine_fream.size.height)];
        [path closePath];
        
        path.lineWidth = 1.0f;
        UIColor *strokeColor = RGB(237, 237, 237);
        [strokeColor set];
        [path stroke];
    }
    
    
    //y轴
    CGFloat x_h = _chartLine_fream.size.height-20-_xqdColor.chartLine_foot_h;
    
//    UIBezierPath *path = [UIBezierPath bezierPath];
    [path_Y removeAllPoints];
    [path_Y moveToPoint:CGPointMake(_xqdColor.chartLine_yWith-1,20)];
    [path_Y addLineToPoint:CGPointMake(_xqdColor.chartLine_yWith-1, x_h)];
    [path_Y closePath];
    
    path_Y.lineWidth = 1.0f;
    UIColor *strokeColor = _xqdColor.chartLine_XYColor;
    [strokeColor set];
    [path_Y stroke];
    
    //y轴刻度
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
    for (NSString *y in _xqdColor.chartLine_Yarr) {
        CGFloat top = (x_h - (x_h/_xqdColor.chartLine_YMax)*[y floatValue])-10;
        [y drawInRect:CGRectMake(10, top, _xqdColor.chartLine_yWith, 20) withAttributes:@{NSFontAttributeName:GL_FONT(CHARTLINE_Y_FONT),NSForegroundColorAttributeName:_xqdColor.chartLine_XYTextColor}];
    }
}

// 轻触手势监听方法
- (void)tapGesture:(UITapGestureRecognizer *)tap {
    DLog(@"轻触手势");
    if (tap.numberOfTapsRequired == 1) {
        [GLPopupView dismiss];
    } else {
        if (_mainScroll.contentSize.width == _mainScroll.frame.size.width) {//需要放大
            _xqdColor.chartLine_pointAndPointX = _xqdColor.chartLine_pointAndPointX1;
            _mainScroll.contentSize = CGSizeMake(_xqdColor.chartLine_Xarr.count*_xqdColor.chartLine_pointAndPointX, _mainScroll.frame.size.height);
            if (_mainScroll.contentSize.width < _mainScroll.width) {
                _xqdColor.chartLine_pointAndPointX = _mainScroll.frame.size.width/_xqdColor.chartLine_Xarr.count;
                _mainScroll.contentSize = CGSizeMake(_mainScroll.frame.size.width, _mainScroll.frame.size.height);
            }
        }else{//需要缩小
            _xqdColor.chartLine_pointAndPointX = _mainScroll.frame.size.width/_xqdColor.chartLine_Xarr.count;
            _mainScroll.contentSize = CGSizeMake(_mainScroll.frame.size.width, _mainScroll.frame.size.height);
        }
        [self setRefresh];
    }
}

- (void)minChartLineView{
    _xqdColor.chartLine_pointAndPointX = _mainScroll.frame.size.width/_xqdColor.chartLine_Xarr.count;
    _mainScroll.contentSize = CGSizeMake(_mainScroll.frame.size.width, _mainScroll.frame.size.height);
    [self setRefresh];
}

// 捏合手势监听方法
- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    DLog(@"捏合手势");
    CGFloat S_w =  _mainScroll.contentSize.width * recognizer.scale;//缩小后的scrollview的容积宽
    CGFloat max_w =  _xqdColor.chartLine_pointAndPointX1*_xqdColor.chartLine_Xarr.count;
    if (S_w>_mainScroll.frame.size.width && S_w<max_w) {
        [UIView animateWithDuration:0.25 animations:^{
            _mainScroll.contentSize = CGSizeMake(S_w, _mainScroll.contentSize.height);
        }];
        _xqdColor.chartLine_pointAndPointX = S_w/_xqdColor.chartLine_Xarr.count;
//        [self setNeedsDisplay];
        [self setRefresh];
    }else if (S_w>max_w){
        [UIView animateWithDuration:0.25 animations:^{
            _mainScroll.contentSize = CGSizeMake(max_w, _mainScroll.contentSize.height);
        }];
        _xqdColor.chartLine_pointAndPointX = _xqdColor.chartLine_pointAndPointX1;
//        [self setNeedsDisplay];
        [self setRefresh];
    }else if (S_w<_mainScroll.frame.size.width){
        [UIView animateWithDuration:0.25 animations:^{
            _mainScroll.contentSize = CGSizeMake(_mainScroll.frame.size.width, _mainScroll.contentSize.height);
        }];
        _xqdColor.chartLine_pointAndPointX = _mainScroll.frame.size.width/_xqdColor.chartLine_Xarr.count;
//        [self setNeedsDisplay];
        [self setRefresh];
    }
}


- (void)setRefresh{
    dispatch_async(dispatch_get_main_queue(), ^{
        [point refreshView:CGRectMake(0, 0, _mainScroll.contentSize.width, _mainScroll.contentSize.height)];
    });
}


#pragma mark - PonitViewDelegate
- (void)reloadMainSVWithPointX:(CGFloat)pointX
{
    //先判断返回的是否有有效坐标
    dispatch_async(dispatch_get_main_queue(), ^{
        if (pointX) {
            if ([[[_xqdColor.chartLine_PointArr lastObject] lastObject] count]) {
                if (_mainScroll.contentSize.width != _mainScroll.frame.size.width) {
                    //pointx大于第一屏
                    if (pointX > _mainScroll.width) {
                        if (pointX <= _mainScroll.contentSize.width - _mainScroll.width/2) {
                            [_mainScroll setContentOffset:CGPointMake(pointX - _mainScroll.width/2, 0) animated:false];
                        } else {
                            [_mainScroll setContentOffset:CGPointMake(_mainScroll.contentSize.width - _mainScroll.width, 0) animated:false];
                        }
                    } else {
                        [_mainScroll setContentOffset:CGPointMake(0, 0) animated:false];
                    }
                }
            }
        } else {
            [_mainScroll setContentOffset:CGPointMake(0, 0) animated:false];
        }
    });
}




@end
