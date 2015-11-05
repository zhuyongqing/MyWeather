//
//  ZYHTTPTool.m
//  MyWeather
//
//  Created by zhuyongqing on 15/11/2.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

#import "ZYHTTPTool.h"

#define kApikey @"6e2cfdae7ef55fea63fc5a9a203a16e5"

@implementation ZYHTTPTool

+ (void)request: (NSString*)httpUrl andSussecs:(sussecs)result :(faild)faild  {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:kApikey forHTTPHeaderField:@"apikey"];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest: [serializer requestWithMethod: @"GET" URLString: httpUrl parameters:nil error: nil] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            faild(error);
        } else {
            result(responseObject);
        }
    }];
    
    [dataTask resume];
    
    //
    //    NSURL *url = [NSURL URLWithString:urlStr];
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    //    [request setHTTPMethod: @"GET"];
    //    [request addValue:kApikey forHTTPHeaderField: @"apikey"];
    //
    //    NSURLSessionConfiguration *configur = [NSURLSessionConfiguration defaultSessionConfiguration];
    //
    //    NSURLSession *session = [NSURLSession sessionWithConfiguration:configur];
    //
    //    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //        if (error) {
    //            faild(error);
    //        } else {
    //            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    //            result(dict);
    //        }
    //    }];
    //    
    //    [dataTask resume];
}


@end
