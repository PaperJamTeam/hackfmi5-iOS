//
//  CurrentLocationMarkerView.m
//  Tracker
//
//  Created by Ivo Kanchev on 4/25/15.
//  Copyright (c) 2015 bg.paperjam. All rights reserved.
//

#import "PJCurrentLocationMarkerView.h"

@implementation PJCurrentLocationMarkerView

+(PJCurrentLocationMarkerView *) viewWithNibName:(NSString *)nibName owner:(NSObject *)owner
{
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    id customView = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[self class]]) {
            customView = nibItem;
            break;
        }
    }
    return customView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
