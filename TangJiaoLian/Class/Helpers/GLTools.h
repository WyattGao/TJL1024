//
//  GLTools.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/19.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GLTools : NSDate


/**
 记录血糖仪的操作记录
 
 @param log 单条操作记录
 */
void GL_DisLog(NSString *log);

/**
 获取当前时间的字符串

 @return 返回当前时间的字符串
 */
+ (NSString *)getNowTime;



/**
 返回指定时间若干分钟后的时间

 @param minth 偏移的时间
 @param time 当前时间
 @param format 需要返回的时间格式
 @return 返回指定时间若干分钟后的时间字符串
 */
+ (NSString*)getAfterTime:(int)minth nowTime:(NSString *)time format:(NSString*)format;

/**
 *
 *  返回这个时间段的参比
 *
 *  @param time 当前电流的时间点
 *
 *  @return 返回参比
 */
+ (CGFloat)getReferenceForTtime:(NSString*)time;

/**
 返回某个时间点之前的最后一条血糖值
 
 @param time 时间点
 @return 返回的血糖数值
 */
+ (CGFloat)getLastBloodValueForTime:(NSString *)time;

/**
 检查最新的血糖数据是否需要预警

 @param dic 最新血糖数据所在的数组
 */
+ (void)checkBloodValueWarning:(NSDictionary *)dic;


/**
 根据时间线获取曲线图的默认缩放比

 @return 返回曲线图的缩放比
 */
+ (CGFloat)refreshChatLineScaling;


/**
 设备存在问题通知

 @param state 佩戴状态
 */
+ (void)CGMUILocalNotification:(int)state;


/**
 发送本地推送

 @param str 推送内容
 @param sound 是否有通知音
 */
+ (void)noti:(NSString*)str sound:(BOOL)sound;


/**
 根据请求的Type获取糖尿病类型名称

 @param type 请求的type
 @return 糖尿病名称字符串
 */
+ (NSString *)getDiabetesNameWithType:(NSInteger)type;
@end
