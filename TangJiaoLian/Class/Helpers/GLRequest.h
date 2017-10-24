//
//  GLRequest.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/18.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#define GL_Requst [GLRequest request]

typedef NS_ENUM(NSInteger,APIType) {
    API_HOST = 0,  /**< 糖教练接口 */
    API_YZ = 1, /**< 有赞接口 */
};

@class GLRequest;

@protocol GLRequestDelegate <NSObject>

- (void)GLRequest:(GLRequest *)request finished:(NSString *)response;
- (void)GLRequest:(GLRequest *)request Error:(NSString *)error;

@end


@interface GLRequest : NSObject

@property (nonatomic,assign) id <GLRequestDelegate> delegate;

/**
 *[AFNetWorking]的operationManager对象
 */
@property (nonatomic, strong) AFHTTPSessionManager* operationManager;

/**
 *当前的请求operation队列
 */
@property (nonatomic, strong) NSOperationQueue* operationQueue;

/**
 *功能: 创建CMRequest的对象方法
 */
+ (instancetype)request;

/**
 *功能：GET请求
 *参数：(1)请求的url: urlString
 *     (2)请求成功调用的Block: success
 *     (3)请求失败调用的Block: failure
 */
- (void)GET:(NSString *)URLString
 parameters:(NSDictionary*)parameters
    success:(void (^)(GLRequest *, NSString *))success
    failure:(void (^)(GLRequest *, NSError *))failure;

/**
 *功能：POST请求
 *参数：(1)请求的接口类型: apiType
 *     (2)POST请求体参数:parameters
 *     (3)是否显示网络请求状态: SvpShow
 *     (4)请求成功调用的Block: success
 *     (5)请求失败调用的Block: failure
 */
- (void)POST:(APIType)apiType
  parameters:(NSDictionary*)parameters
     SvpShow:(BOOL)show
     success:(void (^)(GLRequest *request, id response))success
     failure:(void (^)(GLRequest *request, NSError *error))failure;

-(void)postWithAPIType:(APIType)type
            Parameters:(NSDictionary *)parameters
               SvpShow:(BOOL)show
               success:(void (^)(GLRequest *, id))success
               failure:(void (^)(GLRequest *, NSError *))failure;


- (void)postWithParameters:(NSDictionary *)parameters
         SvpShow:(BOOL)show
     success:(void (^)(GLRequest *request, id response))success
     failure:(void (^)(GLRequest *request, NSError *error))failure;

/**
 *  post请求
 *
 *  @param URLString  请求网址
 *  @param parameters 请求参数
 */
- (void)postWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters;


/**
 *  get 请求
 *
 *  @param URLString 请求网址
 */
- (void)getWithURL:(NSString *)URLString;

/**
 *取消当前请求队列的所有请求
 */
- (void)cancelAllOperations;



@end
