//
//  PJRegionsViewController.m
//  Tracker
//
//  Created by Ivan Raychev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "PJRegionsViewController.h"
#import "PJRegionTableViewCell.h"
#import "PJTracksViewController.h"

@interface PJRegionsViewController ()

@end

@implementation PJRegionsViewController {
    IBOutlet UITableView *_table;
    NSArray *_regions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINib *nib = [UINib nibWithNibName:@"PJRegionTableViewCell" bundle:nil];
    [_table registerNib:nib forCellReuseIdentifier:@"PJRegionTableViewCell"];
    
    self.navigationItem.title = @"Regions";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;

    _regions = @[@{
                     @"name": @"Region 1",
                     @"id": @"123"
                     },
                 @{
                     @"name": @"Region 2",
                     @"id": @"234"
                     }
                 ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_regions count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PJRegionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJRegionTableViewCell"];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PJRegionTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    NSDictionary *region = [_regions objectAtIndex:indexPath.row];
    //setup downloaded, downloading adn progress from core data by id
    [cell setupWithName:region[@"name"] downloaded:NO downloading:NO progress:0];
    
    return cell;
}

- (IBAction)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *region = [_regions objectAtIndex:indexPath.row];
    
    PJTracksViewController *modalController = [[PJTracksViewController alloc] initWithNibName:@"PJTracksViewController" bundle:nil];
    [modalController setupWithRegionID:region[@"id"]];
    [self.navigationController pushViewController:modalController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
