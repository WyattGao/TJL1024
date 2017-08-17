//
//  Tools.m
//  Diabetes
//
//  Created by xuqidong on 15/10/29.
//  Copyright © 2015年 hlcc. All rights reserved.
//

#import "Tools.h"


@implementation Tools


+ (UILabel*)returnNavLab:(NSString*)title {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-180, 44)];
    lab.text = title;
    lab.textColor = RGB(0, 0, 0);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:17];
    lab.tag  = 299991;
    return lab;
}

+ (NSString*)returnNavTitle:(NSString*)title {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,title.length-1)];
    return title;

}


+ (BOOL)justStringNil:(NSString*)str{
    if (str.length == 0 || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""]) {
        return NO;
    }else{
        return YES;
    }
}
+ (NSString*)guoLv:(NSString*)str{
    if ([str isKindOfClass:[NSNull class]]) {
        return @"";
    }else{
        return str;
    }
}

//添加空页面提示
+ (UIView*)addEmptyView:(id)selfView andPic:(NSString*)pic andTitle:(NSString*)title{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200)];
    view.tag = 6677;
//    view.backgroundColor = [UIColor redColor];
    
    UIImageView *image = [UIImageView new];
    image.image = [UIImage imageNamed:pic];
    [view addSubview:image];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).offset(20);
    }];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, image.bottom+20, SCREEN_WIDTH, 30)];
    lab.text = title;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = [UIColor grayColor];
    [view addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image.mas_bottom).offset(20);
        make.centerX.equalTo(view);
    }];
    
    return view;
}


+ (UILabel *)templateLabelWithFont:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    //    label.backgroundColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    label.textColor = color;
    return label;
}

//+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
//    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
//        return (UIImageView *)view;
//    }
//    for (UIView *subview in view.subviews) {
//        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
//        if (imageView) {
//            return imageView;
//        }
//    }
//    return nil;
//}

/** 计算每月多少天 */
+ (int) getDaysOfMonthByYear:(int) year month:(int) month
{
    int days = 0;
    
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
    {
        days = 31;
    }
    else if (month == 4 || month == 6 || month == 9 || month == 11)
    {
        days = 30;
    }
    else
    { // 2月份，闰年29天、平年28天
        if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
        {
            days = 29;
        }
        else
        {
            days = 28;
        }
    }
    
    return days;
}

#pragma mark - Divide line
+ (UIView *)addDivideLineWithY:(float)y parentView:(UIView *)parentView andColor:(UIColor*)color{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, parentView.width ?: SCREEN_WIDTH, 0.5)];
    line.backgroundColor = color;
    [parentView addSubview:line];
    return line;
}

+ (UIView *)addDivideLineWithX:(float)x height:(float)height parentView:(UIView *)parentView andColor:(UIColor*)color{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, 0, 0.5, height)];
    line.backgroundColor = color;
    [parentView addSubview:line];
    return line;
}

+(BOOL)validateMobile:(NSString *)mobileNum
{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^1[3|4|5|7|8][0-9][0-9]{8}$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    
    
    
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:mobileNum
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, mobileNum.length)];
    
    
    if(numberofMatch > 0)
    {
        return YES;
    }
    
    return NO;
}


#pragma mark - －判断血压高低
+ (NSString*)justBlood:(CGFloat)blood andTime:(int)time{
    //    0早餐前，1早餐后, 2午餐前，3午餐后，4晚餐前，5晚餐后，6睡前，7凌晨
    if (time==0 || time==2 || time==4 || time==7) {//餐前
        if (blood<4.0) {
            return @"您的血糖过低，有低血糖的危险，请立刻补充能量哦。";
        }else if (blood>=4.0 && blood<6.1){
            return @"您的血糖控制非常棒，请继续保持";
        }else if (blood>=6.1 && blood<7.0){
            return @"您处在糖耐量受损的阶段，要加强运动和饮食管理。";
        }else if (blood>=7.0 && blood<15.0){
            return @"您的血糖控制非常不理想，是不是忘记服药了呢？";
        }else{
            return @"您非常危险，请及时到医院就诊，或者联系我们平台上的专业医生进行专业咨询！";
        }
    }else{
        if (blood<4.0) {
            return @"您的血糖过低，您是否注射胰岛素后，进餐量过少了呢？请及时联系您的医生处理。";
        }else if (blood>=4.0 && blood<7.8){
            return @"您的血糖控制非常棒，请继续保持。";
        }else if (blood>=7.8 && blood<11.0){
            return @"您处在糖耐量受损的阶段，要加强运动和饮食管理并坚持记录监测日记。";
        }else if (blood>=11.0 && blood<15.0){
            return @"您的血糖控制非常不理想，要是不是忘记服药了呢？";
        }else{
            return @"您非常危险，请及时到医院就诊，或者联系我们平台上的专业医生进行专业咨询。";
        }
    }
    
    
    
}

/**
 根据血糖高低返回血糖值的颜色
 
 @param bloodType 血糖值的高低状态
 @return 返回血糖显示需要的颜色
 */
