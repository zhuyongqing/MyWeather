//
//  ZYWeatherView.m
//  MyWeather
//
//  Created by zhuyongqing on 15/11/2.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

#import "ZYWeatherView.h"
#import "ZYWeatherData.h"
#import "UIView+ITTAdditions.h"

#define LIGHT_FONT      @"HelveticaNeue-Light"
#define ULTRALIGHT_FONT @"HelveticaNeue-UltraLight"

#define kWinSize [UIScreen mainScreen].bounds.size

#define kNUM arc4random()%5+1

#define kWeathH 200

#define kWidth 100

#pragma mark - 天气主视图

@interface ZYWeatherView()
@property(nonatomic,strong) UILabel *tmpLabel;
@property(nonatomic,strong) UIView *backView;
@end

@implementation ZYWeatherView

- (id)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if (self) {
        self.backImage = [[UIImageView alloc] init];
        self.backImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"gradient%i",kNUM]];
        self.backImage.frame = CGRectMake(0, 0,kWinSize.width, kWinSize.height);
        [self addSubview:self.backImage];
        
        //天气图片
        self.wetherImage = [[UIImageView alloc] init];
        self.wetherImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.wetherImage];
        
        //城市名称
        self.cityLabel = [[UILabel alloc] init];
        self.cityLabel.textColor = [UIColor whiteColor];
        self.cityLabel.font = [UIFont systemFontOfSize:30];
        self.cityLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.cityLabel];
        
        //天气
        self.wether = [[UILabel alloc] init];
        self.wether.textColor = [UIColor whiteColor];
        self.wether.font = [UIFont fontWithName:ULTRALIGHT_FONT size:40];
        self.wether.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.wether];
        
        //下面的背景
        
        self.backView = [[UIView alloc] init];
        self.backView.backgroundColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3];
        [self addSubview:self.backView];
        
        //最高最低温
        self.maxminTmp = [[UILabel alloc] init];
        self.maxminTmp.textColor = [UIColor whiteColor];
        self.maxminTmp.textAlignment = NSTextAlignmentCenter;
        self.maxminTmp.font = [UIFont fontWithName:LIGHT_FONT size:22];
        [self.backView addSubview:self.maxminTmp];
        
        //当前温度
        self.nowWeather = [[UILabel alloc] init];
        self.nowWeather.textAlignment = NSTextAlignmentCenter;
        self.nowWeather.textColor = [UIColor whiteColor];
        self.nowWeather.font = [UIFont fontWithName:ULTRALIGHT_FONT size:80];
        [self.backView addSubview:self.nowWeather];
        
        //显示度数的label
        
        self.tmpLabel = [[UILabel alloc] init];
        self.tmpLabel.textColor = [UIColor whiteColor];
        self.tmpLabel.font = [UIFont fontWithName:ULTRALIGHT_FONT size:50];
        [self.backView addSubview:self.tmpLabel];
        
        
    }
    
    return self;
}

- (void)buildWeatherwithData:(NSArray *)data
{
   
     ZYWeatherData *weather = data[0];
    //天气图片
    self.wetherImage.frame = CGRectMake(kWinSize.width/2-75,kWidth,150,150);
    self.wetherImage.image = [ZYWeatherView stringWithWeather:weather.weather];
    
    //天气
    self.wether.frame = CGRectMake(0,self.wetherImage.bottom+10,kWinSize.width,40);
    self.wether.text = weather.weather;
    
    //城市
    self.cityLabel.frame = CGRectMake(kWinSize.width/2-kWidth,self.wether.bottom+10,kWeathH,40);
    self.cityLabel.text = weather.cityName;
    
    //下面的背景
    self.backView.frame = CGRectMake(0,self.cityLabel.bottom+20,kWinSize.width, 130);
    
    //现在天气
    self.nowWeather.frame = CGRectMake(15,0,kWidth,80);
    self.nowWeather.text = weather.nowTmp;
    //度数
    self.tmpLabel.frame = CGRectMake(self.nowWeather.right-10,self.nowWeather.top,50, 50);
    self.tmpLabel.text = @"°";
    
    //最高 最低
    self.maxminTmp.frame = CGRectMake(self.nowWeather.left,self.nowWeather.bottom,120,40);
    self.maxminTmp.text = [NSString stringWithFormat:@"H %@ L %@",weather.maxTmp,weather.minTmp];
    
    for (int i = 1; i<4; i++) {
        [self setWeekweatherViewwithDict:data[i] andTag:i-1];
    }
    
}

