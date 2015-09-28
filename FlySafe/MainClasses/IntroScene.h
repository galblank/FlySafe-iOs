//
//  IntroScene.h
//  IQ180
//
//  Created by Gal Blank on 6/2/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol IntroSceneDelegate <NSObject>
@optional
-(void)finishedGame:(NSString*)score;
@end


@interface IntroScene : SKScene
{
    BOOL contentCreated;
    BOOL bRunning;
    NSTimeInterval rotationTime;
    CGFloat rotationSpeed;
    NSMutableArray *actions;
    NSTimer *stopTimer;
    
    CGFloat moveSpeed;
    
    UIView *bgView;
    
    int screensRan;
    
    UILabel *distanceOne;
    UILabel *distanceTwo;
    UILabel *distanceThree;
    UILabel *distanceFour;
    
    BOOL isMoving;
    int numberofSwipes;
    
    id<IntroSceneDelegate> __unsafe_unretained introDelegate;
    
    NSString *distance;
    
    BOOL isGameOver;
    
    UIProgressView *progressBar;
    
    
    NSTimer *progressTimer;
    
}

@property BOOL contentCreated;
@property (nonatomic, unsafe_unretained) id<IntroSceneDelegate> introDelegate;
@property (nonatomic)BOOL isGameOver;
@end
