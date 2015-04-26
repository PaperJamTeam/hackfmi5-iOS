//
//  GpsDAO.m
//  Tracker
//
//  Created by Ivo Kanchev on 4/26/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "GpsDAO.h"

@implementation GpsDAO
+ (void)postGpsCoordinate:(GpsCoordinate *)gpsCoordinate withCompletion:(void (^) (RKMappingResult*) )callback andFailure:(void (^) (NSError*))failure
{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"deviceId", @"longitude", @"latitude"]];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:mapping  objectClass:[GpsCoordinate class] rootKeyPath:nil method:RKRequestMethodPOST];
    
    
//    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
//    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:statusCodes];

    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://harizanov.info/"]];
    
    [manager addRequestDescriptor:requestDescriptor];
    
    [manager postObject:gpsCoordinate path:[NSString stringWithFormat:@"/gps/%@", gpsCoordinate.deviceId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        NSLog(@"%@", operation);
//        NSLog(@"%@", mappingResult);
        callback(mappingResult);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
@end
