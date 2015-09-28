//
//  AppDelegate.m
//  iLibRu
//
//  Created by Gal Blank on 5/6/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "DataHandler.h"
#import "Globals.h"
#import "CommonKeyChain.h"
@implementation AppDelegate


AppDelegate *shared = nil;

@synthesize mainView,window,rootController,mainNavigationController,isUserAuthenticated,isProfileSet,userName,userEmail,userBirthday,isUsingMetricSystem,userHeight,userAge,userWeight,deviceUDID,userGender;

+ (AppDelegate*)shared
{
	return shared;
}


- (id)init
{
    self = [super init];
    
    shared = self;
    
    return (self);
}


-(void)saveUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if(standardUserDefaults)
    {
        [standardUserDefaults setBool:self.isUserAuthenticated      forKey:IS_USER_AUTHENTICATED_KEY];
        [standardUserDefaults setBool:self.isProfileSet             forKey:IS_PROFILE_SET_KEY];
        [standardUserDefaults setBool:self.isUsingMetricSystem      forKey:IS_USING_METRIC_SYSTEM_KEY];
        [standardUserDefaults setObject:self.userEmail              forKey:USEREMAIL_KEY];
        [standardUserDefaults setObject:self.userName               forKey:USERNAME_KEY];
        [standardUserDefaults setObject:self.userBirthday           forKey:USERBIRTHDAY_KEY];
        [standardUserDefaults setObject:self.userHeight             forKey:USERHEIGHT_KEY];
        [standardUserDefaults setObject:self.userAge                forKey:USERAGE_KEY];
        [standardUserDefaults setObject:self.userWeight             forKey:USERWEIGHT_KEY];
        [standardUserDefaults setObject:self.deviceUDID             forKey:USERdeviceUDID_KEY];
        [standardUserDefaults setObject:self.sessionToken           forKey:USERsessionToken_KEY];
        [standardUserDefaults setObject:self.userGender             forKey:USERGENDER_KEY];
        [standardUserDefaults synchronize];
    }
    
}

-(void)readUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    self.isUserAuthenticated            = [standardUserDefaults boolForKey:IS_USER_AUTHENTICATED_KEY];
    self.isProfileSet                   = [standardUserDefaults boolForKey:IS_PROFILE_SET_KEY];
    self.isUsingMetricSystem            = [standardUserDefaults boolForKey:IS_USING_METRIC_SYSTEM_KEY];
    self.userEmail                      = [standardUserDefaults objectForKey:USEREMAIL_KEY];
    self.userName                       = [standardUserDefaults objectForKey:USERNAME_KEY];
    self.userBirthday                   = [standardUserDefaults objectForKey:USERBIRTHDAY_KEY];
    self.userHeight                     = [standardUserDefaults objectForKey:USERHEIGHT_KEY];
    self.userAge                        = [standardUserDefaults objectForKey:USERAGE_KEY];
    self.userWeight                     = [standardUserDefaults objectForKey:USERWEIGHT_KEY];
    self.deviceUDID                     = [standardUserDefaults objectForKey:USERdeviceUDID_KEY];
    self.sessionToken                   = [standardUserDefaults objectForKey:USERsessionToken_KEY];
    self.userGender                     = [standardUserDefaults objectForKey:USERGENDER_KEY];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self readUserDefaults];
    [[CommonKeyChain sharedInstance] initializeKeychain];
    [self initMainViewController];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)initMainViewController
{
    
  /*  for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    */
    // Create the Snap Secure View Controller.
    self.mainView = [[AirlineQueryViewController alloc] init];
    self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mainView];
    self.mainNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.mainNavigationController.navigationBar.translucent = NO;
    self.mainNavigationController.navigationBar.barTintColor = yellowBGcolor;
    self.mainNavigationController.navigationBar.tintColor = greenFontcolor;
    
    rootController = [[DDMenuController alloc] init];
    
    [self switchControllers:self.mainNavigationController];
    
    [rootController.view setNeedsLayout];
    
    // This along with the plist value will get the white text back on the status bar for iOS7.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    // Set the bottom or left view controller
    MenuViewController *myMenuController = [[MenuViewController alloc] init];
    myMenuController.aMainViewController = self.mainView;
    //self.menuViewController.view.backgroundColor = appNavBarColor;
    rootController.leftViewController = myMenuController;
    [rootController enableSlidingMenu];
    self.window.rootViewController = rootController;
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      greenFontcolor,
      NSForegroundColorAttributeName,
      yellowBGcolor,
      NSBackgroundColorAttributeName,
      [UIFont fontWithName:@"Baskerville" size:18.0],
      NSFontAttributeName,
      nil]];
    
    
    
}

-(void)showmainview{
    [rootController showRightController:YES];
}

-(void)switchControllers:(UIViewController*)controller
{

        // Manual frame adjustment to ensure the controller is put in the right place and not
        // offset by the status bar size. Force the y postition to be at 0.0.
        CGRect currentFrame = rootController.rootViewController.view.frame;
        CGRect correctFrame = CGRectMake(currentFrame.origin.x,
                                         0.0,
                                         currentFrame.size.width,
                                         currentFrame.size.height);
        
        rootController.rootViewController.view.frame = correctFrame;
    
    [rootController setRootController:controller animated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return YES;
}


-(void)showActivityViewer:(NSString*)caption :(CGRect)frame
{
    @autoreleasepool {
        if(mWaitingScreen != nil){
            if([mWaitingScreen isCurrentlyActive] == YES){
                return;
            }
            mWaitingScreen = nil;
        }
        
        UIView *topView = nil;
        if (self.window.subviews.count > 0)
        {
            topView =  [self.window.subviews objectAtIndex:0];
        }
        
        mWaitingScreen = [[WaitingScreenView alloc] initWithFrame:frame];
        //        mWaitingScreen.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [mWaitingScreen setCaption:caption];
        if (topView)
        {
            [topView addSubview:mWaitingScreen];
        }
        
        [[[mWaitingScreen subviews] objectAtIndex:0] startAnimating];
        [mWaitingScreen setIsCurrentlyActive:YES];
    }
}


-(void)hideActivityViewer
{
	if(mWaitingScreen != nil){
        [mWaitingScreen setIsCurrentlyActive:NO];
		/*NSMutableArray *views = [mWaitingScreen subviews];
         for(int i=0;i<[views count];i++){
         id  oneView = [views objectAtIndex:i];
         if([oneView isKindOfClass:[UIActivityIndicatorView class]] == YES){
         [oneView stopAnimating];
         }
         }
         //[[[mWaitingScreen subviews] objectAtIndex:0] stopAnimating];*/
		[mWaitingScreen removeFromSuperview];
		mWaitingScreen = nil;
	}
}
@end
