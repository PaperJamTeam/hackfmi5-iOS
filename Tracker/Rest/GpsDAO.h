//
//  GpsDAO.h
//  Tracker
//
//  Created by Ivo Kanchev on 4/26/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GpsCoordinate.h"
#import <RestKit/RestKit.h>

@interface GpsDAO : NSObject
+ (void)postGpsCoordinate:(GpsCoordinate *)gpsCoordinate withCompletion:(void (^) (RKMappingResult*) )callback andFailure:(void (^) (NSError*))failure;
@end
