//
//  GLTools.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/19.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLTools.h"
#import <AudioToolbox/AudioToolbox.h>

//static SystemSoundID shake_sound_male_id = 0;

@implementation GLTools

+ (NSString *)getNowTime
{
    return [[NSDate date] toString:@"yyyy-MM-dd HH:mm:ss"];
}

void GL_DisLog(NSString *log){
    NSArray *arr = [GL_USERDEFAULTS valueForKey:@"allLog"];
    NSMutableArray *logArr;
    if (arr && [arr isKindOfClass:[NSArray class]]) {
        logArr = [NSMutableArray arrayWithArray:arr];
    } else {
        logArr = [NSMutableArray array];
    }
    
    [logArr addObject:@{@"time":[[NSDate date] toString:@"yyyy-MM-dd HH:ss:mm"],@"log":log}];
    [GL_USERDEFAULTS setValue:[NSArray arrayWithArray:logArr] forKey:@"allLog"];
}

+(NSString*)getAfterTime:(int)minth nowTime:(NSString *)time format:(NSString*)format{
    //将字符串转时间格式
    NSString* string = time;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:format];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[inputDate timeIntervalSince1970]];
    
    //增加后的时间戳
    NSInteger addTimeSp = [timeSp integerValue]+minth*60;
    
    //将时间戳转时间格式
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:addTimeSp];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:format];
    NSString *str = [outputFormatter stringFromDate:confromTimesp];
    //    NSLog(@"testDate:%@", str);
    
    return str;
}

/**
 *
 *  返回这个时间段的参比
 *
 *  @param time 当前电流的时间点
 *
 *  @return 返回参比
 */
