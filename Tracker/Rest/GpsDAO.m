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
//    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
//    [mapping addAttributeMappingsFromArray:@[@"uuid", @"lon", @"lat"]];
//    
//    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[mapping inverseMapping]  objectClass:[GpsCoordinate class] rootKeyPath:nil method:RKRequestMethodPOST];
//    
    
//    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
//    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:statusCodes];

//    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://harizanov.info/"]];
//    [manager addRequestDescriptor:requestDescriptor];
//    
//    [manager postObject:gpsCoordinate path:[NSString stringWithFormat:@"/gps/coord/%@", gpsCoordinate.uuid] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
////        NSLog(@"%@", operation);
////        NSLog(@"%@", mappingResult);
//        callback(mappingResult);
//    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        failure(error);
//    }];
    
    NSArray *mappingArray = @[@"uuid", @"lon", @"lat"];
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[GpsCoordinate class]];
    [responseMapping addAttributeMappingsFromArray:mappingArray];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:mappingArray];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[GpsCoordinate class] rootKeyPath:nil method:RKRequestMethodAny];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://www.harizanov.info/"]];
//    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    
//    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[GpsCoordinate class]
//                                                        pathPattern:[NSString stringWithFormat:@"gps/coord/%@", gpsCoordinate.uuid] method:RKRequestMethodPOST]];


    [manager postObject:gpsCoordinate path:[NSString stringWithFormat:@"gps/coord/%@", gpsCoordinate.uuid] parameters:@{@"uuid" : gpsCoordinate.uuid, @"lon" : gpsCoordinate.lon, @"lat" : gpsCoordinate.lat} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //        NSLog(@"%@", operation);
        //        NSLog(@"%@", mappingResult);
        callback(mappingResult);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}
@end
