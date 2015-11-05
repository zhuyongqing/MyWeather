//
//  ZYMViewController.m
//  MyWeather
//
//  Created by zhuyongqing on 15/11/3.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

#import "ZYMViewController.h"
#import "ZYWeatherView.h"
#import "ZYLocationManger.h"
#import "ZYHTTPTool.h"
#import "ZYWeatherData.h"
#import "UIView+ITTAdditions.h"
#import "ZYAddViewControll.h"
#import "MBProgressHUD+Add.h"
#define kCity @"CITYS"
//天气的接口
#define kWeather(cityName) [NSString stringWithFormat:@"http://apis.baidu.com/heweather/weather/free?city=%@",(cityName)]
//字体
#define LIGHT_FONT      @"HelveticaNeue-Light"
#define ULTRALIGHT_FONT @"HelveticaNeue-UltraLight"

@interface ZYMViewController ()<CLLocationManagerDelegate,UIScrollViewDelegate>
{
     ZYLocationManger *_location;
}
@property(nonatomic,strong) ZYWeatherView *weatherView;

@property(nonatomic,strong) UIPageControl *pageControl;

//滑动页面
@property(nonatomic,strong) UIScrollView  *scrollView;

//城市
@property(nonatomic,strong) NSMutableArray *cityArr;

@end

@implementation ZYMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //设置定位i
    [self setLocation];
    //滑动页面
    [self.view addSubview:self.scrollView];
    
    //常在的城市
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kCity] != nil) {
        [self weatherCountWithview];
    }else
        [self buildweatherViewWidth:self.view.width];
    
    //页数
    [self.view addSubview:self.pageControl];
    //加号按钮
    [self addBtn];
   
}

- (void)weatherCountWithview
{
    //取出已存起来的城市
    self.cityArr = [[[NSUserDefaults standardUserDefaults] objectForKey:kCity] mutableCopy];
    //加载每一个城市
    for (int i = 1; i<=self.cityArr.count; i++) {
        [self buildweatherViewWidth:i*self.view.width];
        [self addWeatherViewWithCity:self.cityArr[i-1] andWithTag:i*10];
    }
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (NSMutableArray *)cityArr
{
    if (!_cityArr) {
        _cityArr = [[NSMutableArray alloc] init];
        
    }
    return _cityArr;
}

#pragma mark - 懒加载scrollview
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient5"]];
        _scrollView.contentSize = CGSizeMake(self.view.width,0);
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = self.scrollView.contentSize.width/self.view.width;
        _pageControl.backgroundColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yuandian1"]];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yuandian2"]];
        _pageControl.centerX = self.view.width*0.5;
        _pageControl.centerY = self.view.height-40;
    }
    return _pageControl;
}



#pragma mark - 设置定位
- (void)setLocation
{
    _location = [[ZYLocationManger alloc] init];
    [_location settingLocation:self];
}

#pragma mark - 更新位置完成
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *core=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=core.coordinate;//位置坐标
    //得到位置信息
    [_location getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude sussecd:^(CLPlacemark *parms) {
        //      UIBarButtonItem *item = [self.navigationItem.rightBarButtonItems firstObject];
        //      UIButton *btn = item.customView;
        //      [btn setTitle:parms.locality forState:UIControlStateNormal];
        //[@"HeWeather data service 3.0"][0][@"daily_forecast"][0]
        NSString *str = [parms.locality substringToIndex:parms.locality.length-1];
            if (![self isLikeWith:str]) {
             [self.cityArr addObject:str];
            [[NSUserDefaults standardUserDefaults] setObject:self.cityArr forKey:str];
            [self addWeatherViewWithCity:str andWithTag:self.cityArr.count*10];
           
        }
      
    }];
    //停止更新
    [_location stopUpdating];
    
}

#pragma mark - 判断城市名 是否相同
- (BOOL)isLikeWith:(NSString *)cityName
{
    //判断数组里有没有这个城市
    __block BOOL isHave = NO;
    [self.cityArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([cityName isEqualToString:obj]) {
            *stop = YES;
            isHave = YES;
        }
    }];
   
    return isHave;
}

