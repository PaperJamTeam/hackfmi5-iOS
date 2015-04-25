//
//  FirstViewController.m
//  Tracker
//
//  Created by Ivo Kanchev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "FirstViewController.h"
#import <WhirlyGlobeComponent.h>
#import "MaplyComponent.h"
#import <CoreLocation/CoreLocation.h>

@interface FirstViewController () <CLLocationManagerDelegate>

@property(strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) CLLocation *currentLocation;

@property(strong, nonatomic) MaplyScreenMarker *currentLocationMarker;
@property(strong, nonatomic) MaplyComponentObject *currentLocationMarkerObj;

- (void) addCountries;

@end

@implementation FirstViewController {
    MaplyBaseViewController *theViewC;
    NSDictionary *vectorDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeLocationManager];
    self.currentLocation = [[CLLocation alloc] initWithLatitude:42.678098 longitude:23.327055];
    
    theViewC = [[MaplyViewController alloc] init];
    [self.view addSubview:theViewC.view];
    theViewC.view.frame = self.view.bounds;
    [self addChildViewController:theViewC];
    
    
    WhirlyGlobeViewController *globeViewC = nil;
    MaplyViewController *mapViewC = nil;
    if ([theViewC isKindOfClass:[WhirlyGlobeViewController class]]) {
        globeViewC = (WhirlyGlobeViewController *)theViewC;
    } else {
        mapViewC = (MaplyViewController *)theViewC;
    }
    
    // we want a black background for a globe, a white background for a map.
    theViewC.clearColor = (globeViewC != nil) ? [UIColor blackColor] : [UIColor whiteColor];
    
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
        layer.handleEdges = (globeViewC != nil);
        layer.coverPoles = (globeViewC != nil);
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
        layer.handleEdges = (globeViewC != nil);
        layer.coverPoles = (globeViewC != nil);
        layer.requireElev = false;
        layer.waitLoad = false;
        layer.drawPriority = 0;
        layer.singleLevelLoading = false;
        [theViewC addLayer:layer];
    }
    
    if (globeViewC != nil)
    {
        globeViewC.height = 0.01;
        [globeViewC animateToPosition:MaplyCoordinateMakeWithDegrees(-122.4192,37.7793)
                                 time:1.0];
    } else {
        mapViewC.height = 0.01;
        [mapViewC animateToPosition:MaplyCoordinateMakeWithDegrees(23.3306,42.6744)
                               time:1.0];
    }
    
    
    // set the vector characteristics to be pretty and selectable
    vectorDict = @{
                   kMaplyColor: [UIColor redColor],
                   kMaplyVecWidth: @(4.0)};
    
    // add the countries
    [self addCountries];
    
    [self updateCurrentLocationPointer];

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
        // Or [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = locations.lastObject;
    [self updateCurrentLocationPointer];
}

#pragma mark Current Location Marker related methods
- (void)updateCurrentLocationPointer
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(!self.currentLocationMarker) {
            self.currentLocationMarker = [[MaplyScreenMarker alloc] init];
            self.currentLocationMarker.rotation = M_PI;
            self.currentLocationMarker.loc = MaplyCoordinateMakeWithDegrees(self.currentLocation.coordinate.longitude, self.currentLocation.coordinate.latitude);
            self.currentLocationMarker.size = CGSizeMake(.00040, .00040);

            self.currentLocationMarker.image = [UIImage imageNamed:@"map-pointer"];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentLocationMarkerObj = [theViewC addMarkers:@[self.currentLocationMarker] desc:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentLocationMarker.loc = MaplyCoordinateMakeWithDegrees(self.currentLocation.coordinate.longitude, self.currentLocation.coordinate.latitude);
                [theViewC removeObject:self.currentLocationMarkerObj];
                self.currentLocationMarkerObj = [theViewC addMarkers:@[self.currentLocationMarker] desc:nil];
            });
        }
    });
}

@end
