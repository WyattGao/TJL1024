//
//  UIImage+GL.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/30.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GL)


/**
 压缩图片到指定字节大小

 @param image 要压缩的图片
 @param maxLength 压缩之后的字节
 @return 压缩之后的图片
 */
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

@end
