//
//  Tools.h
//  Diabetes
//
//  Created by xuqidong on 15/10/29.
//  Copyright © 2015年 hlcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define JUSTSTRINGNIL(__str__) [Tools justStringNil:__str__]
#define GUOLV(__str__) [Tools guoLv:__str__]

@interface Tools : NSObject

//返回导航条的标题lab
+ (UILabel*)returnNavLab:(NSString*)title;

//利用正则表达式验证手机号码的合法性
+(BOOL)validateMobile:(NSString *)mobileNum;

//创建返回一个label
+ (UILabel *)creatLabelWithTitle:(NSString*)title AndTextColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment withFont:(NSInteger)font;

//判断字符串是否为空
+ (BOOL)justStringNil:(NSString*)str;
+ (NSString*)guoLv:(NSString*)str;

/**
 *  添加标题
 *  @param title 标题
 *  @return
 */


//添加空页面提示
+ (UIView*)addEmptyView:(id)selfView andPic:(NSString*)pic andTitle:(NSString*)title;
/** 去除导航底部的线 */
//+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view;
//创建Lab
+ (UILabel *)templateLabelWithFont:(UIFont *)font color:(UIColor *)color;

/** 计算当前月份的天数 */
+ (int) getDaysOfMonthByYear:(int) year month:(int) month;
/** 返回三分钟后的时间*/
+(NSString*)getAfterTime:(int)minth nowTime:(NSString *)time format:(NSString*)format;
/** 返回格式化的时间字符串*/
+ (NSString *)getStringFromDate:(NSDate *)aDate format:(NSString*)format;
/* 将字符串格式的时间 转成 时间戳 */
+ (NSString*)stringChangeTimesp:(NSString*)time;


/**
 添加横向分割线
 **/
+ (UIView *)addDivideLineWithY:(float)y parentView:(UIView *)parentView andColor:(UIColor*)color;
/**
 添加竖向分割线
 **/
+ (UIView *)addDivideLineWithX:(float)x height:(float)height parentView:(UIView *)parentView andColor:(UIColor*)color;


+ (NSString*)justBlood:(CGFloat)blood andTime:(int)time;
+ (int)justBlood:(CGFloat)blood andType:(int)type;

//返回天数
+(int)howManyDaysInThisMonth:(int)year month:(int)imonth;

/**
 *  @author Xu Qi Dong, 15-11-16 16:11:28
 *
 *  返回带有行间距的字符串
 *
 *  @param str    内容
 *  @param jianju 要设置的行间距
 *
 *  @return 返回带有行间距的字符串
 */
+ (NSMutableAttributedString*)HangJianJu:(NSString*)str andJianJu:(CGFloat)jianju;

//截取图片

+ (UIImage *)image:(UIImage *)image fitInSize:(CGSize)viewsize;

/**
 计算字符串的高
 **/
+ (float)returnStrHeight:(NSString*)str width:(CGFloat)width font:(CGFloat)font;
/**
 *  返回字符串的宽度
 *  @return 返回字符串的宽度
 */
+ (float)returnStrWidth:(NSString *)str font:(CGFloat)font;


/**
 返回网络图片的宽高
 **/
+ (CGSize)getImageSizeWithURL:(NSURL *)url;



/**
 根据血糖高低返回血糖值的颜色

 @param bloodType 血糖值的高低状态
 @return 返回血糖显示需要的颜色
 */
+ (UIColor *)bloodColorWithBloodType:(int)bloodType;

@end
