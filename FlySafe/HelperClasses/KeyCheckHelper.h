//
//  KeyCheckHelper.h
//  SmrtGuard
//
//  Created by Joe Huang on 11-09-29.
//  Copyright (c) 2011 Smrtphone Solutions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KeyCheckHelperProtocol
-(void) keyCheckDone:(BOOL)success;
@end

@interface KeyCheckHelper : NSObject
{
    id<KeyCheckHelperProtocol> delegate;
    
    NSMutableData   *receivedData;
    NSString *receivedDataString;
    NSDate *expireDate;
    NSString *remoteKey;
}

@property (nonatomic, strong, readonly) NSString *receivedDataString;
@property (nonatomic, strong, readonly) NSDate *expireDate;
@property (nonatomic, strong, readonly) NSString *remoteKey;
@property (nonatomic, strong) id delegate;

-(void) doKeyCheck;

@end
