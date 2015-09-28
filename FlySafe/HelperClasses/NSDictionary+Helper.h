//
//  NSDictionary+Helper.h
//  SnapSecure
//
//  Created by Haemish Graham on 16/11/2012.
//  Copyright (c) 2013 SnapOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Helper)

-(NSString*) queryString;

-(NSString*) stringForKey:(NSString*) key;
-(NSNumber*) numberForKey:(NSString*) key;
-(NSInteger) integerForKey:(NSString*)key;
-(double)    doubleForKey:(NSString*)key;

-(void) safeSetObject:(id)value forKey:(NSString*)key;

@end
