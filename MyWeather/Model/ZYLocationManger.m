//
//  ZYLocationManger.m
//  MyWeather
//
//  Created by zhuyongqing on 15/11/2.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

#import "ZYLocationManger.h"

@interface ZYLocationManger()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
}

@end

@implementation ZYLocationManger

- (void)settingLocation:(id)obj
{
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
       
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //设置代理
    _locationManager.delegate=obj;
    //设置定位精度
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance=100000.0;//十米定位一次
    _locationManager.distanceFilter=distance;
    //启动跟踪定位
    [_locationManager startUpdatingLocation];
    
    _geocoder=[[CLGeocoder alloc]init];
    
}


#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude sussecd:(sussecd)completionHandler
{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        completionHandler(placemark);
    }];
}

- (void)stopUpdating
{
    [_locationManager stopUpdatingLocation];
    
}


@end
