//
//  PlatformHelper.h
//  SmrtGuard
//
//  Created by Haemish Graham on 17/07/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PlatformHelper : NSObject {

}

+(void) alert:(NSString*)title message:(NSString*)message;
+(NSNumber*) currentTimeMillis;	

@end
