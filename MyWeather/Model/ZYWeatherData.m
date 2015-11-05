//
//  ZYWeatherData.m
//  MyWeather
//
//  Created by zhuyongqing on 15/11/2.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

#import "ZYWeatherData.h"
#import "ZYLocationManger.h"

@interface ZYLocationManger(){
    
}

@end

@implementation ZYWeatherData

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.maxTmp = dict[@"tmp"][@"max"];
        self.minTmp = dict[@"tmp"][@"min"];
        self.wind = dict[@"wind"][@"dir"];
        self.weather = dict[@"cond"][@"txt_d"];
        self.date = dict[@"date"];
    }
    return self;
}

+ (NSMutableArray *)weatherWithArray:(NSArray *)data
{
    NSMutableArray *wetherData = [NSMutableArray array];
    
   // NSLog(@"%@",data[0]);
    NSArray *tmp = data[0][@"daily_forecast"];
    [tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZYWeatherData *wether = [[ZYWeatherData alloc] initWithDict:obj];
        if (idx == 0) {
            wether.nowTmp = data[0][@"now"][@"tmp"];
            wether.cityName = data[0][@"basic"][@"city"];
        }
        [wetherData addObject:wether];
    }];
    
    return wetherData;
}


@end
