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
#import "PJRegionsViewController.h"
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
    
    UIButton *regionsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [regionsButton setFrame:CGRectMake(loginButton.frame.origin.x, loginButton.frame.origin.y - 50, loginButton.frame.size.width, loginButton.frame.size.height)];
    [regionsButton setTitle:@"regions" forState:UIControlStateNormal];
    [regionsButton addTarget:self action:@selector(showRegions) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regionsButton];
    [self.view bringSubviewToFront:regionsButton];
}

-(void)showRegions
{
    PJRegionsViewController *modalController = [[PJRegionsViewController alloc] initWithNibName:@"PJRegionsViewController" bundle:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:modalController];
    
    navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    // And now you want to present the view in a modal fashion
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) testButtonPressed {
    AddNewTrackViewController *modalController = [[AddNewTrackViewController alloc] initWithNibName:@"AddNewTrackViewController" bundle:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:modalController];
    
    navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    // And now you want to present the view in a modal fashion
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
