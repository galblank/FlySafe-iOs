//
//  KBKeyboardHandlerDelegate.h
//  SmrtGuard
//
//  Created by Haemish Graham on 28/11/2012.
//  Copyright (c) 2012 Smrtphone Solutions, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KBKeyboardHandlerDelegate

- (void)keyboardSizeChanged:(CGSize)delta;

@end