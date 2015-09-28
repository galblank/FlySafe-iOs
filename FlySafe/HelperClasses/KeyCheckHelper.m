//
//  KeyCheckHelper.m
//  SmrtGuard
//
//  Created by Joe Huang on 11-09-29.
//  Copyright (c) 2011 Smrtphone Solutions, Inc. All rights reserved.
//

#import "KeyCheckHelper.h"
//#import "OptionManager.h"
//#import "Language.h"
//#import "Commons-Apple/DeviceHelper.h"
//#import "OptionManager.h"
#import "Params.h"
#import "PlatformHelper.h"
#import "StringHelper.h"
//#import "SmrtGuardAppDelegate.h"

@implementation KeyCheckHelper

@synthesize receivedDataString, expireDate, remoteKey, delegate;

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(void) doKeyCheck
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //[params setObject:[AppDelegate shared].deviceUDID forKey:@"deviceId"];
    [params setObject:@"BFVER"                   forKey:@"productCode"];
    
    NSMutableString *url = nil;
    //NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"%@/licenseKeyCheck.jsp", [[OptionManager sharedInstance] getSecureURL]];
    [url appendParams:params];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
	NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (urlConnection != nil)
	{
		receivedData = [[NSMutableData alloc] init];
	}
    
}


#pragma mark -
#pragma mark NSURLConnection

-(void) connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
	[receivedData setLength:0];
}

-(void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
	[receivedData appendData:data];
}

-(void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    
    [delegate keyCheckDone:NO];
}

-(void) connectionDidFinishLoading:(NSURLConnection*)connection
{
    if ([receivedData length] > 0)
    {
        receivedDataString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSLog(@"LicenseKeyCheckHelper receivedDataString=%@", receivedDataString);
        
        NSArray *separatedResult = [receivedDataString componentsSeparatedByString:@","];    
        
        if ([separatedResult count] == 2)
        {
            const double expireTime = [[separatedResult objectAtIndex:0] doubleValue] / 1000.0;
            expireDate = [NSDate dateWithTimeIntervalSince1970:expireTime];
            remoteKey = [[NSString alloc] initWithString:[separatedResult objectAtIndex:1]];
            
            NSLog(@"LicenseKeyCheckHelper expireDate=%@", expireDate);
            NSLog(@"LicenseKeyCheckHelper remoteKey=%@", remoteKey);
        }        
    }    
    
    
    [delegate keyCheckDone:YES];
}

@end