+ (UIColor *)bloodColorWithBloodType:(int)bloodType
{
    return @[RGB(64, 165, 243),RGB(64, 165, 243),RGB(69, 219, 104),RGB(243, 43, 43),RGB(243, 43, 43),RGB(243, 43, 43)][bloodType];
}



/*
 亲们，餐前后的时间段和保存后的提示话术更新如下：
 凌晨：0-6点
 早餐前：6-8点，早餐后8-10点
 午餐前：10-13点，午餐后13-16点
 晚餐前：16-19点，晚餐后19-21点
 睡前：21-24点
 
 血糖输入范围：2.0-30.0mmol/L,保存时的提示话术:
 
 餐前和凌晨
 <4.0:您的血糖过低，有低血糖的危险，请立刻补充能量哦
 4.0-6.1：您的血糖控制非常棒，请继续保持
 6.1-7.0：您处在糖耐量受损的阶段，要加强运动和饮食管理
 7.0-15.0：您的血糖控制非常不理想，是不是忘记服药了呢？
 >15 ：您非常危险，请及时到医院就诊，或者联系我们平台上的专业医生进行专业咨询！
 
 餐后2小时和睡前提示
 <4.0:您的血糖过低，您是否注射胰岛素后，进餐量过少了呢？请及时联系您的医生处理
 4.0-7.8：您的血糖控制非常棒，请继续保持
 7.8-11.0：您处在糖耐量受损的阶段，要加强运动和饮食管理并坚持记录监测日记
 11.0-15.0：您的血糖控制非常不理想，要是不是忘记服药了呢？
 >15 ：您非常危险，请及时到医院就诊，或者联系我们平台上的专业医生进行专业咨询
 */

+(int)howManyDaysInThisMonth:(int)year month:(int)imonth {
    if((imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
        return 31;
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
        return 30;
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
    {
        return 28;
    }
    if(year%400 == 0)
        return 29;
    if(year%100 == 0)
        return 28;
    return 29;
}


+(NSString*)getAfterTime:(int)minth nowTime:(NSString *)time format:(NSString*)format{
    
//    NSLog(@"%@",time);
    //将字符串转时间格式
    NSString* string = time;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:format];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    NSLog(@"date = %@", inputDate);
    
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

+ (NSString*)stringChangeTimesp:(NSString*)time{
    //将时间字符串转成时间戳
    NSString* string = time;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
//    NSLog(@"date = %@", inputDate);
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[inputDate timeIntervalSince1970]];
//    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    return timeSp;
}


+ (NSMutableAttributedString*)HangJianJu:(NSString*)str andJianJu:(CGFloat)jianju{
    
//    NSLog(@"=-=-=-=-=====>%@",str);
    if (str.length == 0 || [str isEqual:[NSNull null]]) {
        str = @"";
    }
    
    NSMutableParagraphStyle *warnParagraph = [[NSMutableParagraphStyle alloc] init];
    warnParagraph.lineSpacing = jianju;//行间距
    NSMutableAttributedString *warnAttr = [[NSMutableAttributedString alloc] initWithString:str];
    [warnAttr addAttribute:NSParagraphStyleAttributeName value:warnParagraph range:NSMakeRange(0, str.length)];
    return warnAttr;
}

+ (CGSize)fitSize:(CGSize)thisSize inSize:(CGSize)aSize
{
    CGFloat scale;
    CGSize newsize = thisSize;
    if (newsize.height && (newsize.height > aSize.height))
    {
        scale = aSize.height / newsize.height;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    if (newsize.width && (newsize.width >= aSize.width))
    {
        scale = aSize.width / newsize.width;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    return newsize;
}

+ (UILabel *)creatLabelWithTitle:(NSString*)title AndTextColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment withFont:(NSInteger)font
{
    UILabel *label = [UILabel new];
    if (![title isKindOfClass:[NSNull class]]) {
        label.text = title;
    }
    
    label.textAlignment = alignment;
    label.font = GL_FONT(font);
    label.textColor = color;
    return label;
}
+ (UIImage *)image:(UIImage *)image fitInSize:(CGSize)viewsize
{
    CGSize size = [self fitSize:image.size inSize:viewsize];
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (float)returnStrHeight:(NSString*)str width:(CGFloat)width font:(CGFloat)font{// 计算字符串大小
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}


+ (float)returnStrWidth:(NSString *)str font:(CGFloat)font{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.width;
}


+ (CGSize)getImageSizeWithURL:(NSURL *)url
{
    NSData * data = [NSData dataWithContentsOfURL:url];
    UIImage *result = [UIImage imageWithData:data];
    NSStringFromCGSize(result.size);
    return CGSizeMake(result.size.width,result.size.height);
}



+ (NSString *)getStringFromDate:(NSDate *)aDate format:(NSString*)format
{
        NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:format];//需转换的格式
        NSString *dateStr = [dateFormater stringFromDate:aDate];
        return dateStr;
}

@end
