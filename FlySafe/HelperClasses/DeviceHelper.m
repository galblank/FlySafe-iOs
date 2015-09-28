//
//  DeviceHelper.m
//  SmrtGuard
//
//  Created by Haemish Graham on 17/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DeviceHelper.h"
#include "TargetConditionals.h"
#import <Security/Security.h>
#import "Globals.h"


@implementation DeviceHelper

+ (NSString*) getDeviceAPNS
{

    return @"Apns";
}


+ (NSString*)getDeviceName
{
    return [UIDevice currentDevice].name;
}


+ (NSString*)getOsVersion
{
	UIDevice *device = [UIDevice currentDevice];
	return [device systemVersion];
}

+ (NSString*)imei
{
	return @"";
}

@end
