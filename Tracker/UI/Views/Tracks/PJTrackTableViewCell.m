//
//  PJTrackTableViewCell.m
//  Tracker
//
//  Created by Ivan Raychev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "PJTrackTableViewCell.h"

@implementation PJTrackTableViewCell {
    
    IBOutlet UIImageView *_thumbnail;
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_ratingLabel;
    IBOutlet UILabel *_distanceLabel;
    
    IBOutlet UIProgressView *_progressView;
    IBOutlet UISwitch *_trackSwitch;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(id)sender {
    //handle track select/unselect
}

-(void)setupWithName:(NSString*)name thumbnailURL:(NSString*)thumbnailURL time:(NSString*)time rating:(NSString*)rating distance:(NSString*)distance downloaded:(BOOL)downloaded selected:(BOOL)selected downloading:(BOOL)downloading progress:(double)progress {
    [_nameLabel setText:name];
    [_timeLabel setText:time];
    [_ratingLabel setText:rating];
    [_distanceLabel setText:distance];
    
    NSURL *imgURL=[[NSURL alloc]initWithString:thumbnailURL];
    NSData *imgdata=[[NSData alloc]initWithContentsOfURL:imgURL];
    UIImage *image=[[UIImage alloc]initWithData:imgdata];
    _thumbnail.image=image;
    
    if ( downloaded ) {
        [self setAccessoryType:UITableViewCellAccessoryCheckmark];
        [_progressView setHidden:YES];
        [_trackSwitch setSelected:selected];
        [_trackSwitch setHidden:NO];
    } else if ( downloading ) {
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [_progressView setHidden:NO];
        [_progressView setProgress:progress];
        [_trackSwitch setHidden:YES];
    } else {
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [_progressView setHidden:YES];
        [_trackSwitch setHidden:YES];
    }
}

-(void)setDownloadingWithProgress:(double)progress {
    [_progressView setHidden:NO];
    [_progressView setProgress:progress];
    [_trackSwitch setHidden:YES];
}

-(void)setDownloaded {
    [self setAccessoryType:UITableViewCellAccessoryCheckmark];
    [_progressView setHidden:YES];
    [_trackSwitch setHidden:NO];
    [_trackSwitch setSelected:YES];
}


@end
