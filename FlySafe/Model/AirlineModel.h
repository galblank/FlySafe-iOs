//
//  AirlineModel.h
//  FlySafe
//
//  Created by Gal Blank on 7/24/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
#define RATING_RED_BOTTOM -140
#define RATING_RED_HIGH -75

#define RATING_ORANGE_BOTTOM -73
#define RATING_ORANGE_HIGH -35

#define RATING_YELLOW_BOTTOM -33
#define RATING_YELLOW_TOP 19

#define RATING_SALAD_BOTTOM 17
#define RATING_SALAD_TOP 70

#define RATING_GREEN_BOTTOM 70
#define RATING_GREEN_TOP 120
 */

#define RATING_RED_BOTTOM 0
#define RATING_RED_HIGH 20

#define RATING_ORANGE_BOTTOM 20
#define RATING_ORANGE_HIGH 40

#define RATING_YELLOW_BOTTOM 40
#define RATING_YELLOW_TOP 60

#define RATING_SALAD_BOTTOM 60
#define RATING_SALAD_TOP 80

#define RATING_GREEN_BOTTOM 80
#define RATING_GREEN_TOP 100

@interface AirlineModel : NSObject
{
    NSString *name;
    NSString *iata;
    NSString *officialName;
    NSString *country;
    NSString *beganOperation;
    NSNumber *fleetAgeAVG;
    NSString *passengerVolume;
    NSString *lastCrash;
    NSNumber *fatalAccidents10Years;
    NSNumber *fatalAccidents20Years;
    NSString *comments;
    NSNumber *rating;
}
@property(nonatomic,strong)NSNumber *rating;
@property(nonatomic,strong)NSString *comments;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *iata;
@property(nonatomic,strong)NSString *officialName;
@property(nonatomic,strong)NSString *country;
@property(nonatomic,strong)NSString *beganOperation;
@property(nonatomic,strong)NSNumber *fleetAgeAVG;
@property(nonatomic,strong)NSString *passengerVolume;
@property(nonatomic,strong)NSString *lastCrash;
@property(nonatomic,strong)NSNumber *fatalAccidents10Years;
@property(nonatomic,strong)NSNumber *fatalAccidents20Years;

-(void)copyConstructor:(AirlineModel*)model;
@end
