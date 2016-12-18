//
//  NetworkManager+Extension.h
//  AFNetworkManager
//
//  Created by Keep丶Dream on 16/12/18.
//  Copyright © 2016年 dong. All rights reserved.
//

#import "NetworkManager.h"


//网络管理分类 此分类中主要是完成请求
@interface NetworkManager (Extension)

//直播的请求
- (void)LiveRequestWithMethod:(HttpMethod)httpMethod
                      Url:(NSString *)urlStr
                   params:(NSDictionary *)params
                  success:(successBlock)success
                  failure:(failureBlock)failure;

@end
