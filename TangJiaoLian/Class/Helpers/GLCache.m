//
//  GLCache.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/20.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLCache.h"


#define NULL_TO_NIL(__objc) ((id)[NSNull null] == (__objc) ? nil : (__objc))

@implementation GLCache


+ (void)writeCacheArr:(NSArray *)arr name:(NSString *)name
{
    NSString *path = [DOCUMENT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"__%@",name]];
    [self writeCacheObject:arr filePath:path];
}

+ (void)writeCacheDic:(NSDictionary *)dic name:(NSString *)name
{
    NSString *path = [DOCUMENT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"__%@",name]];
    [self writeCacheObject:dic filePath:path];
}

+ (NSArray *)readCacheArrWithName:(NSString *)name
{
    NSString *path = [DOCUMENT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"__%@",name]];
    NSArray *array = [self readCachedObjectWithFilePath:path];
    if (!array) {
        array = @[];
    }
    return array;
}

+ (NSDictionary *)readCacheDicWithName:(NSString *)name
{
    NSString *path = [DOCUMENT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"__%@",name]];
    NSDictionary *dic = [self readCachedObjectWithFilePath:path];
    if (!dic) {
        dic = @{};
    }
    return dic;

}

+ (void)writeCacheObject:(id)obj filePath:(NSString *)filePath {
    obj = NULL_TO_NIL(obj);
    if (!obj) {
        return;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [data writeToFile:filePath atomically:YES];
}

+ (id)readCachedObjectWithFilePath:(NSString *)filePath {
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return obj;
}


@end
