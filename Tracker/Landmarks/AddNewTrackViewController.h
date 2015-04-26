//
//  AddNewTrackViewController.h
//  Tracker
//
//  Created by Dimitar Stanev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol chosenInsertTypeDelegate
-(void)didChooseImage: (UIImageView*) image;
-(void)addNoteWithTitle:(NSString*)title andText:(NSString*)text;
@end

@interface AddNewTrackViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, chosenInsertTypeDelegate>

@end
