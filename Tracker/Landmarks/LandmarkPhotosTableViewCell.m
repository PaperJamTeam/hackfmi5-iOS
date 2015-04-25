//
//  LandmarkPhotosTableViewCell.m
//  Tracker
//
//  Created by Dimitar Stanev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "LandmarkPhotosTableViewCell.h"

@interface LandmarkPhotosTableViewCell()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end


@implementation LandmarkPhotosTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) addToImages:(NSMutableArray*) images {
    if ( [images count] == 1 ) {
        self.scrollView.contentSize = CGSizeMake(200, 150);
        [(UIImageView*)[images objectAtIndex:0] setFrame:CGRectMake(60, 25, 200, 150)];
        [self.scrollView addSubview:[images objectAtIndex:0]];
    }
    else {
        float currentX = 20;
        self.scrollView.contentSize = CGSizeMake(220 +(images.count-1)*220, 150);
        for ( UIImage* img in images) {
            [(UIImageView*)img setFrame:CGRectMake(currentX, 25, 200, 150)];
            [self.scrollView addSubview:(UIImageView*)img];
            currentX += 220;
        }
    }
}

@end
