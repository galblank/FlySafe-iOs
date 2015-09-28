//
//  CommonKeyChain.h
//  SnapSecure
//
//  Created by Gal Blank on 3/18/14.
//  Copyright (c) 2014 SnapOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonKeyChain : NSObject
{
    
}
+ (CommonKeyChain *)sharedInstance;
-(NSString*)getDeviceUDIDFromCommonKeychain;
- (void)initializeKeychain;
- (void)clearKeyChain;
@end
