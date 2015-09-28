//
//  IntroScene.m
//  IQ180
//
//  Created by Gal Blank on 6/2/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "IntroScene.h"
#import "RegExKitLite.h"



@implementation IntroScene

@synthesize isGameOver;
@synthesize  introDelegate;


- (void)didMoveToView: (SKView *) view
{
    if (!contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    rotationTime = 1;
    rotationSpeed = 0;
    moveSpeed = 5;
    screensRan = 0;
    numberofSwipes = 0;
    self.backgroundColor = [UIColor whiteColor];
    
    SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:@"grass"];
    sn.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    sn.name = @"BACKGROUND";
    [self addChild:sn];
    
    self.scaleMode = SKSceneScaleModeResizeFill;
    SKSpriteNode *sprite = [self newHelloNode];
    sprite.zRotation = M_PI / 4.0f;
    SKAction *rotation = [SKAction rotateByAngle:M_PI duration:7];
    SKAction* continuousRotation = [SKAction repeatActionForever:rotation];
    [sprite runAction: continuousRotation];
    [self addChild:sprite];
    
    SKSpriteNode *speedSprite = [self newSpeedNode];
    [self addChild:speedSprite];
    
    actions = [[NSMutableArray alloc] init];
    
    isGameOver = NO;
    
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 12)];
    [bgView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:bgView];
    
    CGFloat loc = bgView.frame.size.width / 4;
    
    distanceOne = [[UILabel alloc] initWithFrame:CGRectMake(10 + loc * 3, 2, 50, 15)];
    distanceOne.font = [UIFont fontWithName:@"Baskerville" size:15.0];
    distanceOne.textColor = [UIColor yellowColor];
    distanceOne.text = @"100";
    [bgView addSubview:distanceOne];
    
    
    distanceTwo = [[UILabel alloc] initWithFrame:CGRectMake(10 + loc * 2, 2, 50, 15)];
    distanceTwo.font = [UIFont fontWithName:@"Baskerville" size:15.0];
    distanceTwo.textColor = [UIColor yellowColor];
    distanceTwo.text = @"200";
    [bgView addSubview:distanceTwo];
    
    
    distanceThree = [[UILabel alloc] initWithFrame:CGRectMake(10 + loc, 2, 50, 15)];
    distanceThree.font = [UIFont fontWithName:@"Baskerville" size:15.0];
    distanceThree.textColor = [UIColor yellowColor];
    distanceThree.text = @"300";
    [bgView addSubview:distanceThree];
    
    
    
    distanceFour = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 50, 15)];
    distanceFour.font = [UIFont fontWithName:@"Baskerville" size:15.0];
    distanceFour.textColor = [UIColor yellowColor];
    distanceFour.text = @"400";
    [bgView addSubview:distanceFour];
    
    
    progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width - 20, 30)];
    progressBar.progressViewStyle = UIProgressViewStyleBar;
    progressBar.progress = 0.0;
    progressBar.tintColor = [UIColor redColor];
    [self.view addSubview:progressBar];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)finishGame{
    
    SKSpriteNode *speednode = (SKSpriteNode*)[self childNodeWithName:@"speed"];
    
    CGFloat loc = bgView.frame.size.width / 4;
    progressBar.progress = 0.0;
    distance = @"";
    isGameOver = YES;
    rotationTime = 0;
    rotationSpeed = 0;
    moveSpeed = 0;
    screensRan = 1;
    isMoving = NO;
    
    if(speednode.frame.origin.x < distanceFour.frame.origin.x){
        distance = distanceFour.text;
    }
    else if(speednode.frame.origin.x > distanceFour.frame.origin.x && speednode.frame.origin.x < distanceThree.frame.origin.x){
        distance = [NSString stringWithFormat:@"%d",(int)(distanceThree.text.intValue + (speednode.frame.origin.x - distanceFour.frame.origin.x))];
    }
    else if(speednode.frame.origin.x > distanceThree.frame.origin.x && speednode.frame.origin.x < distanceTwo.frame.origin.x){
        distance = [NSString stringWithFormat:@"%d",(int)(distanceTwo.text.intValue + (speednode.frame.origin.x - distanceThree.frame.origin.x))];
    }
    else if(speednode.frame.origin.x > distanceTwo.frame.origin.x && speednode.frame.origin.x < distanceOne.frame.origin.x){
        distance = [NSString stringWithFormat:@"%d",(int)(distanceOne.text.intValue + (speednode.frame.origin.x - distanceTwo.frame.origin.x))];
    }
    else if(speednode.frame.origin.x > distanceOne.frame.origin.x){
        distance = [NSString stringWithFormat:@"%d",(int)((distanceOne.text.intValue - 100) + (speednode.frame.origin.x - distanceOne.frame.origin.x))];
    }
    
    SKNode *cubechild = [self childNodeWithName:@"cube"];
    SKAction *slowdown = [SKAction speedTo:0 duration:0.2];
    [cubechild runAction:slowdown];
    
    NSLog(@"Game over");
    
    
    if(introDelegate != nil && [introDelegate respondsToSelector:@selector(finishedGame:)]){
        [introDelegate finishedGame:distance];
    }
    
    speednode.position = CGPointMake(self.view.frame.size.width - 20,CGRectGetMidY(self.frame));
    
}

