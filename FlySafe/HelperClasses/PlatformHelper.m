//
//  PlatformHelper.m
//  SmrtGuard
//
//  Created by Haemish Graham on 17/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlatformHelper.h"
#import <UIKit/UIKit.h>

@implementation PlatformHelper


+(void) alert:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

+(NSNumber*) currentTimeMillis
{
	NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
	return [NSNumber numberWithUnsignedLongLong:(unsigned long long)(now * 1000.0)];
}

@end
