//
//  NetworkManager.m
//  AFNetworkManager
//
//  Created by Keep丶Dream on 16/12/18.
//  Copyright © 2016年 dong. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"


@interface NetworkManager ()

/** AFNHTTPSessionManager */
@property(nonatomic,strong) AFHTTPSessionManager *sessionManager;

@end

@implementation NetworkManager

+ (NetworkManager *)shared {
    
    static NetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetworkManager alloc] init];
    });
    return manager;
}

- (AFHTTPSessionManager *)sessionManager{
    
    if (!_sessionManager) {
        
        _sessionManager = [AFHTTPSessionManager manager];
        //支持https
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
//        // 设置可以接收无效的证书
//        [securityPolicy setAllowInvalidCertificates:YES];
//        _sessionManager.securityPolicy = securityPolicy;
        //超时
        _sessionManager.requestSerializer.timeoutInterval = 8;
        //设置AFN反序列化支持 text/plain text/html
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html",nil];
    }
    return _sessionManager;
}

- (void)cancelAllRequest {
    
    [self.sessionManager.operationQueue cancelAllOperations];
}

/**
 封装AFN请求
 
 @param httpMethod 请求类型  get/post
 @param urlStr 请求地址
 @param params 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)RequestWithMethod:(HttpMethod)httpMethod
                      Url:(NSString *)urlStr
                   params:(NSDictionary *)params
                  success:(successBlock)success
                  failure:(failureBlock)failure
{
    //拼接请求地址
    NSString *hostName = [NSString stringWithFormat:@"%@://%@",@"http",@"公司域名"];
    NSString *realUrl = [NSString stringWithFormat:@"%@/%@",hostName,urlStr];
    
    //自定义block回调 成功
    void (^successBlock)() = ^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            success(task,responseObject);
        }
    };
    //自定义block回调 失败
    void (^failureBlock)() = ^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(task,error);
        }
    };
    
    if (httpMethod == HttpMethod_GET) {
        
        [self.sessionManager GET:realUrl parameters:params progress:nil success:successBlock failure:failureBlock];
    }else {
        
        [self.sessionManager POST:realUrl parameters:params progress:nil success:successBlock failure:failureBlock];
    }
}

- (void)LoginRequestWithMethod:(HttpMethod)httpMethod
                           Url:(NSString *)urlStr
                        params:(NSDictionary *)params
                       success:(successBlock)success
                       failure:(failureBlock)failure
{
    
    //拼接登陆标识
    NSMutableDictionary *paramsM;
    
    if (params == nil) {
        paramsM = [NSMutableDictionary dictionary];
    }else {
        paramsM = [NSMutableDictionary dictionaryWithDictionary:params];
    }
    //若已经登录 设置登陆标识  若未登录则还是按照原先的参数传递
#warning 判断是否登录
    if (@"已登录") {
        [paramsM setObject:[NSNumber numberWithInteger:001] forKey:@"userid"];
    }
    
    [self LoginUploadRequestWithMethod:httpMethod Url:urlStr params:[paramsM copy] datas:nil success:success failure:failure];
}

- (void)LoginUploadRequestWithMethod:(HttpMethod)httpMethod
                                 Url:(NSString *)urlStr
                              params:(NSDictionary *)params
                               datas:(NSArray<NSDictionary *> *)datas
                             success:(successBlock)success
                             failure:(failureBlock)failure
{
    
    //判断是否是上传数据
    if (datas.count) {
        //调用上传
        [self UploadRequestWithUrl:urlStr params:params datas:datas success:success failure:failure];
    }else {
        //调用普通请求
        [self RequestWithMethod:httpMethod Url:urlStr params:params success:success failure:failure];
    }
}

- (void)UploadRequestWithUrl:(NSString *)urlStr
                      params:(NSDictionary *)params
                       datas:(NSArray<NSDictionary *> *)datas
                     success:(successBlock)success
                     failure:(failureBlock)failure
{
    
    [self.sessionManager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [datas enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            
            /*
             1.data/fileUrl :  要上传的二进制数据 / 存在本地的数据
             2.name :  服务器接收的数据名
             3.fileName : 保存在服务器的文件名
             4.mimeType : 类型 不想告诉可以直接写 application/octet-stream
             */
            //字典的keys
            NSArray *keys = dict.allKeys;
            NSString *name = [keys containsObject:@"name"] ? [dict objectForKey:@"name"] : nil;
            NSData *data = [keys containsObject:@"data"] ? [dict objectForKey:@"data"] : nil;
            NSString *fileUrl = [keys containsObject:@"fileUrl"] ? [dict objectForKey:@"fileUrl"] : nil;
            if (data != nil) {
                [formData appendPartWithFileData:[dict objectForKey:@"data"] name:[dict objectForKey:@"name"] fileName:[NSString stringWithFormat:@"二进制文件%zd",idx] mimeType:@"application/octet-stream"];
            }
            
            if (fileUrl != nil) {
                [formData appendPartWithFileURL:[NSURL URLWithString:fileUrl] name:name error:nil];
            }
        }];
        
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task,error);
    }];
}

@end
