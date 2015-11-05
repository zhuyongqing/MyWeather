//
//  ZYLocationManger.h
//  MyWeather
//
//  Created by zhuyongqing on 15/11/2.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>



typedef void(^sussecd)(id parms);

@interface ZYLocationManger : NSObject

- (void)settingLocation:(id)obj;

-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude sussecd:(sussecd)completionHandler;

- (void)stopUpdating;

@end
