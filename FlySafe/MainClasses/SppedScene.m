//
//  SppedScene.m
//  AnySpin
//
//  Created by Gal Blank on 6/25/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "SppedScene.h"

@implementation SppedScene


- (void)didMoveToView: (SKView *) view
{
    if (!contentCreated)
    {
        [self createSceneContents];
        contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [UIColor whiteColor];
    self.scaleMode = SKSceneScaleModeAspectFill;
    SKSpriteNode *sprite = [self newHelloNode];
    [self addChild:sprite];
}


- (SKSpriteNode *)newHelloNode
{
    SKSpriteNode *imageNode = [[SKSpriteNode alloc] initWithImageNamed:@"snail.png"];
    imageNode.name = @"speed";
    imageNode.position = CGPointMake(0,0);
    return imageNode;
}
@end
