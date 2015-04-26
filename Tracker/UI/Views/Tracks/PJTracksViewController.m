//
//  PJTracksViewController.m
//  Tracker
//
//  Created by Ivan Raychev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "PJTracksViewController.h"
#import "PJTrackTableViewCell.h"
#import "PJTrackDetailsViewController.h"
#import "TrackDAO.h"
#import "Track.h"

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
    
    self.navigationItem.title = @"Tracks";
    
    [TrackDAO tracksWithBlock:^(NSArray *trackArray) {
        _tracks = trackArray;
        [_table reloadData];
    } andError:^(NSError *error) {
        NSLog(@"Failed with error: %@", error);
    }];
}

-(void)setupWithRegionID:(NSString*)regionId
{
    //get stuff for region ID
    _tracks = @[@{
                    @"name": @"Office",
                    @"id": @"123",
                    @"thumbnail": @"http://previewcf.turbosquid.com/Preview/2014/05/20__08_03_29/OfficeInterior02.jpgb61233eb-4f1b-4747-9e93-23d83468caf9Small.jpg",
                    @"time": @"15min",
                    @"rating": @"100%",
                    @"distance": @"500m"
                    },
                @{
                    @"name": @"FMI",
                    @"id": @"123",
                    @"thumbnail": @"http://isgt.fmi.uni-sofia.bg/images/fmi_medium.jpg",
                    @"time": @"30min",
                    @"rating": @"100%",
                    @"distance": @"1km"
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
    Track *track = [_tracks objectAtIndex:indexPath.row];
    //setup downloaded, selected, downloading and progress from core data by id
    [cell setupWithName:track.title thumbnailURL:@"https://camo.githubusercontent.com/ba543b374dfbe40a51be45f148e717757957e741/687474703a2f2f75706c6f61642e77696b696d656469612e6f72672f77696b6970656469612f636f6d6d6f6e732f7468756d622f332f33612f4d6f756e7461696e2d49636f6e2e7376672f31323870782d4d6f756e7461696e2d49636f6e2e7376672e706e67" time:@"5 hours" rating:@"93%" distance:@"3" downloaded:indexPath.row selected:NO downloading:1-indexPath.row progress:0.4];
    
    return cell;
}

- (IBAction)back
{
    [self.navigationController popViewControllerAnimated:YES]; // ios 6
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *track = [_tracks objectAtIndex:indexPath.row];
    
    PJTrackDetailsViewController *modalController = [[PJTrackDetailsViewController alloc] initWithNibName:@"PJTrackDetailsViewController" bundle:nil];
    [modalController setupWithTrackId:track[@"id"]];
    [self.navigationController pushViewController:modalController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
