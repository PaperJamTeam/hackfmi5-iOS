//
//  FirstViewController.m
//  Tracker
//
//  Created by Ivo Kanchev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "FirstViewController.h"
#import <WhirlyGlobeMaplyComponent/WhirlyGlobeComponent.h>
#import "MaplyComponent.h"

@interface FirstViewController ()
- (void) addCountries;
@end

@implementation FirstViewController {
    MaplyBaseViewController *theViewC;
    NSDictionary *vectorDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    // set up the data source
    MaplyMBTileSource *tileSource =
    [[MaplyMBTileSource alloc] initWithMBTiles:@"map"];
    
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
    
    if (globeViewC != nil)
    {
        globeViewC.height = 0.01;
        [globeViewC animateToPosition:MaplyCoordinateMakeWithDegrees(-122.4192,37.7793)
                                 time:1.0];
    } else {
        mapViewC.height = 0.01;
        [mapViewC animateToPosition:MaplyCoordinateMakeWithDegrees(23.3239467,42.6954321)
                               time:1.0];
    }
    
    
    // set the vector characteristics to be pretty and selectable
    vectorDict = @{
                   kMaplyColor: [UIColor whiteColor],
                   kMaplySelectable: @(true),
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



@end
