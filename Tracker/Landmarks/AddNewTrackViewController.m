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


@interface AddNewTrackViewController ()
@property NSInteger currentNumberOfCells;
@property (atomic, strong) NSMutableArray* chosenImages;
@property BOOL hasAddedImages;
@end

@implementation AddNewTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasAddedImages = NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.chosenImages = [[NSMutableArray alloc] init];
    self.currentNumberOfCells = 2;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // NIB setup
    UINib *nibForNameCell = [UINib nibWithNibName:@"NewLandmarkTableViewCell" bundle:nil];
    [self.tableView registerNib:nibForNameCell forCellReuseIdentifier:@"NewLandmarkNameTableViewCell"];
    UINib *nibForAddNewCell = [UINib nibWithNibName:@"AddItemToNewLandmarkTableViewCell" bundle:nil];
    [self.tableView registerNib:nibForAddNewCell forCellReuseIdentifier:@"AddItemToNewLandmarkTableViewCell"];
    UINib *nibForPhotos = [UINib nibWithNibName:@"LandmarkPhotosTableViewCell" bundle:nil];
    [self.tableView registerNib:nibForPhotos forCellReuseIdentifier:@"LandmarkPhotosTableViewCell"];
//    [self.tableView registerClass:[LandmarkPhotosTableViewCell class] forCellReuseIdentifier:@"LandmarkPhotosTableViewCell"];

    // NAVIGATION SECTION
    self.navigationItem.title = @"Add new landmark";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.leftBarButtonItem = backButton;
    // Do any additional setup after loading the view from its nib.
    
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
    if ( [indexPath row] == 0 ) {
        cellToReturn = [self.tableView dequeueReusableCellWithIdentifier:@"NewLandmarkNameTableViewCell"];
    }
    else if ( [indexPath row] == self.currentNumberOfCells-1 ) {
        cellToReturn = [self.tableView dequeueReusableCellWithIdentifier:@"AddItemToNewLandmarkTableViewCell"];
    }
    else {
        cellToReturn = [[UITableViewCell alloc] init];
    }
    if ( self.currentNumberOfCells > 2 ) {
        if ( [indexPath row] == 1) {
            LandmarkPhotosTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LandmarkPhotosTableViewCell"];
            [cell addToImages:self.chosenImages];
            cellToReturn = cell;
        }
    }
    return cellToReturn;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentNumberOfCells;
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
    if ( self.currentNumberOfCells > 2 && [indexPath row] == 1 ) {
        return 200;
    }
    return 42;
}

-(void) didChooseImage:(UIImageView*)image {
    [self.chosenImages addObject:image];
    if ( !self.hasAddedImages ) {
        self.currentNumberOfCells++;
        self.hasAddedImages = YES;
    }
    [self.tableView reloadData];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}
@end
