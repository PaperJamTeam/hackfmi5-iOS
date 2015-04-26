//
//  GpsCoordinate.h
//  Tracker
//
//  Created by Ivo Kanchev on 4/26/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GpsCoordinate : NSObject
@property(strong, nonatomic) NSString *deviceId;
@property(strong, nonatomic) NSNumber *longitude;
@property(strong, nonatomic) NSNumber *latitude;
@end
