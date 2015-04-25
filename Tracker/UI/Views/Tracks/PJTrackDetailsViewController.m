//
//  PJTrackDetailsViewController.m
//  Tracker
//
//  Created by Ivan Raychev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "PJTrackDetailsViewController.h"
#import "PJTrackReviewTableViewCell.h"

@interface PJTrackDetailsViewController ()

@end

@implementation PJTrackDetailsViewController {
    
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIView *_contentView;
    
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_authorLabel;
    IBOutlet UIImageView *_thumbnailView;
    IBOutlet UIButton *_downloadButton;
    IBOutlet UIProgressView *_progressView;
    
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_ratingLabel;
    IBOutlet UILabel *_distanceLabel;
    IBOutlet UILabel *_usersLabel;
    IBOutlet UILabel *_locationsLabel;
    
    IBOutlet UILabel *_descriptionLabel;
    IBOutlet UITableView *_reviewsTable;
    
    NSDictionary *_trackInfo;
    NSMutableArray *_cellHeights;
    
    CGFloat _viewHeight;
    IBOutlet NSLayoutConstraint *_tableViewHeightConstraint;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINib *nib = [UINib nibWithNibName:@"PJTrackReviewTableViewCell" bundle:nil];
    [_reviewsTable registerNib:nib forCellReuseIdentifier:@"PJTrackReviewTableViewCell"];
}

-(void)setupWithTrackId:(NSString*)trackId
{
    _trackInfo = @{
                   @"name": @"Track 1",
                   @"author": @"Fuckwad",
                   @"id": @"123",
                   @"thumbnail": @"https://cdn2.iconfinder.com/data/icons/ourea-icons/256/Mountain.png",
                   @"time": @"1.5h",
                   @"rating": @"85%",
                   @"distance": @"3.5km",
                   @"users": @"24",
                   @"landmarks": @"12",
                   @"description": @"I say things need saying because I want to say those things. Bitch.\nAlso, stuff and things and WORDS. MOAR WORDS GOD FUCKING DAMN IT!",
                   @"reviews": @[
                           @{
                               @"title": @"Bitch",
                               @"author": @"Grueber",
                               @"text": @"I likey the thingy you makey you shitpisscuntfuckcocksuckermotherfuckertitsfart, turd and twat."
                               },
                           @{
                               @"title": @"Ruby ruby ruby",
                               @"author": @"Ahaaaaah",
                               @"text": @"Do ya do ya do ya ahaaaah do this do this do this to me"
                               },
                           @{
                               @"title": @"Ruby ruby ruby",
                               @"author": @"Ahaaaaah",
                               @"text": @"Do ya do ya do ya ahaaaah do this do this do this to me"
                               }
                           ]
                   };
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //total height: 218 + desc height + table height
    //cell height:
    NSString *description = _trackInfo[@"description"];
    CGFloat descriptionHeight = [self heightOfTextWithWidth:_descriptionLabel.frame.size.width fontSize:16 text:description];
    [_descriptionLabel setText:description];
    
    _cellHeights = [[NSMutableArray alloc] init];
    CGFloat tableHeight = 0; //nees checking after cell is made
    NSArray *reviews = _trackInfo[@"reviews"];
    for ( NSDictionary *review in reviews ) {
        CGFloat cellHeight = 29 + [self heightOfTextWithWidth:280 fontSize:17 text:review[@"text"]];
        [_cellHeights addObject:@(cellHeight)];
        tableHeight += cellHeight;
    }
    
    [_tableViewHeightConstraint setConstant:tableHeight];
    _viewHeight = 218 + descriptionHeight + tableHeight;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSURL *imgURL=[[NSURL alloc]initWithString:_trackInfo[@"thumbnail"]];
        NSData *imgdata=[[NSData alloc]initWithContentsOfURL:imgURL];
        UIImage *image=[[UIImage alloc]initWithData:imgdata];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_thumbnailView setImage:image];
        });
    });
    
    [_nameLabel setText:_trackInfo[@"name"]];
    [_authorLabel setText:_trackInfo[@"author"]];
    [_timeLabel setText:_trackInfo[@"time"]];
    [_ratingLabel setText:_trackInfo[@"rating"]];
    [_distanceLabel setText:_trackInfo[@"distance"]];
    [_usersLabel setText:_trackInfo[@"users"]];
    [_locationsLabel setText:_trackInfo[@"landmarks"]];
    
    CGRect frame = _contentView.frame;
    frame.size.height = _viewHeight;
    _contentView.frame = frame;
    [_scrollView setContentSize:frame.size];
    [_scrollView addSubview:_contentView];
    
    [_reviewsTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cellHeights count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PJTrackReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJTrackReviewTableViewCell"];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PJTrackReviewTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    NSDictionary *review = _trackInfo[@"reviews"][indexPath.row];
    [cell setupWithTitle:review[@"title"] author:review[@"author"] andText:review[@"text"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_cellHeights[indexPath.row] doubleValue];
}

- (IBAction)back
{
    [self.navigationController popViewControllerAnimated:YES]; // ios 6
}

@end
