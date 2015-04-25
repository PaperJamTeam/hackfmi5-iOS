//
//  PJRegionTableViewCell.m
//  Tracker
//
//  Created by Ivan Raychev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "PJRegionTableViewCell.h"

@implementation PJRegionTableViewCell {
    
    IBOutlet UILabel *_nameLabel;
    IBOutlet UIProgressView *_progressView;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithName:(NSString*)name downloaded:(BOOL)downloaded downloading:(BOOL)downloading progress:(double)progress {
    [_nameLabel setText:name];
    
    if ( downloaded ) {
        [self setAccessoryType:UITableViewCellAccessoryCheckmark];
        [_progressView setHidden:YES];
    } else if ( downloading ) {
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [_progressView setHidden:NO];
        [_progressView setProgress:progress];
    } else {
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [_progressView setHidden:YES];
    }
}

-(void)setDownloadingWithProgress:(double)progress {
    [_progressView setHidden:NO];
    [_progressView setProgress:progress];
}

-(void)setDownloaded {
    [self setAccessoryType:UITableViewCellAccessoryCheckmark];
    [_progressView setHidden:YES];
}

@end
