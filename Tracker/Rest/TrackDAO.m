    //
//  TrackDAO.m
//  Tracker
//
//  Created by Ivo Kanchev on 4/26/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "TrackDAO.h"
#import <RestKit/RestKit.h>
#import "Track.h"

@implementation TrackDAO
+ (NSArray *)tracksWithBlock:(void (^) (NSArray*) )callback andError:(void (^) (NSError*))failure
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Track class]];
    [mapping addAttributeMappingsFromArray:@[@"_id", @"author", @"title", @"__v", @"checkpoints"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://harizanov.info/tracks/"]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        callback([result array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    [operation start];
    return nil;
}
@end
