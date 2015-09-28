//
//  MainViewController.h
//  iLibRu
//
//  Created by Gal Blank on 5/15/14.
//  Copyright (c) 2014 Gal Blank
// All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "IntroScene.h"
#import "SubmitScoresViewController.h"
#import "GameOverViewController.h"
#import "CommManager.h"
#import "TripModel.h"

#define INPUTFIELD_FROM 1
#define INPUTFIELD_TO 2

#define ADULT_SLIDER 1
#define CHILDREN_SLIDER 2

#define PICKER_DEPARTURE 1
#define PICKER_RETURN 2

@interface MainViewController : UIViewController<IntroSceneDelegate,GameOverDelegate,CommunicationManagerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    SKView *spriteView;
    UINavigationController *aNavController;
    UIDynamicAnimator *animator;
    NSMutableArray *wizardViewsArray;
    
    NSMutableArray *autocompleteResults;
    
    UITableView *acTableView;
    
    UITextField *currentTextField;
    
    NSMutableDictionary *postReqParams;
    
    TripModel *currentTrip;
    
    UILabel *adultsLabel;
    UILabel *childrenLabel;
    
    UILabel *departureDate;
    UILabel *returnDate;
    
    UIView *pickerView;
}

-(void)unload;
-(void)finishedGame:(NSString*)score;
-(void)finishedPostingData:(NSString*)result;
@end
