//
//  SecondViewController.m
//  Tracker
//
//  Created by Ivo Kanchev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "SecondViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
#import "AddNewTrackViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // NEED THIS FOR TESTING
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Show me the table!" forState:UIControlStateNormal];
    [btn addTarget:nil action:@selector(testButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(100, 100, 100, 50)];
    [self.view addSubview:btn];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
        NSString *userId = token.userID;
        NSLog(@"User already logged in, userId: %@", userId);
    }
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    loginButton.delegate = delegate;
    [self.view addSubview:loginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) testButtonPressed {
    AddNewTrackViewController *tvc = [[AddNewTrackViewController alloc] initWithNibName:@"AddNewTrackViewController" bundle:nil];
//    [tvc.tableView setFrame:CGRectMake(100, 100, 250, 250)];
    [self.view addSubview:tvc.tableView];
}

@end
