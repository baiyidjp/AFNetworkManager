//
//  NetworkManager+Extension.m
//  AFNetworkManager
//
//  Created by Keep丶Dream on 16/12/18.
//  Copyright © 2016年 dong. All rights reserved.
//

#import "NetworkManager+Extension.h"

@implementation NetworkManager (Extension)

-(void)LiveRequestWithMethod:(HttpMethod)httpMethod
                         Url:(NSString *)urlStr
                      params:(NSDictionary *)params
                     success:(successBlock)success
                     failure:(failureBlock)failure
{
    [self RequestWithMethod:httpMethod Url:urlStr params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task,error);
    }];
}

@end
