//
//  CheckpointDAO.h
//  Tracker
//
//  Created by Ivo Kanchev on 4/26/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "Checkpoint.h"

@interface CheckpointDAO : NSObject
+ (void)postCheckpoint:(Checkpoint *)checkpoint withCompletion:(void (^) (RKMappingResult*) )callback andFailure:(void (^) (NSError*))failure;
@end
