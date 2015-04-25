//
//  PJTrackDetailsViewController.h
//  Tracker
//
//  Created by Ivan Raychev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJTrackDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(void)setupWithTrackId:(NSString*)trackId;

@end
