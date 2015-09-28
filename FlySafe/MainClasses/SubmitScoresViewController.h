//
//  SubmitScoresViewController.h
//  SnailRun
//
//  Created by Gal Blank on 7/1/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommManager.h"

@protocol SubmitScoresDelegate <NSObject>
@optional
-(void)unload;
@end


@interface SubmitScoresViewController : UIViewController<UITextFieldDelegate,CommunicationManagerDelegate>
{
    NSString *score;
    CGFloat animatedDistance;
    
    id<SubmitScoresDelegate> __unsafe_unretained submitDelegate;
}

@property(nonatomic,retain)NSString *score;

-(void)finishedPostingData:(NSString*)result;

@property (nonatomic, unsafe_unretained) id<SubmitScoresDelegate> submitDelegate;

@end
