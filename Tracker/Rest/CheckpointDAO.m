//
//  CheckpointDAO.m
//  Tracker
//
//  Created by Ivo Kanchev on 4/26/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "CheckpointDAO.h"

@implementation CheckpointDAO
+ (void)postCheckpoint:(Checkpoint *)checkpoint withCompletion:(void (^) (RKMappingResult*) )callback andFailure:(void (^) (NSError*))failure
{

    NSArray *mappingArray = @[@"title", @"checkpoint_lat", @"checkpoint_lon", @"note", @"trackData"];
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[Checkpoint class]];
    [responseMapping addAttributeMappingsFromArray:mappingArray];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodPOST pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping addAttributeMappingsFromArray:mappingArray];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[Checkpoint class] rootKeyPath:nil method:RKRequestMethodAny];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://www.harizanov.info/"]];
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];

    
//    [manager multipartFormRequestWithObject:checkpoint method:RKRequestMethodPOST path:@"checkpoint" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        <#code#>
//    }
    [manager postObject:checkpoint path:@"checkpoint" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //        NSLog(@"%@", operation);
        //        NSLog(@"%@", mappingResult);
        callback(mappingResult);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}
@end