+ (CGFloat)getReferenceForTtime:(NSString*)time{

    NSArray *referenceArr = [GLCache readCacheArrWithName:SamReferenceArr];
    if (referenceArr.count==0) {
        return 0;
    }
    
    //取当前电流时间 转成时间戳
    NSInteger currentTime = [[time toDate:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970];
    
//    if (referenceArr.count==1) {
//        NSString *firstReference = [referenceArr firstObject][@"collectedtime"];
//        NSInteger upTimeSP       = [[firstReference toDate:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970];
//        
//        /**
//         * @brief 修改 去掉判断 电流时间大于上传时间
//         */
//        BOOL up = currentTime > upTimeSP;
//        if (up) {
//            return referenceArr[0][@"value"];
//        }else{
//            return @"0";
//        }
//    }
    
    if (referenceArr.count) {
        for (NSInteger i = referenceArr.count ; i>0; i--) {
            NSString *referenceTime = referenceArr[i-1][@"collectedtime"];
            NSInteger upTimeSP   = [[referenceTime toDate:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970];
            if (currentTime  > upTimeSP) {
                return [referenceArr[i-1][@"value"] floatValue];
            }
        }
    }
    
    //默认返回最新的一个参比
    return 0;
}


/**
 返回某个时间点之前的最后一条血糖值

 @param time 时间点
 @return 返回的血糖数值
 */
+ (CGFloat)getLastBloodValueForTime:(NSString *)time WithBloodArr:(NSArray *)bloodArr
{
//    NSArray *bloodArr = [GLCache readCacheArrWithName:SamBloodValueArr];
    if (![bloodArr count]) {
        return 0;
    }
    
    NSInteger currentTime = [[time toDate:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970];
    for (NSInteger i = (bloodArr.count - 1) ; i>=0; i--) {
        DLog(@"i == %ld",i);
        NSString *bloodTime = bloodArr[i][@"collectedtime"];
        NSInteger upTimeSP   = [[bloodTime toDate:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970];
        if (currentTime  > upTimeSP) {
            return [bloodArr[i][@"value"] floatValue];
        }
    }
    
    return 0;
}

+ (CGFloat)getAfterBloodValueForTime:(NSString *)time WithBloodArr:(NSArray *)bloodArr
{
    if (![bloodArr count]) {
        return 0;
    }
    
    NSInteger currentTime = [[time toDate:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970];
    for (NSInteger i = 0 ; i< bloodArr.count; i++) {
        NSString *bloodTime = bloodArr[i][@"collectedtime"];
        NSInteger upTimeSP   = [[bloodTime toDate:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970];
        if (currentTime  < upTimeSP) {
            return [bloodArr[i][@"value"] floatValue];
        }
    }
    
    return 0;
}

+ (void)checkBloodValueWarning:(NSDictionary *)dic;
{
    CGFloat bloodValue      = [dic getFloatValue:@"value"];
    NSString *collectedtime = [dic getStringValue:@"collectedtime"];
    //判断数据是否要预警
    if (bloodValue > 0) {
        if (bloodValue <= [GL_USERDEFAULTS getFloatValue:SamTargetLow] || bloodValue >= [GL_USERDEFAULTS getFloatValue:SamTargetHeight]) {
            NSMutableArray *muArr = [NSMutableArray arrayWithArray:[GLCache readCacheArrWithName:SamTargetWarningArr]];
            [muArr addObject:dic];
            [GLCache writeCacheArr:muArr name:SamTargetWarningArr];
            
            //高值是否进行过预警（每次设定一个控糖目标值只预警一次）
            if (bloodValue >= [GL_USERDEFAULTS getFloatValue:SamTargetHeight]) {
                if ([GL_USERDEFAULTS boolForKey:SAMISHIGHWARNING]) {
                    return;
                } else {
                    [GL_USERDEFAULTS setBool:true forKey:SAMISHIGHWARNING];
                }
            }
            
            //低值是否进行过预警
            if (bloodValue <= [GL_USERDEFAULTS getFloatValue:SamTargetLow]) {
                if ([GL_USERDEFAULTS boolForKey:SAMISLOWWARNING]) {
                    return;
                } else {
                    [GL_USERDEFAULTS setBool:true forKey:SAMISLOWWARNING];
                }
            }
            
            NSString *highLowStr =  bloodValue <= [GL_USERDEFAULTS getFloatValue:SamTargetLow] ? @"血糖值低于监测目标":@"血糖值高于监测目标";
            
            NSString *tipStr = [NSString stringWithFormat:@"%@  血糖值:%.1lfmmol/L 电量:%@%%",[[collectedtime  toDate:@"yyyy-MM-dd HH:mm:ss"] toString:@"HH:mm:ss"],bloodValue,[GL_USERDEFAULTS getStringValue:SamBangDingDeviceBattery]];
            //血糖预警提示 如果程序在前台收不到通知就弹框并震动和主动播放声音
            if(GL_APPLICATION.applicationState == UIApplicationStateActive){
                dispatch_async(dispatch_get_main_queue(), ^{
                    GL_ALERT(highLowStr, tipStr, nil, @"确定",nil);
                });
                
                //初始化音频对象
                /*
                NSString *path = [[NSBundle mainBundle] pathForResource:@"6464" ofType:@"wav"];
                AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
                AudioServicesPlaySystemSound(shake_sound_male_id);
                */
            }
            
            [GLTools noti:tipStr isWarning:true];
        }
    }
}

+ (NSInteger)dateDifferWithStartTime:(NSString*)start andEnd:(NSString*)end{
    NSString *format = @"yyyy-MM-dd HH:mm:ss";
    if (![[[start toDate:format] toString:@"HH"] isEqualToString:@"00"]) {
        start = [[start toDate:format] toString:@"yyyy-MM-dd 00:00:00"];
    }
    if (![[[end toDate:format] toString:@"HH"] isEqualToString:@"00"]) {
        //取最后一天的下一天的日期的0点
        NSTimeInterval endDayAfter = [[end toDate:format] timeIntervalSince1970] + 3600 * 24;
        end = [[NSDate dateWithTimeIntervalSince1970:endDayAfter] toString:@"yyyy-MM-dd 00:00:00"];
    }
    NSInteger startSp = [[start toDate:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970];
    NSInteger nowSp = [[end toDate:@"yyyy-MM-dd HH:mm:ss"] timeIntervalSince1970];
    
    CGFloat count = ([@(nowSp) floatValue]-[@(startSp) floatValue])/(60.0f*60.0f*24.0f);
    return [@(count) integerValue];
}

+ (CGFloat)refreshChatLineScaling
{
    NSInteger day = [GLTools dateDifferWithStartTime:CGM_Start_Time andEnd:CGM_Ending_Time];
    
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

+ (void)CGMUILocalNotification:(int)state{
    if (![GL_USERDEFAULTS boolForKey:SAMISWEARWARNING]) {
        NSString *stateStr;
        if (state==LOW30) {
            stateStr = @"设备佩戴位置或设备本身可能存在问题";
        }else if (state==HEIGH600){
            stateStr = @"设备可能存在短路问题";
        }else{
            stateStr = @"监测电流值正常";
        }
        
        if(GL_APPLICATION.applicationState == UIApplicationStateActive){
            GL_ALERT(nil, stateStr, 20170330, @"确定",nil);
        }
        [GLTools noti:stateStr isWarning:true];
        [GL_USERDEFAULTS setBool:true forKey:SAMISWEARWARNING];
    }
}

+ (void)noti:(NSString*)str isWarning:(BOOL)isWarning{
    
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = 1;   //先将角标数量设为1 否则不能触发清零操作
    app.applicationIconBadgeNumber = 0;   //将之前的推送清除
    [app cancelAllLocalNotifications];
    
    //    发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification != nil) {
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertAction = @"打开";
        
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = str;
        if ([GL_USERDEFAULTS getIntegerValue:SamIsAudio] == 2) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        } else {
            notification.soundName = @"6464.wav";
        }
        if ([GL_USERDEFAULTS getIntegerValue:SamIsShake] && isWarning) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"warningPush" object:nil];
        }
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

+ (NSString *)getDiabetesNameWithType:(NSInteger)type
{
    switch (type) {
        case 1:return @"一型糖尿病";break;
        case 2:return @"二型糖尿病";break;
        case 3:return @"妊娠糖尿病";break;
        case 4:return @"特殊糖尿病";break;
        default:return @"";break;
    }
}

//0早餐前，1早餐后, 2午餐前，3午餐后，4晚餐前，5晚餐后，6睡前，7凌晨
+ (NSInteger)BloodSugarBeforeOrAfterMeal:(NSInteger)type
{
    if (type == 0 || type == 2 || type == 4 || type == 6 || type == 7) {
        return 1;
    } else {
        return 2;
    }
}


@end
