//
//  PJLocationManager.m
//  Tracker
//
//  Created by Ivo Kanchev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "PJLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface PJLocationManager () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;

@end


@implementation PJLocationManager

-(id)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
            // Or [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

@end
