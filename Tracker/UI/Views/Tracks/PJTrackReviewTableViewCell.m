//
//  PJTrackReviewTableViewCell.m
//  Tracker
//
//  Created by Ivan Raychev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "PJTrackReviewTableViewCell.h"

@implementation PJTrackReviewTableViewCell {
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_authorLabel;
    IBOutlet UILabel *_textLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithTitle:(NSString*)title author:(NSString*)author andText:(NSString*)text
{
    [_titleLabel setText:title];
    [_authorLabel setText:author];
    [_textLabel setText:text];
}

@end
