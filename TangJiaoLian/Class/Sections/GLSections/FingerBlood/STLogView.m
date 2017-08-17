//
//  STLogView.m
//  Diabetes
//
//  Created by xuqidong on 16/3/1.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "STLogView.h"
#import "Tools.h"

@interface STLogView()
{

}
@end

#define IntTOSting(__int__) [NSString stringWithFormat:@"%d",__int__]

@implementation STLogView


+ (UIView*)eatHeaderViewTime:(NSString*)time andIndex:(NSInteger)index{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 24)];
    view.backgroundColor = [UIColor whiteColor];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 2, view.height)];
    if (index==0) {
        line.frame = CGRectMake(30, view.height/2+10, 2, 0);
    }
    
    line.backgroundColor = RGB(241, 241, 245);
    [view addSubview:line];

    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 12, 12)];
    image.centerY = view.centerY+7;
    image.image = GL_IMAGE(@"小圈");
    [view addSubview:image];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 150, view.height-13)];
    timeLab.centerY = image.centerY;
    timeLab.textColor = RGB(128, 129, 127);
    timeLab.font = [UIFont systemFontOfSize:14];
    timeLab.text = time;
    [view addSubview:timeLab];
    
    
    return view;
}

#define form_w  SCREEN_WIDTH/9
#define form_h  46
#define Line_color RGB(241, 241, 245)
+ (UIView*)makeHeaderView{
    UIView *_TitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    _TitleView.backgroundColor = [UIColor whiteColor];
    
    for (int i=0; i<10; i++) {
        //竖线
        CGFloat hh = _TitleView.height;
        UIView *line = [Tools addDivideLineWithX:0+i*form_w height:hh parentView:_TitleView andColor:Line_color];
        if (i == 3 || i == 5 || i == 7) {
            hh = hh/2;
            line.top = hh;
            line.height = hh;
        }
    }
    
    [Tools addDivideLineWithY:0 parentView:_TitleView andColor:Line_color];
    UIView *line = [Tools addDivideLineWithY:_TitleView.height/2 parentView:_TitleView andColor:Line_color];
    line.left = 2*form_w;
    line.width = SCREEN_WIDTH-3*form_w;
    [Tools addDivideLineWithY:_TitleView.height-0.5 parentView:_TitleView andColor:Line_color];
    
    NSArray *upArr = @[@"早餐",@"午餐",@"晚餐"];
    NSArray *downArr = @[@"日期",@"凌晨",@"前",@"后",@"前",@"后",@"前",@"后",@"睡前"];
    CGFloat w_w = (SCREEN_WIDTH)/9;
    
    for (int i=0; i<downArr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0+i*w_w, 0, w_w, _TitleView.height)];
        if ([downArr[i] isEqualToString:@"前"] || [downArr[i] isEqualToString:@"后"]) {
            lab.top = lab.height = _TitleView.height/2;
        }
        
        lab.text = downArr[i];
        lab.textColor = RGB(155, 155, 155);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:(14)];
        [_TitleView addSubview:lab];
    }
    
    for (int i=0; i<upArr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(2*w_w+i*(2*w_w), 0, (2*w_w), _TitleView.height/2)];
        lab.text = upArr[i];
        lab.textColor = RGB(155, 155, 155);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:(14)];
        [_TitleView addSubview:lab];
    }
    return _TitleView;
}

