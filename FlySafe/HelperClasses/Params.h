//
//  Params.h
//  SmrtGuard
//
//  Created by Haemish Graham on 11/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Params : NSObject 
{
	NSString *baseURL;
	NSString *cryptoKey;
	NSMutableString *plainText;
}
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *cryptoKey;
@property (nonatomic, strong) NSMutableString *plainText;


-(id) initWithURL:(NSString*)a_baseURL  andCryptoKey:(NSString*)a_cryptoKey;
-(void) add:(NSString*)a_key stringValue:(NSString*)a_value;
-(void) add:(NSString*)a_key intValue:(int)a_value;
-(void) add:(NSString*)a_key unsignedIntValue:(unsigned int)a_value;

-(NSString*)getURL;
@end
