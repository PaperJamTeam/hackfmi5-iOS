//
//  AddNoteViewController.h
//  Tracker
//
//  Created by Dimitar Stanev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol chosenInsertTypeDelegate;

@interface AddNoteViewController : UIViewController

@property (weak, nonatomic) id<chosenInsertTypeDelegate> delegate;

@end
