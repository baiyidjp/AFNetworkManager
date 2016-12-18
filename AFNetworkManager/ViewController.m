//
//  ViewController.m
//  AFNetworkManager
//
//  Created by Keep丶Dream on 16/12/18.
//  Copyright © 2016年 dong. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
#import "NetworkManager+Extension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //http://qt.qq.com/static/pages/news/phone/c13_list_1.shtml
    [[NetworkManager shared] LiveRequestWithMethod:HttpMethod_GET Url:@"static/pages/news/phone/c13_list_1.shtml" params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    [[NetworkManager shared] LoginRequestWithMethod:HttpMethod_GET Url:@"static/pages/news/phone/c13_list_1.shtml" params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    [[NetworkManager shared] UploadRequestWithUrl:@"baidu.com" params:nil datas:@[@{@"name":@"12",@"data":@"13"},@{@"name":@"22",@"fileUrl":@"23"}] success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
