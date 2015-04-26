//
//  selectInsertTypeViewController.m
//  Tracker
//
//  Created by Dimitar Stanev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "selectInsertTypeViewController.h"
#import "AddNoteViewController.h"

@interface selectInsertTypeViewController ()
- (IBAction)noteButtonClicked:(id)sender;
- (IBAction)pictureButtonClicked:(id)sender;
- (IBAction)voiceNoteButtonClicked:(id)sender;
@property (strong) UIImageView *imageSelected;
@end

@implementation selectInsertTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Choose what to add";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;

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

- (IBAction)noteButtonClicked:(id)sender {
    AddNoteViewController *anvc = [[AddNoteViewController alloc] init];
    anvc.delegate = self.delegate;
    [self presentViewController:anvc animated:YES completion:nil];
    
   
}

- (IBAction)pictureButtonClicked:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)cameraButtonClicked:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)voiceNoteButtonClicked:(id)sender {
    
}

- (IBAction)back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:info[UIImagePickerControllerEditedImage]];
    self.imageSelected = imgView;
    [self.delegate didChooseImage:self.imageSelected];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
