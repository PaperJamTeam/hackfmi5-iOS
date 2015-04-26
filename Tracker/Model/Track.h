//
//  Track.h
//  Tracker
//
//  Created by Ivo Kanchev on 4/26/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject
@property(strong, nonatomic) NSString *id;
@property(strong, nonatomic) NSString *author;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *__v;
@property(strong, nonatomic) NSArray *checkpoints;
@end
