//
//  GameOverViewController.h
//  SnailRun
//
//  Created by Gal Blank on 7/3/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmitScoresViewController.h"


@protocol GameOverDelegate <NSObject>
@optional
-(void)unload;
@end



@interface GameOverViewController : UIViewController<SubmitScoresDelegate>
{
    NSString *distance;
    UINavigationController *aNavController;
    
    id<GameOverDelegate> __unsafe_unretained overDelegate;
}

@property(nonatomic,retain)NSString *distance;

@property (nonatomic, unsafe_unretained) id<GameOverDelegate> overDelegate;


@end
