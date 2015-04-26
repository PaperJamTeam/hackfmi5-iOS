//
//  FirstViewController.m
//  Tracker
//
//  Created by Ivo Kanchev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "PJMapViewController.h"
#import <WhirlyGlobeComponent.h>
#import "MaplyComponent.h"
#import <CoreLocation/CoreLocation.h>
#import "PJCurrentLocationMarkerView.h"
#import "GpsDAO.h"
#import "PureLayout.h"
#import "CheckpointDAO.h"

@interface PJMapViewController () <CLLocationManagerDelegate, MaplyViewControllerDelegate>

@property(strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) CLLocation *currentLocation;

@property(strong, nonatomic) PJCurrentLocationMarkerView *currentLocationMarker;

@property(strong, nonatomic) NSTimer *currentPositionUpdateTimer;

@property(strong, nonatomic) UIButton *recordButton;
@property(strong, nonatomic) UIButton *settingsButton;
@property(strong, nonatomic) UIButton *regionsButton;

- (void) addCountries;

@end

@implementation PJMapViewController {
    MaplyViewController *theViewC;
    NSDictionary *vectorDict;
    NSDictionary *sendPhotoDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeLocationManager];
    self.currentLocation = [[CLLocation alloc] initWithLatitude:42.678098 longitude:23.327055];
    
    theViewC = [[MaplyViewController alloc] initAsFlatMap];
    theViewC.delegate = self;
    [self.view addSubview:theViewC.view];
    theViewC.view.frame = self.view.bounds;
    [self addChildViewController:theViewC];
    
    MaplyViewController *mapViewC = nil;
    mapViewC = (MaplyViewController *)theViewC;
    
    // we want a black background for a globe, a white background for a map.
    theViewC.clearColor = [UIColor whiteColor];
    
    // and thirty fps if we can get it ­ change this to 3 if you find your app is struggling
    theViewC.frameInterval = 2;
    
    // Add Sofia map
    {
        MaplyMBTileSource *tileSource =
        [[MaplyMBTileSource alloc] initWithMBTiles:@"sofia"];
        
        // set up the layer
        MaplyQuadImageTilesLayer *layer =
        [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:tileSource.coordSys
                                                   tileSource:tileSource];
        layer.requireElev = false;
        layer.waitLoad = false;
        layer.drawPriority = 0;
        layer.singleLevelLoading = false;
        [theViewC addLayer:layer];
    }
    
