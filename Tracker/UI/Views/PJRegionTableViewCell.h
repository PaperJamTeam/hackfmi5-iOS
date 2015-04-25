//
//  PJRegionTableViewCell.h
//  Tracker
//
//  Created by Ivan Raychev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJRegionTableViewCell : UITableViewCell

-(void)setupWithName:(NSString*)name downloaded:(BOOL)downloaded downloading:(BOOL)downloading progress:(double)progress;
-(void)setDownloadingWithProgress:(double)progress;
-(void)setDownloaded;

@end
