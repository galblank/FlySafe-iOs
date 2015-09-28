//
//  DeviceHelper.h
//  SmrtGuard
//
//  Created by Haemish Graham on 17/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


#define  SNAP_SECURE_DEVICE_UDID_KEY  @"snap_user_device_udid_key"
#define  SNAP_SECURE_DEVICE_APNSTOKEN  @"snap_user_device_apns_key"


@interface DeviceHelper : NSObject
{
}


+ (NSString*) getDeviceAPNS;
+ (NSString*) getDeviceName;
+ (NSString*) getOsVersion;
+ (NSString*) imei;


@end
