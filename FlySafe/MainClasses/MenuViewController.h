//
//  MenuViewController.h
//  iLibRu
//
//  Created by Gal Blank on 5/15/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommManager.h"
#import "MainViewController.h"

@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CommunicationManagerDelegate>
{
    UITableView *menuTableView;
    
    UITableView *scoresTable;
    
    NSMutableArray *scoresArray;
    
    MainViewController *aMainViewController;
    
    UINavigationController *aMainView;
}

@property(nonatomic,strong)UITableView *menuTableView;
@property(nonatomic,strong)MainViewController *aMainViewController;

-(void)finishedPostingData:(NSString*)result;

@end
