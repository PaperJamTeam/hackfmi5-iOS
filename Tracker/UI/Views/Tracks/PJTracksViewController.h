//
//  PJTracksViewController.h
//  Tracker
//
//  Created by Ivan Raychev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJTracksViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(void)setupWithRegionID:(NSString*)regionId;

@end