+ (UIScrollView*)makeBloodSugarScrollview:(UIScrollView*)TypeScrollview andSelectYear:(int)year andMonth:(int)month andData:(NSArray*)data{
    
    NSArray *daysArr = data;
    
    UIScrollView *BloodSugarScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, TypeScrollview.height-55)];
    BloodSugarScrollview.backgroundColor = [UIColor whiteColor];
    BloodSugarScrollview.contentSize = CGSizeMake(SCREEN_WIDTH, form_h*daysArr.count);
    [TypeScrollview addSubview:BloodSugarScrollview];
    
    for (int i=0; i<daysArr.count; i++) {
        //序号
        UIButton *dateLab = [UIButton new];
        dateLab.frame = CGRectMake(0, i*form_h, form_w-0.5, form_h-0.5);
        
        NSString *time1 = daysArr[i][@"date"];
        NSArray *array = [time1 componentsSeparatedByString:@"-"];
//        dateLab.text = array[array.count-1];
        [dateLab setTitle:array[array.count-1] forState:UIControlStateNormal];
        dateLab.titleLabel.textAlignment = NSTextAlignmentCenter;
        dateLab.titleLabel.font = [UIFont systemFontOfSize:(16)];
//        dateLab.textColor = COL_MAIN_BLUE;
        [dateLab setTitleColor:RGB(74, 74, 74) forState:UIControlStateNormal];
        dateLab.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
        dateLab.tag = 989000+[array[array.count-1] intValue];
        [dateLab addTarget:self action:@selector(dateDown:) forControlEvents:UIControlEventTouchUpInside];
        [BloodSugarScrollview addSubview:dateLab];
        
        int num = [daysArr[i][@"randomnum"] intValue];
        if (num != 0) {
            //随机血糖标识
            UIView *pointView = [UIView new];
            [dateLab addSubview:pointView];
            [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-7);
                make.top.mas_equalTo(10);
                make.size.mas_equalTo(CGSizeMake(8, 8));
            }];
            pointView.layer.cornerRadius = 5;
            pointView.backgroundColor = RGB(255, 200, 73);
        } else {
            dateLab.userInteractionEnabled = false;
        }
    }
    [Tools addDivideLineWithY:daysArr.count*form_h parentView:BloodSugarScrollview andColor:Line_color];
    
    //填充数据
    for (int i=0; i<data.count; i++) {
        NSArray *dayArr = data[i][@"result"];
        for (int j=0; j<dayArr.count; j++) {
            
            CGFloat X = (j+1)*form_w;//(([dayArr[j][@"TYPE"] intValue]+1)%8+1)*form_w;
            CGFloat Y = i*form_h;
            
            UIButton *dayLab = [UIButton new];
            dayLab.frame = CGRectMake(X, Y, form_w+0.5, form_h);
            [dayLab setTitle:dayArr[(j+7)%8][@"VALUE"] forState:UIControlStateNormal];
            dayLab.titleLabel.font = [UIFont systemFontOfSize:(14)];
            dayLab.tag = 110000+i*1000+((j+7)%8);//tag
            
            
            if (j==1 || j==2 || j==5 || j==6) {
                dayLab.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
            }
            
            //血糖假数据
            /////////////////////////////////////////////////////////////////////////////////
//            if (arc4random()%10>4) {
//                [dayLab setTitle:[NSString stringWithFormat:@"%d.%d",arc4random()%10,arc4random()%10] forState:UIControlStateNormal];
//            }
            /////////////////////////////////////////////////////////////////////////////////
            
            int blood;
            if (dayLab.titleLabel.text.length!=0) {
                blood = [Tools justBlood:[dayLab.titleLabel.text floatValue] andType:[dayArr[(j+7)%8][@"TYPE"] intValue]];
            }else{
                blood = 2;
            }
            if (blood == 0 || blood == 1) {//低
                dayLab.backgroundColor = [UIColor colorWithRed:0.84f green:0.91f blue:0.97f alpha:1.00f];//RGB(247, 97, 116);
                [dayLab setTitleColor:RGB(75, 168, 240) forState:UIControlStateNormal];
            }else if (blood == 2){
                if (dayLab.titleLabel.text.length!=0) {
                    dayLab.backgroundColor = [UIColor colorWithRed:0.83f green:0.97f blue:0.87f alpha:1.00f];
                }
                [dayLab setTitleColor:RGB(59, 219, 97) forState:UIControlStateNormal];
            }else if (blood == 3 || blood == 4 || blood == 5){//高
                dayLab.backgroundColor = [UIColor colorWithRed:1.00f green:0.86f blue:0.86f alpha:1.00f];//RGB(252, 214, 113);
                [dayLab setTitleColor:RGB(251, 80, 80) forState:UIControlStateNormal];
            }
            [dayLab addTarget:self action:@selector(lodDown:) forControlEvents:UIControlEventTouchUpInside];
            dayLab.titleLabel.textAlignment = NSTextAlignmentCenter;
            [BloodSugarScrollview addSubview:dayLab];
        }
    }
    
    for (int i=0; i<data.count; i++) {
        //横线
        [Tools addDivideLineWithY:0+i*form_h parentView:BloodSugarScrollview andColor:Line_color];
    }
    for (int i=0; i<11; i++) {
        //竖线
        [Tools addDivideLineWithX:0+i*form_w height:data.count*form_h parentView:BloodSugarScrollview andColor:Line_color];
    }
    
    return BloodSugarScrollview;
}

+ (void)lodDown:(UIButton*)btn{
    int i = (int)(btn.tag-110000)/1000;
    int j = (int)(btn.tag-110000-i*1000);
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSNotification *notify = [NSNotification notificationWithName:@"bloodClick" object:@{@"i":IntTOSting(i),@"j":IntTOSting(j)}];
    [center postNotification:notify];
}

+ (void)dateDown:(UIButton*)btn{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSNotification *notify = [NSNotification notificationWithName:@"randomBloodClick" object:IntTOSting((int)btn.tag-989000)];
    [center postNotification:notify];
}


+ (NSArray*)dateArr{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    NSDate *date = [NSDate date];
    for (int i=[[date toString:@"dd"] intValue   ]; i>=1; i--) {
        [arr addObject:IntTOSting(i)];
    }
    int count = (int)[arr count];
    
    
    for (int i=(30-count); i>0; i--) {
        [arr addObject:IntTOSting(i)];
    }
    return arr;
}


+ (UIView*)jianCeHeaderTitle:(NSString*)title{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 28)];
    view.backgroundColor = RGB(246, 246, 250);
    
    UILabel *lab = [UILabel new];
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
    lab.text      = title;
    lab.font      = [UIFont systemFontOfSize:15];
    lab.textColor = RGB(128, 129, 127);
    return view;
}



@end
