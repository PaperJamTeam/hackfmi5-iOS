//
//  Checkpoint.h
//  Tracker
//
//  Created by Ivo Kanchev on 4/26/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Checkpoint : NSObject
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *checkpoint_lat;
@property(strong, nonatomic) NSString *checkpoint_lon;
@property(strong, nonatomic) NSString *note;
@property(strong, nonatomic) NSData *trackData;
@property(strong, nonatomic) NSString *imageName;
@end
