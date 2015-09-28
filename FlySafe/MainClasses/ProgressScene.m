//
//  ProgressScene.m
//  FlySafe
//
//  Created by Gal Blank on 7/29/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "ProgressScene.h"

@implementation ProgressScene

@synthesize sceneDelegate;

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
    NSString *imageNAME = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?@"clouds_ipad":@"clouds_iphone";
    UIImage *image = [UIImage imageNamed:imageNAME];
    SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:imageNAME];
    sn.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    sn.name = @"BACKGROUND";
    [self addChild:sn];
    
    self.scaleMode = SKSceneScaleModeResizeFill;
    SKSpriteNode *sprite = [self newHelloNode];
    [self addChild:sprite];
    

    
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 12)];
    [bgView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:bgView];
    
    CGFloat loc = bgView.frame.size.width / 4;
    /*
    distanceOne = [[UILabel alloc] initWithFrame:CGRectMake(10 + loc * 3, 2, 50, 15)];
    distanceOne.font = [UIFont fontWithName:@"Chalkduster" size:15.0];
    distanceOne.textColor = [UIColor yellowColor];
    distanceOne.text = @"100";
    [bgView addSubview:distanceOne];
    
    
    distanceTwo = [[UILabel alloc] initWithFrame:CGRectMake(10 + loc * 2, 2, 50, 15)];
    distanceTwo.font = [UIFont fontWithName:@"Chalkduster" size:15.0];
    distanceTwo.textColor = [UIColor yellowColor];
    distanceTwo.text = @"200";
    [bgView addSubview:distanceTwo];
    
    
    distanceThree = [[UILabel alloc] initWithFrame:CGRectMake(10 + loc, 2, 50, 15)];
    distanceThree.font = [UIFont fontWithName:@"Chalkduster" size:15.0];
    distanceThree.textColor = [UIColor yellowColor];
    distanceThree.text = @"300";
    [bgView addSubview:distanceThree];
    
    
    
    distanceFour = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 50, 15)];
    distanceFour.font = [UIFont fontWithName:@"Chalkduster" size:15.0];
    distanceFour.textColor = [UIColor yellowColor];
    distanceFour.text = @"400";
    [bgView addSubview:distanceFour];
    
    
    progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width - 20, 30)];
    progressBar.progressViewStyle = UIProgressViewStyleBar;
    progressBar.progress = 0.0;
    progressBar.tintColor = [UIColor redColor];
    [self.view addSubview:progressBar];*/
}

-(void)movePlaneToPoint:(CGPoint)point
{
    SKSpriteNode *movenode = (SKSpriteNode*)[self childNodeWithName:@"plane"];
    SKAction *moveaction = [SKAction moveTo:point duration:2.0];
    SKAction *movefinished = [SKAction performSelector:@selector(finishedMoveAction) onTarget:self];
    SKAction *movesequence = [SKAction sequence:@[moveaction, movefinished]];
    [movenode runAction:movesequence withKey:@"move"];
}


-(void)finishedMoveAction{
    if(sceneDelegate && [sceneDelegate respondsToSelector:@selector(finishedAnimation)]){
        [sceneDelegate finishedAnimation];
    }
    NSLog(@"finishedMoveAction");
}

- (SKSpriteNode *)newHelloNode
{
    imageNode = [[SKSpriteNode alloc] initWithImageNamed:@"plane"];
    imageNode.name = @"plane";
    imageNode.position = CGPointMake(10,30);
    return imageNode;
}


@end
