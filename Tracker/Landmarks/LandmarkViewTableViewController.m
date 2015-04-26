//
//  LandmarkViewTableViewController.m
//  Tracker
//
//  Created by Dimitar Stanev on 4/26/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "LandmarkViewTableViewController.h"
#import "AddNewTrackViewController.h"
#import "AddItemToNewLandmarkTableViewCell.h"
#import "selectInsertTypeViewController.h"
#import "LandmarkPhotosTableViewCell.h"
#import "AddNoteTableViewCell.h"

@interface LandmarkViewTableViewController ()
@property ( nonatomic, strong ) NSDictionary* trackData;
@property (nonatomic, strong) NSArray *cellData;
@end

@implementation LandmarkViewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.trackData = @{ @"name" : @"",
                        @"pictures" : [[NSMutableArray alloc] init] ,
                        @"audio" : [[NSMutableArray alloc] init],
                        @"notes" : [[NSMutableArray alloc] init] };
    
    // NIB setup
    UINib *nibForNameCell = [UINib nibWithNibName:@"NewLandmarkTableViewCell" bundle:nil];
    [self.tableView registerNib:nibForNameCell forCellReuseIdentifier:@"NewLandmarkNameTableViewCell"];
    UINib *nibForAddNewCell = [UINib nibWithNibName:@"AddItemToNewLandmarkTableViewCell" bundle:nil];
    [self.tableView registerNib:nibForAddNewCell forCellReuseIdentifier:@"AddItemToNewLandmarkTableViewCell"];
    UINib *nibForPhotos = [UINib nibWithNibName:@"LandmarkPhotosTableViewCell" bundle:nil];
    [self.tableView registerNib:nibForPhotos forCellReuseIdentifier:@"LandmarkPhotosTableViewCell"];
    UINib *nibForNotes = [UINib nibWithNibName:@"AddNoteTableViewCell" bundle:nil];
    [self.tableView registerNib:nibForNotes forCellReuseIdentifier:@"AddNoteTableViewCell"];
    UINib *nibForAudio = [UINib nibWithNibName:@"AudioCellTableViewCell" bundle:nil];
    [[self tableView] registerNib:nibForAudio forCellReuseIdentifier:@"AudioCellTableViewCell"];
    
    // NAVIGATION SECTION
    self.navigationItem.title = @"Add new landmark";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.leftBarButtonItem = backButton;
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    UIImageView *firstDummy = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"waterfall1" ofType:@"jpg"] ]];
    UIImageView *secondDummy = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"waterfall2" ofType:@"jpg"] ]];
    UIImageView *thirdDummy = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"waterfall3" ofType:@"jpg"] ]];
    [images addObject:firstDummy];
    [images addObject:secondDummy];
    [images addObject:thirdDummy];
    
    NSDictionary* dummyData = @{
                                @"name" : @"Beautiful waterfall",
                                @"pictures" : images,
                                @"audio" : @[@"", @""],
                                @"notes" : [[NSMutableArray alloc] initWithObjects:@{@"title":@"Hello world !", @"text" : @"I am writing a note to check if my awesome application works. Also, I really like this waterfall here, it's amazing !"} , @{
                                                                                     @"title":@"Second note !", @"text":@"Just made myself a second note so I can test whatever else I'm trying to do ! Just made myself a second note so I can test whatever else I'm trying to do. Just made myself a second note so I can test whatever else I'm trying to do..."}, nil]
                                };
    self.trackData = dummyData;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadTable];
}

-(void)reloadTable
{
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    [cells addObject:@{
                       @"type": @"title",
                       @"height": @(42),
                       @"text":_trackData[@"name"]
                       }];
    if ( [_trackData[@"pictures"] count] > 0 ) {
        [cells addObject:@{
                           @"type": @"pictures",
                           @"height": @200
                           }];
    }
    
    for ( NSDictionary *note in _trackData[@"notes"] ) {
        CGFloat height = 40 + [self heightOfTextWithWidth:265 fontSize:17 text:note[@"text"]];
        [cells addObject:@{
                           @"type": @"note",
                           @"height":@(height),
                           @"title":note[@"title"],
                           @"text":note[@"text"]
                           }];
    }
    
        for ( NSDictionary *audio in _trackData[@"audio"] ) {
            [cells addObject:@{
                              @"type" : @"audio",
                              @"height": @42,
                              }];
        }
    
    //    for ( NSDictionary *video in _trackData[@"video"] ) {
    //
    //    }
    
    _cellData = [cells copy];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cellToReturn;
    
    NSDictionary *data = _cellData[indexPath.row];
    NSString *type = data[@"type"];
    if ( [type isEqualToString:@"title"] ) {
        cellToReturn = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cellToReturn.textLabel.text = data[@"text"];
    } else if ( [type isEqualToString:@"pictures"] ) {
        LandmarkPhotosTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LandmarkPhotosTableViewCell"];
        [cell addToImages:_trackData[@"pictures"]];
        cellToReturn = cell;
    } else if ( [type isEqualToString:@"note"] ) {
        AddNoteTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AddNoteTableViewCell"];
        [cell setNoteTitle:data[@"title"] andText:data[@"text"]];
        cellToReturn = cell;
    } else if ( [type isEqualToString:@"add"] ) {
        cellToReturn = [self.tableView dequeueReusableCellWithIdentifier:@"AddItemToNewLandmarkTableViewCell"];
    } else if ( [type isEqualToString:@"audio"] ) {
        cellToReturn = [self.tableView dequeueReusableCellWithIdentifier:@"AudioCellTableViewCell"];
    }
    
    return cellToReturn;
}

-(CGFloat)heightOfTextWithWidth:(CGFloat)width fontSize:(double)fontSize text:(NSString*)text
{
    UILabel *dummyLabel = [[UILabel alloc] init];
    [dummyLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [dummyLabel setNumberOfLines:0];
    [dummyLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [dummyLabel setText:text];
    
    CGSize textSize = [dummyLabel sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    
    return textSize.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cellData count];
}

- (IBAction)back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
}

-(IBAction)submit {
#warning This has to work kinda.
    // TODO
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( [indexPath row] > [self.cellData count] ) {
        return 42;
    }
    else {
        return [[[_cellData objectAtIndex:indexPath.row] objectForKey:@"height"] doubleValue];
    }
}

@end
