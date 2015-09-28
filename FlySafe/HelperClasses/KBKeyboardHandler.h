//
//  KBKeyboardHandler.h
//  SmrtGuard
//
//  Created by Haemish Graham on 28/11/2012.
//  Copyright (c) 2012 Smrtphone Solutions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KBKeyboardHandlerDelegate;

@interface KBKeyboardHandler : NSObject

- (id)init;

@property(nonatomic, weak) id<KBKeyboardHandlerDelegate> delegate;
@property(nonatomic) CGRect frame;

@end
