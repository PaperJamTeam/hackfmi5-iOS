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
    
    NSObject *obj = [TrackDAO tracks];
    NSLog(@"%@", obj);
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
    
    PJTrackDetailsViewController *modalController = [[PJTrackDetailsViewController alloc] initWithNibName:@"PJTrackDetailsViewController" bundle:nil];
    [modalController setupWithTrackId:track[@"id"]];
    [self.navigationController pushViewController:modalController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
