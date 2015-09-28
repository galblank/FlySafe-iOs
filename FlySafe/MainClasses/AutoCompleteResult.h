//
//  TripModel.h
//  iLimo
//
//  Created by Gal Blank on 5/26/12.
//  Copyright (c) 2012 Vivat Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>

@interface AutoCompleteResult : NSObject
{
    NSString *description;
    NSString *address;
    CLLocationCoordinate2D coordinates;
    NSString *iconUrl;
    NSString *types;
    NSString *placeId;
    NSString *Id;
}
@property(nonatomic,retain)NSString *Id;
@property(nonatomic,retain)NSString *placeId;
@property(nonatomic,retain)NSString *description;
@property(nonatomic,retain)NSString *address;
@property(nonatomic,retain)NSString *iconUrl;
@property(nonatomic,retain)NSString *types;
@property(nonatomic)CLLocationCoordinate2D coordinates;
@end
