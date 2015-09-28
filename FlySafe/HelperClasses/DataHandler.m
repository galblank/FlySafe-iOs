//
//  DataHandler.m
//  First App
//
//  Created by Gal Blank on 9/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DataHandler.h"
#import "Globals.h"
static DataHandler *sharedSampleSingletonDelegate = nil;

@implementation DataHandler




+ (DataHandler *)sharedInstance {
	@synchronized(self) {
		if (sharedSampleSingletonDelegate == nil) {
			[[self alloc] init]; // assignment not done here
		}
	}
	return sharedSampleSingletonDelegate;
}


+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedSampleSingletonDelegate == nil) {
			sharedSampleSingletonDelegate = [super allocWithZone:zone];
			// assignment and return on first allocation
			return sharedSampleSingletonDelegate;
		}
	}
	// on subsequent allocation attempts return nil
	return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}


-(id)init
{
	if (self = [super init]) {
	}
	return self;
}

- (NSString*)getSerialNumber
{
	NSString *uniqueID = @"dfgdfgdf";
	

 return uniqueID;
} 


@end
