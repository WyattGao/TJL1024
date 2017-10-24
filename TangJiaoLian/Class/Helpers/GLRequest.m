//
//  GLRequest.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/18.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLRequest.h"

@implementation GLRequest

+ (instancetype)request {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.operationManager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (void)GET:(NSString *)URLString
 parameters:(NSDictionary*)parameters
    success:(void (^)(GLRequest *, NSString *))success
    failure:(void (^)(GLRequest *, NSError *))failure {
    
    self.operationQueue=self.operationManager.operationQueue;
    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    [self.operationManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *responseJson = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"[GLRequest]: %@",responseJson);
        success(self,responseJson);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"[GLRequest]: %@",error.localizedDescription);
        failure(self,error);
    }];
    
}

- (void)POST:(APIType)apiType
  parameters:(NSDictionary*)parameters
     SvpShow:(BOOL)show
     success:(void (^)(GLRequest *request, id response))success
     failure:(void (^)(GLRequest *request, NSError *error))failure{
    
    self.operationQueue                                     = self.operationManager.operationQueue;
    self.operationManager.responseSerializer                = [AFHTTPResponseSerializer serializer];
    self.operationManager.requestSerializer.timeoutInterval = 10.0f;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = @"";
    
    switch (apiType) {
        case API_HOST:
            urlString  = HOST_URL;
            parameters = @{@"param" : json};
            break;
        case API_YZ:
            urlString = YZLOGIN_URL;
            break;
        default:
            break;
    }
    
    if (show) {
        [SVProgressHUD show];
    }
    
    NSLog(@"[GLRequest 请求参数]: %@",parameters);

    [self.operationManager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString* responseJson = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"[GLRequest]: %@",responseJson);
        
        NSData *responseData = [responseJson dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *err;
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&err];
        
        if (data == nil) {
            data= @{};
        }
        
        if (show) {
            [SVProgressHUD dismiss];
        }
        success(self,data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"[GLRequest]: %@",error.localizedDescription);
        if (show) {
            [SVProgressHUD dismiss];
        }
        failure(self,error);
    }];
}

-(void)postWithParameters:(NSDictionary *)parameters SvpShow:(BOOL)show success:(void (^)(GLRequest *, id))success failure:(void (^)(GLRequest *, NSError *))failure
{
    [self POST:API_HOST
    parameters:parameters
       SvpShow:show
       success:success
     failure:failure];
}


- (void)postWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters {
    
    [self POST:API_HOST
    parameters:parameters
       SvpShow:false
       success:^(GLRequest *request, NSString *responseString) {
           if ([self.delegate respondsToSelector:@selector(GLRequest:finished:)]) {
               [self.delegate GLRequest:request finished:responseString];
               
           }
       }
       failure:^(GLRequest *request, NSError *error) {
           if ([self.delegate respondsToSelector:@selector(GLRequest:Error:)]) {
               [self.delegate GLRequest:request Error:error.description];
           }
       }];
}

- (void)getWithURL:(NSString *)URLString {
    
    [self GET:URLString parameters:nil success:^(GLRequest *request, NSString *responseString) {
        if ([self.delegate respondsToSelector:@selector(GLRequest:finished:)]) {
            [self.delegate GLRequest:request finished:responseString];
        }
    } failure:^(GLRequest *request, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(GLRequest:Error:)]) {
            [self.delegate GLRequest:request Error:error.description];
        }
    }];
}

- (void)cancelAllOperations{
    [self.operationQueue cancelAllOperations];
}

@end