//    // Add world map
//    {
//        MaplyMBTileSource *tileSource =
//        [[MaplyMBTileSource alloc] initWithMBTiles:@"geography-class_medres"];
//        
//        // set up the layer
//        MaplyQuadImageTilesLayer *layer =
//        [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:tileSource.coordSys
//                                                   tileSource:tileSource];
//        layer.requireElev = false;
//        layer.waitLoad = false;
//        layer.drawPriority = 0;
//        layer.singleLevelLoading = false;
//        [theViewC addLayer:layer];
//    }

    mapViewC.height = 0.001;
    [mapViewC animateToPosition:MaplyCoordinateMakeWithDegrees(23.3306,42.6744)
                               time:1.0];
    
    
    // set the vector characteristics to be pretty and selectable
    vectorDict = @{
                   kMaplyColor: [UIColor redColor],
                   kMaplyVecWidth: @(4.0)};
    
    // add the countries
    [self addCountries];
    
    
    //setup buttons
    {
        self.recordButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.recordButton.tintColor = [UIColor redColor];
        [self.recordButton setImage:[[UIImage imageNamed:@"record"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.recordButton.frame = CGRectMake(10, 517, 36, 36);
        [self.view addSubview:self.recordButton];
    }
    
    {
        self.settingsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.settingsButton setImage:[[UIImage imageNamed:@"options"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.settingsButton.tintColor = [UIColor blackColor];
        self.settingsButton.frame = CGRectMake(275, 15, 30, 36);
        [self.settingsButton addTarget:self action:@selector(sendPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.settingsButton];
    }
    
    {
        self.regionsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.regionsButton setImage:[[UIImage imageNamed:@"region-button"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.regionsButton.tintColor = [UIColor blackColor];
        self.regionsButton.frame = CGRectMake(270, 517, 36, 36);
        [self.view addSubview:self.regionsButton];
    }
    
    [[[self tabBarController] tabBar] setHidden:YES];

    
    
    
//    {
//        UIImage *image = [UIImage imageNamed:@"options"];
//        
//        Checkpoint *checkpoint = [[Checkpoint alloc] init];
//        checkpoint.imageName = image.
//        checkpoint.title = @"HackFMI";
//        checkpoint.note = @"NOTE NOTE NOTE";
//        checkpoint.checkpoint_lat = [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.latitude];
//        checkpoint.checkpoint_lon = [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.longitude];
//        checkpoint.trackData = UIImageJPEGRepresentation(image, .7);
//        [CheckpointDAO postCheckpoint:checkpoint withCompletion:^(RKMappingResult *result) {
//            
//        } andFailure:^(NSError *error) {
//            
//        }];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showSettings
{
    UIView *settingsView = [[[NSBundle mainBundle] loadNibNamed:@"SettingsView" owner:nil options:nil] objectAtIndex:0];
    [self.view addSubview:settingsView];
}

- (void)addCountries
{
    // handle this in another thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),
                   ^{
                       NSArray *allOutlines = [[NSBundle mainBundle] pathsForResourcesOfType:@"geojson" inDirectory:nil];
                       
                       for (NSString *outlineFile in allOutlines)
                       {
                           NSData *jsonData = [NSData dataWithContentsOfFile:outlineFile];
                           if (jsonData)
                           {
                               MaplyVectorObject *wgVecObj = [MaplyVectorObject VectorObjectFromGeoJSON:jsonData];
                               
                               // the admin tag from the country outline geojson has the country name ­ save
                               NSString *vecName = [[wgVecObj attributes] objectForKey:@"ADMIN"];
                               wgVecObj.userObject = vecName;
                               
                               // add the outline to our view
                               MaplyComponentObject *compObj = [theViewC addVectors:[NSArray arrayWithObject:wgVecObj] desc:vectorDict];
                               // If you ever intend to remove these, keep track of the MaplyComponentObjects above.
                               
//                               if ([vecName length] > 0)
//                               {
//                                   MaplyScreenLabel *label = [[MaplyScreenLabel alloc] init];
//                                   label.text = vecName;
//                                   label.loc = [wgVecObj center];
//                                   label.selectable = true;
//                                   [theViewC addScreenLabels:@[label] desc:
//                                    @{
//                                      kMaplyFont: [UIFont boldSystemFontOfSize:24.0],
//                                      kMaplyTextOutlineColor: [UIColor blackColor],
//                                      kMaplyTextOutlineSize: @(2.0),
//                                      kMaplyColor: [UIColor whiteColor]
//                                      }];
//                               }
                           }
                       }
                   });
}

- (IBAction)sendPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        UITextField *titleField = [[UITextField alloc] init];
        [titleField setBackgroundColor:[UIColor whiteColor]];
        [titleField setFrame:CGRectMake(50, self.view.frame.size.height/2.0 - 20, 100, 40)];
        [self.view addSubview:titleField];

        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [sendButton setBackgroundColor:[UIColor whiteColor]];
        [sendButton setFrame:CGRectMake(160, self.view.frame.size.height/2.0 - 20, 100, 40)];
        [sendButton addTarget:self action:@selector(sendCheckpoint) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sendButton];

        sendPhotoDict = @{
                          @"button": sendButton,
                          @"field": titleField,
                          @"image": image
                          };
       }];
    
    Checkpoint *checkpoint = [[Checkpoint alloc] init];
    checkpoint.title = @"IMAGE TEST";
    checkpoint.note = @"";
    checkpoint.checkpoint_lat = [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.latitude];
    checkpoint.checkpoint_lon = [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.longitude];
    checkpoint.trackData = UIImageJPEGRepresentation(image, .7);
    [CheckpointDAO postCheckpoint:checkpoint withCompletion:^(RKMappingResult *result) {
       
    } andFailure:^(NSError *error) {
        
        
    }];
}

-(void)sendCheckpoint
{
    NSString *title = [sendPhotoDict[@"field"] text];
    UIImage *image = sendPhotoDict[@"image"];
    [sendPhotoDict[@"field"] removeFromSuperview];
    [sendPhotoDict[@"button"] removeFromSuperview];
    sendPhotoDict = nil;
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark CLLocationManager related methods
- (void)initializeLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.delegate = self;
    self.currentLocation = [[CLLocation alloc] init];
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = locations.lastObject;
    [self updateCurrentLocationPointer];
    [self sendCoordinates];
}

#pragma mark Current Location Marker related methods
- (void)updateCurrentLocationPointer
{
    if(!self.currentLocationMarker) {
        [theViewC animateToPosition:MaplyCoordinateMakeWithDegrees(self.currentLocation.coordinate.longitude, self.currentLocation.coordinate.latitude)
                               time:1.0];
        self.currentPositionUpdateTimer = [NSTimer timerWithTimeInterval:0.0005 target:self selector:@selector(positionCurrentLocationPointer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.currentPositionUpdateTimer forMode:NSDefaultRunLoopMode];
        self.currentLocationMarker = [PJCurrentLocationMarkerView viewWithNibName:@"PJCurrentLocationMarker" owner:self];
        [theViewC.view addSubview:self.currentLocationMarker];
//        [self.currentPositionUpdateTimer fire];
    }
}

- (void)positionCurrentLocationPointer
{
    CGPoint screenPointFromCoordinate = [theViewC screenPointFromGeo:MaplyCoordinateMakeWithDegrees(self.currentLocation.coordinate.longitude, self.currentLocation.coordinate.latitude)];
    self.currentLocationMarker.frame = CGRectMake(screenPointFromCoordinate.x - self.currentLocationMarker.frame.size.width/2,screenPointFromCoordinate.y - self.currentLocationMarker.frame.size.height,self.currentLocationMarker.frame.size.width, self.currentLocationMarker.frame.size.height);
}

#pragma mark Rest related
-(void)sendCoordinates
{
    GpsCoordinate *gpsCoord = [[GpsCoordinate alloc] init];
    gpsCoord.uuid = @"phone";
    gpsCoord.lat = [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.latitude];
    gpsCoord.lon = [NSString stringWithFormat:@"%f", self.currentLocation.coordinate.longitude];
    [GpsDAO postGpsCoordinate:gpsCoord withCompletion:^(RKMappingResult *mappingResult) {
        NSLog(@"Sent realtime gps data with result: %@", mappingResult);
    } andFailure:^(NSError *error) {
        NSLog(@"Failed sending realtime gps data with error: %@", error);
    }];
}

@end
