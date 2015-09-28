//
//  Params.m
//  SmrtGuard
//
//  Created by Haemish Graham on 11/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Params.h"
#import "CryptoHelper.h"
#import "StringHelper.h"


@implementation Params
@synthesize baseURL;
@synthesize cryptoKey;
@synthesize plainText;


-(void) add:(NSString*)a_key stringValue:(NSString*)a_value
{
	[plainText appendFormat:@"&%@=%@", a_key, [a_value urlEncode]];
}

-(void) add:(NSString*)a_key intValue:(int)a_value
{
	[plainText appendFormat:@"&%@=%d", a_key, a_value];
}

-(void) add:(NSString*)a_key unsignedIntValue:(unsigned int)a_value
{
	[plainText appendFormat:@"&%@=%u", a_key, a_value];
}



-(NSString*) getURL
{
	// KILL NSLog(@"params=%@", plainText);
	NSString *cipherText = [CryptoHelper encrypt:plainText key:cryptoKey];
	return [NSString stringWithFormat:@"%@&params=%@", baseURL, [cipherText urlEncode]];
}


#pragma mark -
#pragma mark Memory Management
-(id) initWithURL:(NSString*)a_baseURL andCryptoKey:(NSString*)a_cryptoKey
{
	if (self = [super init])
	{
		self.baseURL = a_baseURL;
		self.cryptoKey = a_cryptoKey;
		
		NSMutableString *newString = [[NSMutableString alloc] init];
		self.plainText = newString;
	}
	return self;
}

@end
