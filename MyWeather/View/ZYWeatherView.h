//
//  ZYWeatherView.h
//  MyWeather
//
//  Created by zhuyongqing on 15/11/2.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYWeatherView : UIView

@property(nonatomic,strong) UIImageView *backImage;

@property(nonatomic,strong) UIImageView *wetherImage; //天气状况图片

@property(nonatomic,strong) UILabel *nowWeather; // 当前温度

@property(nonatomic,strong) UILabel *cityLabel;  //城市名称

@property(nonatomic,strong) UILabel *wether;  //天气状况

@property(nonatomic,strong) UILabel *maxminTmp;//最低温 最高温

- (void)buildWeatherwithData:(NSArray *)data;

+ (UIImage *)stringWithWeather:(NSString *)weatherName;

@end


/////////
@class ZYWeatherData;
@interface ZYWeekWeather : UIView

- (id)initWithFrame:(CGRect)frame andViewTag:(NSInteger)tag weatherData:(ZYWeatherData *)weather;

@end


///////
@interface ZYTmpView : UIView

- (id)initWithFrame:(CGRect)frame withData:(ZYWeatherData *)weather;
- (void)show;
- (void)hide;
@end
