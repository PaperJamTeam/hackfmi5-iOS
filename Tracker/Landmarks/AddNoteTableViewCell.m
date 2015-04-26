//
//  AddNoteTableViewCell.m
//  Tracker
//
//  Created by Dimitar Stanev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "AddNoteTableViewCell.h"
@interface AddNoteTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textTextView;
@end

@implementation AddNoteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setNoteTitle:(NSString*)title andText:(NSString*) text {
    self.titleLabel.text = title;
    self.textTextView.text = text;
}

@end
