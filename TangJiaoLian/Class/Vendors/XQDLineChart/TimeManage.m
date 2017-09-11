//
//  TimeManage.m
//  DVLineChart
//
//  Created by 徐其东 on 16/6/24.
//  Copyright © 2016年 Fire. All rights reserved.
//

#import "TimeManage.h"

@implementation TimeManage


+ (NSArray*)allPoint:(NSArray*)xarr{
    
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<xarr.count; i++) {
        NSDictionary *dic = @{@"collectedtime":xarr[i],@"value":[NSString stringWithFormat:@"%d",arc4random()%4+5]};
        [muArr addObject:dic];
    }
    
    return muArr;
}


+ (NSArray*)XAllTimeAndStarTime:(NSString*)startTime andEndTime:(NSString*)endTime {
    
    if (startTime==nil) {
        startTime = endTime;
    }
    startTime =  [startTime stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    endTime =  [endTime stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
    [[NSUserDefaults standardUserDefaults]setObject:startTime forKey:@"xStartTime"];
    
    //返回x轴的时间点
    //开始时间到结束时间，每三分钟一个点
    NSString *format = @"yyyy-MM-dd HH:mm:ss";
    NSString *startSp = [TimeManage timeSp:startTime format:format];
    NSString *endSp = [TimeManage timeSp:endTime format:format];
    NSInteger addTimeSp = 3*60;
    NSInteger count = ([endSp integerValue]-[startSp integerValue])/addTimeSp+5;
    
    NSMutableArray *xAllArrMu = [NSMutableArray arrayWithCapacity:0];
    
    //记录上一个时间
    NSString *tmpTimeStr = [NSString string];
    for (int i=0; i<count; i++) {
        NSString *timeStr = [TimeManage getAfterTime:3*i nowTime:startTime format:format];
        
//        NSDate *timeDate  = [timeStr toDate:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *dayStr  = [timeDate toString:@"dd"];
//        //每一天的开始显示月日
//        if (![dayStr isEqualToString:tmpTimeStr]) {
//            timeStr = [timeDate toString:@"MM月dd日 HH:mm"];
//        } else {
//            timeStr = [timeDate toString:@"dd日 HH:mm"];
//        }
//        tmpTimeStr = dayStr;
        
        [xAllArrMu addObject:timeStr];
    }
    
    return xAllArrMu;
}

+ (double)PointX:(NSString*)nowTime {
    NSString *startTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"xStartTime"];
    
//    NSMutableString *str = [NSMutableString stringWithString:nowTime];
//    [str replaceCharactersInRange:NSMakeRange(17, 2) withString:@"00"];
//    nowTime = str;
    
    
    NSString *format = @"yyyy-MM-dd HH:mm:ss";
    NSString *startSp = [TimeManage timeSp:startTime format:format];
    NSString *nowSp = [TimeManage timeSp:nowTime format:format];
    NSInteger addTimeSp = 3*60;
    double yushu = ([nowSp integerValue]-[startSp integerValue])%addTimeSp;
    double count = ([nowSp integerValue]-[startSp integerValue])/addTimeSp+yushu/180;

    return count;
}

+ (double)morePointX:(NSString*)nowTime {
    NSString *startTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"xStartTime"];
    
//    NSMutableString *str = [NSMutableString stringWithString:nowTime];
//    [str replaceCharactersInRange:NSMakeRange(0, 10) withString:[startTime substringToIndex:10]];
//    nowTime = str;
    
    NSString *oneDayStartTime = [[CGM_Start_Time toDate:@"yyyy-MM-dd HH:mm:ss"] toString:@"yyyy-MM-dd"];
    
    NSString *format = @"yyyy-MM-dd HH:mm:ss";
    NSString *startSp = [TimeManage timeSp:[NSString stringWithFormat:@"%@ %@",oneDayStartTime,[[startTime toDate:@"yyyy-MM-dd HH:mm:ss"] toString:@"HH:mm:ss"]] format:format];
    NSString *nowSp = [TimeManage timeSp:[NSString stringWithFormat:@"%@ %@",oneDayStartTime,[[nowTime toDate:@"yyyy-MM-dd HH:mm:ss"] toString:@"HH:mm:ss"]] format:format];
    NSInteger addTimeSp = 3*60;
    double yushu = ([nowSp integerValue]-[startSp integerValue])%addTimeSp;
    double count = ([nowSp integerValue]-[startSp integerValue])/addTimeSp+yushu/180;
    
    return count;
}



//返回时间戳
+(NSString*)timeSp:(NSString*)time format:(NSString*)format{
    NSString* string = time;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:format];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[inputDate timeIntervalSince1970]];
    return timeSp;
}

+(NSString*)getAfterTime:(int)minth nowTime:(NSString *)time format:(NSString*)format{
    
    //    NSLog(@"%@",time);
    //将字符串转时间格式
    NSString* string = time;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:format];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[inputDate timeIntervalSince1970]];
    //    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    
    //增加后的时间戳
    NSInteger addTimeSp = [timeSp integerValue]+minth*60;
    //    NSLog(@"addDate = %ld",addTimeSp);
    
    //将时间戳转时间格式
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:addTimeSp];
    //    NSLog(@"%ld  = %@",addTimeSp,confromTimesp);
    
    
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:format];
    NSString *str = [outputFormatter stringFromDate:confromTimesp];
    //    NSLog(@"testDate:%@", str);
    
    return str;
}

+ (NSString *)getStringFromDate:(NSDate *)aDate format:(NSString*)format
{
    NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:format];//需转换的格式
    NSString *dateStr = [dateFormater stringFromDate:aDate];
    return dateStr;
}


+ (NSInteger)dayToDay:(NSString*)start andEnd:(NSString*)end{
    NSString *format = @"yyyy-MM-dd HH:mm:ss";
    if (![[[start toDate:format] toString:@"HH"] isEqualToString:@"00"]) {
        start = [[start toDate:format] toString:@"yyyy-MM-dd 00:00:00"];
    }
    if (![[[end toDate:format] toString:@"HH"] isEqualToString:@"00"]) {
        //取最后一天的下一天的日期的0点
        NSTimeInterval endDayAfter = [[end toDate:format] timeIntervalSince1970] + 3600 * 24;
        end = [[NSDate dateWithTimeIntervalSince1970:endDayAfter] toString:@"yyyy-MM-dd 00:00:00"];
    }
    NSString *startSp = [TimeManage timeSp:start format:format];
    NSString *nowSp = [TimeManage timeSp:end format:format];
    
    //2016年11月24日16:06:28
    double count = (([nowSp floatValue]-[startSp floatValue])/(60*60*24));
    
    return [@(count) integerValue];
    
//    if ([start substringWithRange:NSMakeRange(8, 2)]!=[end substringWithRange:NSMakeRange(8, 2)]) {
//        count++;
//    }
    
    /**
     * @brief 10.25 15:27 修改 count-1;
     */
//    return (int)count+1;
}

@end
