//
//  TripModel.h
//  FlySafe
//
//  Created by Gal Blank on 7/24/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 {
 "request": {
 "passengers": {
 "adultCount": 1,
 "childCount": 1
 },
 "slice": [
 {
 "origin": "OGG",
 "destination": "NCE",
 "date": "2014-09-19",
 "permittedDepartureTime":
 {
 "kind": "qpxexpress#timeOfDayRange",
 "earliestTime": "22:00",
 "latestTime": "23:00"
 }
 },
 {
 "origin": "NCE",
 "destination": "OGG",
 "date": "2014-09-28",
 "permittedDepartureTime":
 {
 "kind": "qpxexpress#timeOfDayRange",
 "earliestTime": "05:00",
 "latestTime": "12:00"
 }
 }
 ],
 "maxPrice": "USD5400",
 "solutions": 10
 }
 }
 */


@interface TripModel : NSObject
{
    NSString *from;
    NSString *to;
    NSMutableArray *viaArray;
    NSNumber *adults;
    NSNumber *children;
    NSString *departureDate;
    NSString *returnDate;
}

@property(nonatomic,strong)NSString *from;
@property(nonatomic,strong)NSString *to;
@property(nonatomic,strong)NSMutableArray *viaArray;
@property(nonatomic,strong)NSNumber *adults;
@property(nonatomic,strong)NSNumber *children;
@property(nonatomic,strong)NSString *departureDate;
@property(nonatomic,strong)NSString *returnDate;
@end
