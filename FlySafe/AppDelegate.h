//
//  AppDelegate.h
//  iLibRu
//
//  Created by Gal Blank on 5/6/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitingScreenView.h"
#import "DDMenuController.h"
#import "MainViewController.h"
#import "AirlineQueryViewController.h"

#define yellowBGcolor  [UIColor whiteColor]//[UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:17.0 / 255.0 alpha:1.0]

#define greenFontcolor [UIColor colorWithRed:35.0 / 255.0 green:130.0 / 255.0 blue:232.0 / 255.0 alpha:1.0]

#define globalFont [UIFont fontWithName:@"Baskerville" size:16.0]


#define IS_USER_AUTHENTICATED_KEY       @"IS_USER_AUTHENTICATED_KEY"
#define IS_PROFILE_SET_KEY              @"IS_PROFILE_SET_KEY"
#define IS_USING_METRIC_SYSTEM_KEY      @"IS_USING_METRIC_SYSTEM_KEY"
#define USERNAME_KEY                    @"USERNAME_KEY"
#define USEREMAIL_KEY                   @"USEREMAIL_KEY"
#define USERBIRTHDAY_KEY                @"USERBIRTHDAY_KEY"
#define USERHEIGHT_KEY                  @"USERHEIGHT_KEY"
#define USERAGE_KEY                     @"USERAGE_KEY"
#define USERWEIGHT_KEY                  @"USERWEIGHT_KEY"
#define USERGENDER_KEY                  @"USERGENDER_KEY"
#define USERdeviceUDID_KEY              @"USERdeviceUDID_KEY"
#define USERsessionToken_KEY            @"USERsessionToken_KEY"

static NSString * const kClientId = @"178666631824-9pds8m5h8osrcgolp392gm1bn1l2n7hb.apps.googleusercontent.com";

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *window;
	UIView * activityView;
	WaitingScreenView * mWaitingScreen;
    AirlineQueryViewController *mainView;
    DDMenuController *rootController;
    UINavigationController *mainNavigationController;
    
    
    BOOL isUserAuthenticated;
    BOOL isProfileSet;
    BOOL isUsingMetricSystem;
    NSString * userName;
    NSString * userEmail;
    NSString *userBirthday;
    NSString *userAge;
    NSString *userHeight;
    NSString *userWeight;
    NSString *deviceUDID;
    NSString *userGender;
    NSString *sessionToken;
    
    
}
@property (nonatomic, retain) AirlineQueryViewController *mainView;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIView * activityView;
@property (nonatomic, retain) WaitingScreenView * mWaitingScreen;
@property (nonatomic, retain) UINavigationController *mainNavigationController;
@property(nonatomic,retain)DDMenuController *rootController;


@property (nonatomic)BOOL isUserAuthenticated;
@property (nonatomic)BOOL isProfileSet;
@property (nonatomic)BOOL isUsingMetricSystem;
@property (nonatomic, retain)NSString * userName;
@property (nonatomic, retain)NSString * userEmail;
@property (nonatomic, retain)NSString *userBirthday;
@property (nonatomic, retain)NSString *userHeight;
@property (nonatomic, retain)NSString *userAge;
@property (nonatomic, retain)NSString *userWeight;
@property (nonatomic, retain)NSString *deviceUDID;
@property (nonatomic, retain)NSString *sessionToken;
@property (nonatomic, retain)NSString *userGender;


+ (AppDelegate*)shared;

-(void)showActivityViewer:(NSString*)caption :(CGRect)frame;
-(void)hideActivityViewer;
-(void)showSplash;
-(void)switchControllers:(UIViewController*)controller;

-(void)saveUserDefaults;
-(void)readUserDefaults;

-(void)showmainview;
@end