- (void)setWeekweatherViewwithDict:(ZYWeatherData *)weathers andTag:(NSInteger)tag
{
    CGFloat width = (kWinSize.width-(self.nowWeather.right + 80))/3;
    
    ZYWeekWeather *week = [[ZYWeekWeather alloc] initWithFrame:CGRectMake(self.nowWeather.right+30+tag*(width+20),0,width,self.backView.height) andViewTag:tag weatherData:weathers];
    [self.backView addSubview:week];
}

#pragma mark -   根据天气得到图片
+ (UIImage *)stringWithWeather:(NSString *)weatherName
{
    UIImage *weatherImage;
    if ([weatherName isEqualToString:@"晴"]) {
        weatherImage = [UIImage imageNamed:@"qing"];
    }else if ([weatherName isEqualToString:@"多云"])
    {
        weatherImage = [UIImage imageNamed:@"duoyun"];
    }else if ([weatherName isEqualToString:@"晴间多云"]){
        weatherImage = [UIImage imageNamed:@"qingjianduoyuan"];
    }else if ([weatherName isEqualToString:@"阴"] || [weatherName isEqualToString:@"雾霾"]){
        weatherImage = [UIImage imageNamed:@"yin"];
    }else if ([weatherName isEqualToString:@"小雪"]){
        weatherImage = [UIImage imageNamed:@"xiaoxue"];
    }else if ([weatherName isEqualToString:@"阴转晴"]){
        weatherImage = [UIImage imageNamed:@"yinzhuanqing"];
    }else if([weatherName isEqualToString:@"小雨"]){
        weatherImage = [UIImage imageNamed:@"xiaoyu"];
    }else if ([weatherName isEqualToString:@"大雨"] || [weatherName isEqualToString:@"中雨"]){
        weatherImage = [UIImage imageNamed:@"dayu"];
    }else if([weatherName isEqualToString:@"雨转晴"]){
        weatherImage = [UIImage imageNamed:@"yuzhuanqing"];
    }else if([weatherName isEqualToString:@"阵雨"]){
        weatherImage = [UIImage imageNamed:@"zhenyu"];
    }else if ([weatherName isEqualToString:@"暴雨"]){
        weatherImage = [UIImage imageNamed:@"baoyu"];
    }else if ([weatherName isEqualToString:@"雨夹雪"]){
        weatherImage = [UIImage imageNamed:@"yujiaxue"];
    }else
    {
        weatherImage = [UIImage imageNamed:@"qing"];
    }
    
    
    return weatherImage;
}

@end

#pragma mark - 星期的view
@interface ZYWeekWeather()

{
    //天气的数据
    ZYWeatherData *_weather;
    
    //最低 最高温
    ZYTmpView *_tmpView;
    
    //是否动画
    BOOL isTmpView;
}

//星期几的显示
@property(nonatomic,strong) UILabel *weekLabel;

//天气的显示
@property(nonatomic,strong) UIImageView *weatherImage;



@end

#define kTmpHeight 80 

#define kPosition 120

@implementation ZYWeekWeather

- (id)initWithFrame:(CGRect)frame andViewTag:(NSInteger)tag weatherData:(ZYWeatherData *)weather
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //星期的显示
        self.weekLabel = [[UILabel alloc] init];
        self.weekLabel.text = [self weekDayStr:weather.date];
        self.weekLabel.frame = CGRectMake(0,10,frame.size.width,20);
        self.weekLabel.font = [UIFont fontWithName:LIGHT_FONT size:13];
        self.weekLabel.textColor = [UIColor whiteColor];
        self.weekLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.weekLabel];
        
        //天气的图片
        self.weatherImage = [[UIImageView alloc] init];
        self.weatherImage.frame = CGRectMake(0,self.weekLabel.bottom+10,frame.size.width,frame.size.height-self.weekLabel.bottom-25);
        self.weatherImage.contentMode = UIViewContentModeScaleAspectFill;
        self.weatherImage.image = [ZYWeatherView stringWithWeather:weather.weather];
        [self addSubview:self.weatherImage];
        
        //设置view 的tag
        self.tag = tag;
        
        //加上点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDo:)];
        [self addGestureRecognizer:tap];
        
        _weather = weather;
        
        isTmpView = YES;
    }
    
    return self;
}

