//
//  ZYAddViewControll.h
//  MyWeather
//
//  Created by zhuyongqing on 15/11/4.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cityName)(NSString *city);

@interface ZYAddViewControll : UIViewController

@property(nonatomic,strong) cityName cityName;


- (void)seachCityName:(cityName)cityName;

@end
