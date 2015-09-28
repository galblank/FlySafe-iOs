//
//  AirlineQueryViewController.h
//  FlySafe
//
//  Created by Gal Blank on 7/24/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirlineQueryViewController : UIViewController<UISearchDisplayDelegate,UISearchBarDelegate>
{
    UITableView *acTableView;
    NSMutableArray *airlinesArray;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *searchResults;
    NSMutableArray *searchArray;
}
@end
