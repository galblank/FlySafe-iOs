    //
//  Parser.m
//  First App
//
//  Created by Natalie Blank on 23/08/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Parser.h"
#import "RegexKitLite.h"
#import "Globals.h"
#import "NSString+SBJSON.h"
#import "AutoCompleteResult.h"

static Parser *sharedSampleSingletonDelegate = nil;

@implementation Parser

+ (Parser *)sharedInstance {
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


-(NSMutableArray*)getArrayFromJsonForKey:(NSString*)json :(NSString*)key
{
	NSDictionary *jsonData = [[NSDictionary alloc] initWithDictionary:[json JSONValue]];
	NSMutableArray *retArray = [jsonData objectForKey:key];
	return retArray;
}

-(NSString*)getValueFromJsonForKey:(NSString*)json :(NSString*)key
{
	
	NSDictionary *jsonData = [[NSDictionary alloc] initWithDictionary:[json JSONValue]];
	NSString *retVal = [jsonData objectForKey:key];
	return retVal;
}

-(UIImage *)getImageForItem:(NSString*)code
{
	NSString *strUrl = [NSString stringWithFormat:@"%@%@.png",@"sdfsF",code];
	NSURL *url=[NSURL URLWithString:strUrl];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *imageuser = [[UIImage alloc] initWithData:data];
	return imageuser;
}




-(NSMutableArray*)extractArrayFromJSONString:(NSString*)jsonString
{
	NSMutableArray *newarr = [[NSMutableArray alloc] init];
	NSString *mainCategory = [jsonString stringByMatching:@"\\{\"(.*?)\":" capture:1];
	newarr = [self extractData:jsonString :mainCategory];
	return newarr;

	
}




-(NSMutableArray*)parseAutocompleteResults:(NSString*)data
{
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    NSMutableDictionary* theObject=[data JSONValue];
    NSString *status = [theObject objectForKey:@"status"];
    if([status caseInsensitiveCompare:@"OK"] != NSOrderedSame){
        NSLog(@"AutoComplete Failed");
        return nil;
    }
    
    
    NSMutableArray *results = [theObject objectForKey:@"predictions"];
    for(int i=0;i<results.count;i++){
        NSMutableDictionary *oneresult = [results objectAtIndex:i];
        AutoCompleteResult *autocompleteres = [[AutoCompleteResult alloc] init];
        autocompleteres.description = [oneresult objectForKey:@"description"];
        autocompleteres.placeId = [oneresult objectForKey:@"place_id"];
        [retArray addObject:autocompleteres];
    }
    
    return retArray;
}

@end
