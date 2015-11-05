//
//  ZYHTTPTool.h
//  MyWeather
//
//  Created by zhuyongqing on 15/11/2.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
typedef void(^sussecs)(id responseObject);
typedef void(^faild)(NSError *error);

@interface ZYHTTPTool : NSObject

+ (void)request: (NSString*)httpUrl andSussecs:(sussecs)result :(faild)faild;

@end