#pragma mark -  根据日期转换星期几
- (NSString*)weekDayStr:(NSString *)format
{
    NSString *weekDayStr = nil;
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSString *str = [format description];
    if (str.length >= 10) {
        NSString *nowString = [str substringToIndex:10];
        NSArray *array = [nowString componentsSeparatedByString:@"-"];
        if (array.count == 0) {
            array = [nowString componentsSeparatedByString:@"/"];
        }
        if (array.count >= 3) {
            NSInteger year = [[array objectAtIndex:0] integerValue];
            NSInteger month = [[array objectAtIndex:1] integerValue];
            NSInteger day = [[array objectAtIndex:2] integerValue];
            [comps setYear:year];
            [comps setMonth:month];
            [comps setDay:day];
        }
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    NSInteger week = [weekdayComponents weekday];
    switch (week) {
        case 1:
            weekDayStr = @"星期日";
            break;
        case 2:
            weekDayStr = @"星期一";
            break;
        case 3:
            weekDayStr = @"星期二";
            break;
        case 4:
            weekDayStr = @"星期三";
            break;
        case 5:
            weekDayStr = @"星期四";
            break;
        case 6:
            weekDayStr = @"星期五";
            break;
        case 7:
            weekDayStr = @"星期六";
            break;
        default:
            weekDayStr = @"";  
            break;  
    }  
    return weekDayStr;  
}

#pragma mark - 星期 天气  点击事件
- (void)tapToDo:(UITapGestureRecognizer *)tap
{
    if (isTmpView) {
        if (!_tmpView) {
            _tmpView = [[ZYTmpView alloc] initWithFrame:CGRectMake(-10,20,kTmpHeight,kTmpHeight) withData:_weather];
            _tmpView.alpha = 0;
            [self addSubview:_tmpView];
        }
        //展示动画
        [_tmpView show];
        //设置动画状态
        isTmpView = NO;
    }else
    {
        [_tmpView hide];
        isTmpView = YES;
    }
   
    
   
    
}

@end


#pragma mark - 最低 最高温
@interface ZYTmpView()

@property(nonatomic,strong) UILabel *maxMin;

@end

@implementation ZYTmpView

- (id)initWithFrame:(CGRect)frame withData:(ZYWeatherData *)weather
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.3];
        
        self.layer.cornerRadius = frame.size.height/2;
        
        self.maxMin = [[UILabel alloc] init];
        self.maxMin.frame = CGRectMake(0,0,kTmpHeight,kTmpHeight);
        self.maxMin.textAlignment = NSTextAlignmentCenter;
        self.maxMin.textColor = [UIColor whiteColor];
        self.maxMin.font = [UIFont fontWithName:LIGHT_FONT size:20];
        self.maxMin.text = [NSString stringWithFormat:@"%@ / %@",weather.maxTmp,weather.minTmp];
        [self addSubview:self.maxMin];
    }
    return self;
}
#pragma mark - 出现动画
- (void)show
{
    self.alpha = 1;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    //运动位置
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL,self.center.x, self.center.y);
    CGPathAddLineToPoint(pathRef, NULL,self.center.x,self.center.y+kPosition);
    CGPathAddLineToPoint(pathRef, NULL,self.center.x, self.center.y+kPosition-15);
    CGPathAddLineToPoint(pathRef, NULL,self.center.x, self.center.y+kPosition-5);
    CGPathAddLineToPoint(pathRef, NULL,self.center.x, self.center.y+kPosition-10);
    animation.path = pathRef;
    CGPathRelease(pathRef);
    
    animation.delegate = self;
    animation.duration = 0.4;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.layer addAnimation:animation forKey:@"position"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.origin = CGPointMake(self.origin.x,kPosition-10);
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.values = @[@1.3,@0.8,@1.1,@1.0];
    scale.duration = 0.4;
    scale.fillMode = kCAFillModeForwards;
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.maxMin.layer addAnimation:scale forKey:@"scale"];
}

#pragma mark -  隐藏动画
- (void)hide
{
  [UIView animateWithDuration:0.4 animations:^{
      self.origin = CGPointMake(self.origin.x, 20);
  } completion:^(BOOL finished) {
      self.alpha = 0;
  }];
}

@end

