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

@interface PJMapViewController () <CLLocationManagerDelegate, MaplyViewControllerDelegate>

@property(strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) CLLocation *currentLocation;

@property(strong, nonatomic) PJCurrentLocationMarkerView *currentLocationMarker;

@property(strong, nonatomic) NSTimer *currentPositionUpdateTimer;

- (void) addCountries;

@end

@implementation PJMapViewController {
    MaplyViewController *theViewC;
    NSDictionary *vectorDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeLocationManager];
    self.currentLocation = [[CLLocation alloc] initWithLatitude:42.678098 longitude:23.327055];
    
    theViewC = [[MaplyViewController alloc] init];
    theViewC.delegate = self;
    [self.view addSubview:theViewC.view];
    theViewC.view.frame = self.view.bounds;
    [self addChildViewController:theViewC];
    
    for(UIPanGestureRecognizer *panGestureRecognizer in [theViewC.view.subviews[0] gestureRecognizers]) {
        [panGestureRecognizer addTarget:self action:@selector(positionCurrentLocationPointer)];
    }
    
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
    
    // Add world map
    {
        MaplyMBTileSource *tileSource =
        [[MaplyMBTileSource alloc] initWithMBTiles:@"geography-class_medres"];
        
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

    mapViewC.height = 0.01;
    [mapViewC animateToPosition:MaplyCoordinateMakeWithDegrees(23.3306,42.6744)
                               time:1.0];
    
    
    // set the vector characteristics to be pretty and selectable
    vectorDict = @{
                   kMaplyColor: [UIColor redColor],
                   kMaplyVecWidth: @(4.0)};
    
    // add the countries
    [self addCountries];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

#pragma mark Current Location Marker related methods
- (void)updateCurrentLocationPointer
{
    if(!self.currentLocationMarker) {
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

@end