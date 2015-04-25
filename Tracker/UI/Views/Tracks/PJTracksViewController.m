//
//  PJTracksViewController.m
//  Tracker
//
//  Created by Ivan Raychev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "PJTracksViewController.h"
#import "PJTrackTableViewCell.h"

@interface PJTracksViewController ()

@end

@implementation PJTracksViewController {
    
    IBOutlet UITableView *_table;
    NSArray *_tracks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINib *nib = [UINib nibWithNibName:@"PJTrackTableViewCell" bundle:nil];
    [_table registerNib:nib forCellReuseIdentifier:@"PJTrackTableViewCell"];
    
    self.navigationItem.title = @"Regions";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;
    
}

-(void)setupWithRegionID:(NSString*)regionId
{
    //get stuff for region ID
    _tracks = @[@{
                    @"name": @"Track 1",
                    @"id": @"123",
                    @"thumbnail": @"https://cdn2.iconfinder.com/data/icons/ourea-icons/256/Mountain.png",
                    @"time": @"1.5h",
                    @"rating": @"85%",
                    @"distance": @"3.5km"
                    },
                @{
                    @"name": @"Track 2",
                    @"id": @"123",
                    @"thumbnail": @"https://camo.githubusercontent.com/ba543b374dfbe40a51be45f148e717757957e741/687474703a2f2f75706c6f61642e77696b696d656469612e6f72672f77696b6970656469612f636f6d6d6f6e732f7468756d622f332f33612f4d6f756e7461696e2d49636f6e2e7376672f31323870782d4d6f756e7461696e2d49636f6e2e7376672e706e67",
                    @"time": @"2.5h",
                    @"rating": @"67%",
                    @"distance": @"5.5km"
                    },
                ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tracks count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PJTrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJTrackTableViewCell"];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PJTrackTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    NSDictionary *track = [_tracks objectAtIndex:indexPath.row];
    //setup downloaded, selected, downloading and progress from core data by id
    [cell setupWithName:track[@"name"] thumbnailURL:track[@"thumbnail"] time:track[@"track"] rating:track[@"rating"] distance:track[@"distance"] downloaded:indexPath.row selected:NO downloading:1-indexPath.row progress:0.4];
    
    return cell;
}

- (IBAction)back
{
    [self.navigationController popViewControllerAnimated:YES]; // ios 6
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *track = [_tracks objectAtIndex:indexPath.row];
    NSLog(@"Clicked track with id %@", track[@"id"]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
