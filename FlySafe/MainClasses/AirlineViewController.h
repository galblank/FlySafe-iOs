//
//  AirlineViewController.h
//  FlySafe
//
//  Created by Gal Blank on 7/25/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirlineModel.h"
#import <SpriteKit/SpriteKit.h>
#import "ProgressScene.h"

@interface AirlineViewController : UIViewController<ProgressSceneDelegate>
{
    AirlineModel *selectedAirline;
    UIImageView *needleImageView;
    
    UITableView *airlineTable;
    
    UIProgressView * progress;
    
    SKView *spriteView;
    
    UIDynamicAnimator *animator;
}

@property(nonatomic,retain)AirlineModel *selectedAirline;

-(void)finishedAnimation;
@end
