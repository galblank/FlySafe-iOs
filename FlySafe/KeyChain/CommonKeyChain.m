//
//  CommonKeyChain.m
//  SnapSecure
//
//  Created by Gal Blank on 3/18/14.
//  Copyright (c) 2014 SnapOne. All rights reserved.
//

#import "CommonKeyChain.h"
#import "UICKeyChainStore.h"
#import "AppDelegate.h"

@implementation CommonKeyChain

static CommonKeyChain *sharedSingletonDelegate = nil;

#pragma mark - Keychain

+ (CommonKeyChain *)sharedInstance {
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

-(id)init
{
	if (self = [super init]) {

	}
	return self;
}
//////////////////////////////////////////////////
-(NSString*)getDeviceUDIDFromCommonKeychain
{
    return @"";
}


- (NSString *)bundleSeedID
{

    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)(kSecClassGenericPassword), kSecClass,
                           @"bundleSeedID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly,(__bridge id)kSecAttrAccessible,
                           nil];
    
    CFDictionaryRef result = nil;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    
    if(status == errSecItemNotFound)
    {
        status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
        NSLog(@"bundleSeedID:SecItemAdd status: %d",status);
    }
    
    // errSecDuplicateItem = -25299
    // The specified item already exists in the keychain.
    
    if (status != errSecSuccess)
    {
        NSLog(@"bundleSeedID:: status = %d, returning default bundleId JM58CVM2A3", status);
        return @"JM58CVM2A3";
    }
    
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge id)(kSecAttrAccessGroup)];
    NSLog(@"bundleSeedID:accessGroup %@",accessGroup);
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    if(components != nil){
        NSLog(@"bundleSeedID:components %@",components);
    }
    
    NSString *_bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    
    return _bundleSeedID;
}


- (void)initializeKeychain
{
   
    NSString *_bundleSeedId = [self bundleSeedID];
    //[UICKeyChainStore removeAllItemsForService:@"com.snapone" accessGroup:[NSString stringWithFormat:@"%@.com.snapone.onekeychain",_bundleSeedId]];
    //[AppDelegate shared].deviceUDID = nil;
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"com.mlc" accessGroup:[NSString stringWithFormat:@"%@.com.mlc.onekeychain",_bundleSeedId]];
    
    NSLog(@"store:  %@", store); // Print all keys and values for the service.
    NSLog(@"initializeKeychain for Key : SnapOne Device Identifier");
    
    
    NSLog(@"Bundle ID %@",_bundleSeedId);
    
    NSString *newitemString = [UICKeyChainStore stringForKey:@"SnapOneAppKeyChain" service:@"com.mlc" accessGroup:[NSString stringWithFormat:@"%@.com.mlc.onekeychain",_bundleSeedId]];
    
    if(newitemString == nil || newitemString.length == 0)
    {
        // Before we create a new UDID, lets check to see if we are in the background and the user already has one.
        if([AppDelegate shared].deviceUDID)
        {
            // Lets just use the existing UDID. Skip creation.
            NSLog(@"[CommonKeyChain] - Using existing (NSUserDefaults) UDID: %@", [AppDelegate shared].deviceUDID);
            
            // Use this for debugging...
            //[[AppDelegate shared] displayLocalPushNotification:@"[CommonKeyChain] -initializeKeychain- Using existing UDID!"];
        }
        else
        {
            NSLog(@"[CommonKeyChain] - UDID NOT found! Creating new UDID");
            
            newitemString = [self createNewDeviceUDID];
            
            [UICKeyChainStore setString:newitemString forKey:@"SnapOneAppKeyChain" service:@"com.mlc" accessGroup:[NSString stringWithFormat:@"%@.com.mlc.onekeychain",_bundleSeedId]];
            
            NSLog(@"Generated and set new device UDID %@ for Keychain SnapOneAppKeyChain with accessGroup %@",newitemString,[NSString stringWithFormat:@"%@.com.mlc.onekeychain",_bundleSeedId]);
            [AppDelegate shared].deviceUDID = newitemString;
            [[AppDelegate shared] saveUserDefaults];
        }
    }
    else
    {
        NSLog(@"Found Existing UDID %@ for Keychain SnapOneAppKeyChain with accessGroup %@",newitemString,[NSString stringWithFormat:@"%@.com.mlc.onekeychain",_bundleSeedId]);
        [AppDelegate shared].deviceUDID = newitemString;
        [[AppDelegate shared] saveUserDefaults];
    }
}



- (NSString*)getKeychainItem
{
    NSString *_bundleSeedId = [self bundleSeedID];
    
    NSString *itemString = [UICKeyChainStore stringForKey:@"SnapOneAppKeyChain" service:@"com.mlc" accessGroup:[NSString stringWithFormat:@"%@.com.mlc.onekeychain",_bundleSeedId]];
    
    if(itemString)
    {
        if([itemString length] == 0)
        {
            itemString = nil;
        }
    }
    
    NSLog(@"getKeychainItem for AccessGroup %@ itemString: %@", itemString,[NSString stringWithFormat:@"%@.com.mlc.onekeychain",_bundleSeedId]);
    
    return(itemString);
}


- (void)clearKeyChain
{
    NSLog(@"clearKeyChain");
    
    [UICKeyChainStore removeAllItemsForService:@"com.snapone" accessGroup:[NSString stringWithFormat:@"%@.com.mlc.onekeychain", [self bundleSeedID]]];
}


- (NSString*)createNewDeviceUDID
{
    NSString *snapUDID = nil;

    CFUUIDRef theUUID    = CFUUIDCreate(NULL);
    CFStringRef cfString = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    snapUDID = [NSString stringWithFormat:@"%@", cfString];
    NSLog(@"Created New Device UDID = %@", snapUDID);
    return(snapUDID);
}

@end
