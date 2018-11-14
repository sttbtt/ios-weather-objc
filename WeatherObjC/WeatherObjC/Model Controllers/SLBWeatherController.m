//
//  SLBWeatherController.m
//  WeatherObjC
//
//  Created by Scott Bennett on 11/13/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//
// https://samples.openweathermap.org/data/2.5/forecast/daily?id=524901&appid=b1b15e88fa797225412429c1c50c122a1
// https://openweathermap.org/data/2.5/forecast/daily?zip=41091,us&appid=c5c5152ecea1fb846177690fb1eb7152

#import "SLBWeatherController.h"
#import "SLBWeather.h"

@implementation SLBWeatherController

static NSString * const baseURLString = @"https://api.openweathermap.org/data/2.5/forecast/daily";
static NSString * const apiKey = @"c5c5152ecea1fb846177690fb1eb7152";

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _internalForecasts = [[NSMutableArray alloc] init];
    }
    return self;

}

- (void)fetchForcastsForZipCode:(int)zipCode completion:(void (^)(NSError *))completion;
{
    NSString *zipCodeString = [NSString stringWithFormat:@"%d", zipCode];
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:baseURL resolvingAgainstBaseURL:true];
    
    NSURLQueryItem *zipCodeItem = [[NSURLQueryItem alloc] initWithName:@"zip" value:zipCodeString];
    NSURLQueryItem *appIDItem = [[NSURLQueryItem alloc] initWithName:@"appid" value:apiKey];
    NSURLQueryItem *unitsItem = [[NSURLQueryItem alloc] initWithName:@"units" value:@"imperial"];
    
    components.queryItems = @[zipCodeItem, appIDItem, unitsItem];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:components.URL];
    
    NSURLSessionDataTask *dataTask = [NSURLSession.sharedSession dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error fetching forcasts at %d: %@.", zipCode, error);
            completion(error);
            return;
        }
        
        if (!data) {
            NSLog(@"No data returned from data task");
            completion([[NSError alloc] init]);
            return;
        }
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
            NSLog(@"Error deserializing JSON: %@", error);
            completion(error);
            return;
        }
        
        NSMutableArray *forcasts = [[NSMutableArray alloc] init];
        
        NSDictionary *cityDictionary = dictionary[@"city"];
        NSString *cityName = cityDictionary[@"name"];
        
        NSArray *listDictionaries = dictionary[@"list"];
        
        for (int i = 0; i < listDictionaries.count; i++) {
            
            NSDictionary *forecastDictionary = listDictionaries[i];
            
            SLBWeather *forcast = [[SLBWeather alloc] initWithName:cityName dictionary:forecastDictionary];
            
            [forcasts addObject:forcast];
        }
        
        self.internalForecasts = forcasts;
        completion(nil);
    }];
    
    [dataTask resume];
    
    
}





- (NSArray *)forcasts
{
    return self.internalForecasts;
}


@end
