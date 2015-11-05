//
//  ZYWeatherData.h
//  MyWeather
//
//  Created by zhuyongqing on 15/11/2.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYWeatherData : NSObject

@property(nonatomic,strong) NSString *maxTmp;//最高温
@property(nonatomic,strong) NSString *minTmp;//最低温
@property(nonatomic,strong) NSString *wind; //风向
@property(nonatomic,strong) NSString *weather; //天气状况
@property(nonatomic,strong) NSString *nowTmp;  //现在的温度
@property(nonatomic,strong) NSString *cityName; //城市名称
@property(nonatomic,strong) NSString *date;    //时间


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSMutableArray *)weatherWithArray:(NSArray *)data;




@end
