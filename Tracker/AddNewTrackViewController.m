//
//  AddNewTrackViewController.m
//  Tracker
//
//  Created by Dimitar Stanev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "AddNewTrackViewController.h"

@interface AddNewTrackViewController ()

@end

@implementation AddNewTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
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
    UITableViewCell *cellToReturn = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddNewCheckpoint"];
    if ( [indexPath row] == 0 ) {
    }
    return cellToReturn;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


@end
