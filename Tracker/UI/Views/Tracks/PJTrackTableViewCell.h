//
//  PJTrackTableViewCell.h
//  Tracker
//
//  Created by Ivan Raychev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJTrackTableViewCell : UITableViewCell

-(void)setupWithName:(NSString*)name thumbnailURL:(NSString*)thumbnailURL time:(NSString*)time rating:(NSString*)rating distance:(NSString*)distance downloaded:(BOOL)downloaded selected:(BOOL)selected downloading:(BOOL)downloading progress:(double)progress;

-(void)setDownloadingWithProgress:(double)progress ;

-(void)setDownloaded;

@end
