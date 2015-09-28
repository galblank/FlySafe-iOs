//
//  ProgressScene.h
//  FlySafe
//
//  Created by Gal Blank on 7/29/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol ProgressSceneDelegate <NSObject>
@optional
-(void)finishedAnimation;
@end


@interface ProgressScene : SKScene
{
    BOOL contentCreated;
    SKSpriteNode *imageNode;
    
    id<ProgressSceneDelegate> __unsafe_unretained sceneDelegate;
}

@property (nonatomic, unsafe_unretained) id<ProgressSceneDelegate> sceneDelegate;


-(void)movePlaneToPoint:(CGPoint)point;

@end
