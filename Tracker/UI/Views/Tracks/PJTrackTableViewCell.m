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
    
    if ( downloaded ) {
        [_progressView setHidden:YES];
        [_trackSwitch setSelected:selected];
        [_trackSwitch setHidden:NO];
    } else if ( downloading ) {
        [_progressView setHidden:NO];
        [_progressView setProgress:progress];
        [_trackSwitch setHidden:YES];
    } else {
        [_progressView setHidden:YES];
        [_trackSwitch setHidden:YES];
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSURL *imgURL=[[NSURL alloc]initWithString:thumbnailURL];
        NSData *imgdata=[[NSData alloc]initWithContentsOfURL:imgURL];
        UIImage *image=[[UIImage alloc]initWithData:imgdata];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_thumbnail setImage:image];
        });
    });
    
}

-(void)setDownloadingWithProgress:(double)progress {
    [_progressView setHidden:NO];
    [_progressView setProgress:progress];
    [_trackSwitch setHidden:YES];
}

-(void)setDownloaded {
    [_progressView setHidden:YES];
    [_trackSwitch setHidden:NO];
    [_trackSwitch setSelected:YES];
}


@end
