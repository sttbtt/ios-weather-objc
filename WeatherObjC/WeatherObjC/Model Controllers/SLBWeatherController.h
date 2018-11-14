//
//  SLBWeatherController.h
//  WeatherObjC
//
//  Created by Scott Bennett on 11/13/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLBWeatherController : NSObject

@property (nonatomic, copy, readonly) NSArray *forcasts;
@property (nonatomic, copy) NSArray *internalForecasts;

@end

NS_ASSUME_NONNULL_END
