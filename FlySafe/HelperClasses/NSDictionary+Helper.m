//
//  NSDictionary+Helper.m
//  SnapSecure
//
//  Created by Haemish Graham on 16/11/2012.
//  Copyright (c) 2013 SnapOne. All rights reserved.
//

#import "NSDictionary+Helper.h"
#import "NSString+Helper.h"

@implementation NSDictionary (Helper)

-(NSString*) queryString
{
	NSMutableArray *params = [NSMutableArray arrayWithCapacity:[self count]];
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop)
    {
		[params addObject:[NSString stringWithFormat:@"%@=%@", [key urlEncode], [[object description] urlEncode]]];
	}];
    
	return [params componentsJoinedByString:@"&"];
}

-(NSString*) stringForKey:(NSString*)key
{
    id value = [self objectForKey:key];
    return ([value isKindOfClass:[NSString class]] ? value : nil);
}

-(NSNumber*) numberForKey:(NSString*)key
{
    id value = [self objectForKey:key];
    return ([value isKindOfClass:[NSNumber class]] ? value : [NSNumber numberWithInt:0]);
}

-(NSInteger) integerForKey:(NSString*)key
{
    id value = [self objectForKey:key];
    return ([value isKindOfClass:[NSNumber class]] ? [value integerValue] : 0);
}

-(double) doubleForKey:(NSString*)key
{
    id value = [self objectForKey:key];
    return ([value isKindOfClass:[NSNumber class]] ? [value doubleForKey:key] : 0);
}

-(void) safeSetObject:(id)value forKey:(NSString*)key
{
    if (value) [self setValue:value forKey:key];
}


@end
