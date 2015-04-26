//
//  AddNewTrackViewController.m
//  Tracker
//
//  Created by Dimitar Stanev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "AddNewTrackViewController.h"
#import "AddItemToNewLandmarkTableViewCell.h"
#import "selectInsertTypeViewController.h"
#import "LandmarkPhotosTableViewCell.h"
#import "AddNoteTableViewCell.h"

@interface AddNewTrackViewController ()
@property ( nonatomic, strong ) NSDictionary* trackData;
@property (nonatomic, strong) NSArray *cellData;
@end

@implementation AddNewTrackViewController

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
    
    // NAVIGATION SECTION
//    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Add new landmark"];
////    self.navigationItem.title = @"Add new landmark";
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(submit)];
//    navItem.rightBarButtonItem = doneButton;
//    navItem.leftBarButtonItem = backButton;
    // Do any additional setup after loading the view from its nib.
    
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
    
//    for ( NSDictionary *audio in _trackData[@"audio"] ) {
//        
//    }
//    
//    for ( NSDictionary *video in _trackData[@"video"] ) {
//        
//    }
    
    [cells addObject:@{
                      @"type": @"add",
                      @"height": @(42)
                       }];
    
    _cellData = [cells copy];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cellToReturn;
    
    NSDictionary *data = _cellData[indexPath.row];
    NSString *type = data[@"type"];
    if ( [type isEqualToString:@"title"] ) {
        cellToReturn = [self.tableView dequeueReusableCellWithIdentifier:@"NewLandmarkNameTableViewCell"];
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
    // TODO
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( [[self.tableView cellForRowAtIndexPath:indexPath] isKindOfClass: [AddItemToNewLandmarkTableViewCell class]] ) {
        NSLog(@"YOU WANT TO ADD SOMETHING !!!");
        selectInsertTypeViewController *svc = [[selectInsertTypeViewController alloc] init];
        [svc setTitle:@"Add new"];
        svc.delegate = self;
        [self presentViewController:svc animated:YES completion:nil];
//        [self.view addSubview:self.insertChoice];

    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[[_cellData objectAtIndex:indexPath.row] objectForKey:@"height"] doubleValue];
}

-(void) didChooseImage:(UIImageView*)image {
    [[self.trackData valueForKey:@"pictures"] addObject:image];
    [self reloadTable];
}

-(void)addNoteWithTitle:(NSString *)title andText:(NSString *)text
{
    NSDictionary *note = @{
                           @"title": title,
                           @"text": text
                           };
    [_trackData[@"notes"] addObject:note];
    [self reloadTable];
}

@end
