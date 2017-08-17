//
//  GLEntity.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLEntity : NSObject

/**
 通过字典中Key值对应模型属性的名字来赋值

 @param dict 字典
 @return 赋值后的模型
 */
- (instancetype)initWithDictionary:(NSDictionary*)dict;


/**
 *  获取对象的所有属性的数组
 *
 *  @return 返回包含对象的所有属性数组
 */
- (NSArray *)getAllProperties;

/**
 *   获取对象的所有属性和属性内容的字典
 *
 *  @return  返回包含对象的所有属性和属性内容的字典
 */
- (NSDictionary *)getAllPropertiesAndVaules;


@end
