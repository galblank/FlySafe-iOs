//
//  Globals.m
//  First App
//
//  Created by Gal Blank on 9/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Globals.h"
#import "DataHandler.h"
#import <CoreLocation/CoreLocation.h>

static Globals *sharedSingletonDelegate = nil;

@implementation Globals
@synthesize mainmenuLinks,currentUrlPath,nSavedBooksCount,bReadingSavedBook,bRunningOniPad,siteMirrorsArray;
@synthesize username,password,textColor,deviceToken,errorsMap,globalMeetingDetails,userCountry,userCity,savedBooks,urlPathArray,countryList;

+ (Globals *)sharedInstance {
	@synchronized(self) {
		if (sharedSingletonDelegate == nil) {
			[[self alloc] init]; // assignment not done here
		}
	}
	return sharedSingletonDelegate;
}


+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedSingletonDelegate == nil) {
			sharedSingletonDelegate = [super allocWithZone:zone];
			// assignment and return on first allocation
			return sharedSingletonDelegate;
		}
	}
	// on subsequent allocation attempts return nil
	return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}


- (NSString *) stripTags:(NSString *)str
{
    NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSString *tempText = nil;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:&tempText];
        
        if (tempText != nil)
            [html appendString:tempText];
        
        [scanner scanUpToString:@">" intoString:NULL];
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + 1];
        
        tempText = nil;
    }
    
    return html;
}


-(CGFloat)getWidth
{
    if(bRunningOniPad == YES){
        return 768.0;
    }
    return 320.0;
}

-(CGFloat)getHeight
{
    if(bRunningOniPad == YES){
        return 1024.0;
    }
    return 480.0; 
}


-(NSMutableArray*) getLocationFromAddressString:(NSString*) addressStr {
    
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
	
    NSString *urlStr = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",[addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
    NSString *locationStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlStr]];
	
    NSArray *items = [locationStr componentsSeparatedByString:@","];
	
	
    double lat = 0.0;
	
    double longtitude = 0.0;
	
	
    if([items count] >= 4 && [[items objectAtIndex:0] isEqualToString:@"200"]) {
		
        lat = [[items objectAtIndex:2] doubleValue];
		
        longtitude = [[items objectAtIndex:3] doubleValue];
		
    }
	
    else {
		
        NSLog(@"Address, %@ not found: Error %@",addressStr, [items objectAtIndex:0]);
		
    }
    [retArray addObject:[NSNumber numberWithDouble:lat]];
    [retArray addObject:[NSNumber numberWithDouble:longtitude]];
    return retArray;
	
}


@end