#pragma mark - 增加 删除 天气界面按钮
- (void)addBtn
{
    //增加
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"addbutton"] forState:UIControlStateNormal];
    [addBtn setFrame:CGRectMake(self.view.width-60,self.view.height-50, 20, 20)];
    [addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    //删除
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    [delete setTitle:@"-" forState:UIControlStateNormal];
    [delete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(deleteWeather) forControlEvents:UIControlEventTouchUpInside];
    [delete.titleLabel setFont:[UIFont fontWithName:ULTRALIGHT_FONT size:100]];
    [delete setFrame:CGRectMake(30,self.view.height-63,30,30)];
    [self.view addSubview:delete];
}

#pragma 删除天气页面
- (void)deleteWeather
{
  [self.cityArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if (idx == self.pageControl.currentPage) {
          //取出当前的view  删除
          ZYWeatherView *weather = [self.scrollView viewWithTag:(self.pageControl.currentPage+1)*10];
          [weather removeFromSuperview];
      }
     else if(idx > self.pageControl.currentPage)
     {
         //取出后面的view  向前移动一个
         ZYWeatherView *weather = [self.scrollView viewWithTag:(idx+1)*10];
         
         weather.origin = CGPointMake(weather.origin.x-self.view.width, 0);
         //改变tag
         weather.tag = idx *10;
     }
  }];
    
    //从数组中删除
    [self.cityArr removeObjectAtIndex:self.pageControl.currentPage];
    
    //改变 容量
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width-self.view.width,0);
    //改变页数
    self.pageControl.numberOfPages = self.scrollView.contentSize.width/self.view.width;
   
    //保存
    [[NSUserDefaults standardUserDefaults] setObject:self.cityArr forKey:kCity];
}

#pragma mark - 增加一个天气界面
- (void)addBtnAction
{
    ZYAddViewControll *add = [[ZYAddViewControll alloc] init];
    
    [self presentViewController:add animated:YES completion:^{
        [add seachCityName:^(NSString *city) {
            if (![self isLikeWith:city]) {
                //把城市加入数组
                [self.cityArr addObject:city];
                //创建天气
                [self buildweatherViewWidth:self.view.width+self.scrollView.contentSize.width];
                //请求数据
                [self addWeatherViewWithCity:city andWithTag:self.cityArr.count*10];
                //保存城市数组
                [[NSUserDefaults standardUserDefaults] setObject:self.cityArr forKey:kCity];
            }else
            {
                [MBProgressHUD showText:@"已有这个城市的天气" toView:self.view];
            }
          
        }];
    }];
}

#pragma mark - 加一个天气的页面
- (void)buildweatherViewWidth:(CGFloat)width
{
    //改变容量
    self.scrollView.contentSize = CGSizeMake(width, 0);
    //改变页数
    self.pageControl.numberOfPages = width/self.view.width;
    //移动页数
    [self.scrollView setContentOffset:CGPointMake(width-self.view.width,0) animated:YES];
    //创建天气页面
    ZYWeatherView *weather =[[ZYWeatherView alloc] initWithFrame:CGRectMake(width-self.view.width,0,self.scrollView.width, self.scrollView.height)];
    //设置tag
    weather.tag = self.pageControl.numberOfPages*10;
    [self.scrollView addSubview:weather];
}

#pragma mark - 请求数据
- (void)addWeatherViewWithCity:(NSString *)city andWithTag:(NSInteger)tag
{
    [ZYHTTPTool request:kWeather([city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]) andSussecs:^(id responseObject) {
        
         ZYWeatherView *weather = [self.scrollView viewWithTag:tag];
        
        if ([responseObject[@"HeWeather data service 3.0"][0][@"status"] isEqualToString:@"unknown city"]) {
            [MBProgressHUD showError:@"找不到您的城市" toView:self.view];
            
            [self.cityArr removeObject:city];
            //删除加入的weather
            [weather removeFromSuperview];
            
            //改变滑动页面的容量
            self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width-self.view.width, 0);
            
            self.pageControl.numberOfPages = self.scrollView.contentSize.width/self.view.width;
            
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
            return ;
        }
       //更新页面数据
        [weather buildWeatherwithData:[ZYWeatherData weatherWithArray:responseObject[@"HeWeather data service 3.0"]]];
        
    } :^(NSError *error) {
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x/self.view.width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