-(void)updateProgress
{
    if(self.isGameOver == YES){
        [progressTimer invalidate];
        progressTimer = nil;
    }
    progressBar.progress -= 0.01;
    if(progressBar.progress >= 0.3 && progressBar.progress < 0.6){
        progressBar.tintColor = [UIColor orangeColor];
    }
    else if(progressBar.progress >= 0.6){
        progressBar.tintColor = [UIColor greenColor];
    }
    else if(progressBar.progress < 0.3){
        progressBar.tintColor = [UIColor redColor];
    }
}

-(void)finishedAction{
    SKNode *cubechild = [self childNodeWithName:@"cube"];
    if(actions.count > 0){
        [cubechild removeActionForKey:[actions firstObject]];
    }
    
    
}


-(void)finishedMoveAction{
    NSLog(@"finishedMoveAction moveSpeed %.2f",moveSpeed);
    if(rotationSpeed == 0){
        return;
    }

    
    
    
    SKSpriteNode *speednode = (SKSpriteNode*)[self childNodeWithName:@"speed"];
    SKSpriteNode *background = (SKSpriteNode*)[self childNodeWithName:@"BACKGROUND"];
    CGFloat movex = 0;
    if(speednode.frame.origin.x > 0){
        movex = speednode.frame.origin.x - 5;
        SKAction *moveaction = [SKAction moveToX:movex duration:moveSpeed];
        SKAction *movefinished = [SKAction performSelector:@selector(finishedMoveAction) onTarget:self];
        SKAction *movesequence = [SKAction sequence:@[moveaction, movefinished]];
        [speednode runAction:movesequence withKey:@"move"];
        
        
        SKAction *moveBGaction = [SKAction moveToX:-movex duration:moveSpeed];
        SKAction *moveBGsequence = [SKAction sequence:@[moveBGaction, movefinished]];
        // [background runAction:moveBGsequence withKey:@"move"];
    }
    else{
        screensRan += 1;
        
        distanceOne.text = [NSString stringWithFormat:@"%d",[distanceFour.text intValue] + 100];
        distanceTwo.text = [NSString stringWithFormat:@"%d",[distanceOne.text intValue] + 100];
        distanceThree.text = [NSString stringWithFormat:@"%d",[distanceTwo.text intValue] + 100];
        distanceFour.text = [NSString stringWithFormat:@"%d",[distanceThree.text intValue] + 100];
        
        movex = self.view.frame.size.width;
        SKAction *moveaction = [SKAction moveToX:movex duration:0];
        SKAction *movefinished = [SKAction performSelector:@selector(finishedMoveAction) onTarget:self];
        SKAction *movesequence = [SKAction sequence:@[moveaction, movefinished]];
        [speednode runAction:movesequence withKey:@"move"];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInNode:self];
    
    
    SKNode *node = [self nodeAtPoint:location];
    if(isGameOver == YES){
        return;
    }
    
    bRunning = YES;
    SKNode *cubechild = [self childNodeWithName:@"cube"];
    rotationSpeed = numberofSwipes + 10;
    numberofSwipes++;

    if(progressBar.progress >= 0.3 && progressBar.progress < 0.6){
        progressBar.tintColor = [UIColor orangeColor];
    }
    else if(progressBar.progress >= 0.6){
        progressBar.tintColor = [UIColor greenColor];
    }
    
    float _playtime = (rotationTime * numberofSwipes);
    NSLog(@"New Progress: %.2f",_playtime / 100.0);
    progressBar.progress = _playtime / 100;
    
    SKAction *waitAction = [SKAction waitForDuration:_playtime];
    SKAction *rotation = [SKAction speedTo:rotationSpeed duration:1.0];
    SKAction *finished = [SKAction performSelector:@selector(finishedAction) onTarget:self];
    NSString *key = [NSString stringWithFormat:@"%.0f_%.0f",rotationSpeed,rotationTime];
    SKAction *sequence = [SKAction sequence:@[rotation, waitAction, finished]];
    [actions addObject:key];
    [cubechild runAction:sequence withKey:key];
    
    if(stopTimer != nil){
        [stopTimer invalidate];
    }
    NSLog(@"Setting timer to %.2f",_playtime);
    stopTimer = [NSTimer scheduledTimerWithTimeInterval:_playtime target:self selector:@selector(finishGame) userInfo:nil repeats:NO];
    
    if(progressTimer == nil){
        progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
    
    SKSpriteNode *speednode = (SKSpriteNode*)[self childNodeWithName:@"speed"];
    CGFloat movex = 0;
    
    isMoving = YES;
    movex = speednode.frame.origin.x - 3;
    if(moveSpeed > 0.2){
        moveSpeed -= 0.01;
    }
    
    SKAction *moveaction = [SKAction moveToX:movex duration:moveSpeed];
    SKAction *movefinished = [SKAction performSelector:@selector(finishedMoveAction) onTarget:self];
    SKAction *movesequence = [SKAction sequence:@[moveaction, movefinished]];
    [speednode runAction:movesequence withKey:@"move"];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if(isGameOver == YES){
        return;
    }
    
    
    
    
    NSArray *nodes = [self nodesAtPoint:location];
    
    if ([nodes count] == 0){
        SKNode *cubechild = [self childNodeWithName:@"cube"];
        SKAction *move = [SKAction moveTo:location duration:1.0f];
        // [cubechild runAction:move];
        
        // double angle = atan2(location.y-cubechild.position.y,location.x-cubechild.position.x);
        //[cubechild runAction:[SKAction rotateToAngle:angle duration:.1]];
    } else {
        // tapped on a bug
        // [self runAction:[SKAction playSoundFileNamed:@"ladybug.wav" waitForCompletion:NO]];
    }
}

- (SKSpriteNode *)newSpeedNode
{
    
    SKSpriteNode *imageNode = [[SKSpriteNode alloc] initWithImageNamed:@"snail.png"];
    imageNode.name = @"speed";
    imageNode.position = CGPointMake(self.view.frame.size.width - 20,CGRectGetMidY(self.frame));
    return imageNode;
}

- (SKSpriteNode *)newHelloNode
{
    
    SKSpriteNode *imageNode = [[SKSpriteNode alloc] initWithImageNamed:@"globe.png"];
    imageNode.name = @"cube";
    imageNode.position = CGPointMake(CGRectGetMidX(self.frame),50);
    return imageNode;
    /*SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Baskerville"];
     helloNode.text = @"Hello, World!";
     helloNode.fontSize = 42;
     helloNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
     return helloNode;*/
}

@end
