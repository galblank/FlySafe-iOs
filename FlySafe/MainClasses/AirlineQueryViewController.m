//
//  AirlineQueryViewController.m
//  FlySafe
//
//  Created by Gal Blank on 7/24/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "AirlineQueryViewController.h"
#import "AirlineModel.h"
#import "Regexkitlite.h"
#import "AirlineViewController.h"
#import "AppDelegate.h"

@interface AirlineQueryViewController ()

@end

@implementation AirlineQueryViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Fly Safe", nil)];
    
    airlinesArray = [[NSMutableArray alloc] init];
    searchArray = [[NSMutableArray alloc] init];
    NSError *error;
    NSString *alldata = [NSString stringWithContentsOfURL:[[NSURL alloc] initWithString:@"http://galblank.com:8080/flysafe/getdata"] encoding:NSUTF8StringEncoding error:&error];
    
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
    NSMutableDictionary * flights = [jsonParser objectWithString:alldata];
    NSMutableArray *allairlines = [flights objectForKey:@"data"];
    //"Aeroflot Russian Airlines",\N,"SU","AFL","AEROFLOT","Russia","Y"
    for(NSMutableDictionary *oneairline in allairlines){
        AirlineModel *airline = [[AirlineModel alloc] init];
        airline.name = [oneairline objectForKey:@"airline"];
        airline.country = [oneairline objectForKey:@"country"];
        airline.officialName = [oneairline objectForKey:@"airline"];
        airline.beganOperation = [oneairline objectForKey:@"operationstart"];
        airline.lastCrash = [oneairline objectForKey:@"lastcrash"];
        airline.fleetAgeAVG = [oneairline objectForKey:@"ageoffleet"];
        airline.fatalAccidents10Years = [oneairline objectForKey:@"last10years"];
        airline.fatalAccidents20Years = [oneairline objectForKey:@"last20years"];
        airline.rating = [oneairline objectForKey:@"rating"];
        airline.comments = [oneairline objectForKey:@"comments"];
        [airlinesArray addObject:airline];
        [searchArray addObject:airline.officialName];
    }
    
    acTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    acTableView.delegate = self;
    acTableView.dataSource = self;
    acTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    acTableView.separatorColor = [UIColor lightGrayColor];
    [acTableView setBackgroundView:nil];
    [acTableView setBackgroundView:[[UIView alloc] init]];
    acTableView.backgroundColor = [UIColor clearColor];
    
    // Setup our list view to autoresizing in case we decide to support autorotation along the other UViewControllers
    acTableView.autoresizesSubviews = YES;
    acTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    
    
    UISearchBar *searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 5, self.view.frame.size.width - 80,30)];
    searchbar.backgroundColor = [UIColor whiteColor];
    searchbar.placeholder = NSLocalizedString(@"Search Airline", nil);
    searchbar.barTintColor = [UIColor redColor];
    [searchbar setDelegate:self];
    
    
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchbar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    acTableView.tableHeaderView = searchbar;
    [self.view addSubview:acTableView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(searchResults != nil && searchResults.count > 0){
        return searchResults.count;
    }
    return airlinesArray.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AirlineModel *oneResult = nil;
    if(searchResults != nil && searchResults.count > 0){
        NSString *airline = [searchResults objectAtIndex:indexPath.row];
        for(AirlineModel *modelAirline in airlinesArray){
            if([modelAirline.officialName rangeOfString:airline].location != NSNotFound){
                oneResult = modelAirline;
                break;
            }
        }
    }
    else{
        oneResult = [airlinesArray objectAtIndex:indexPath.row];
    }
    
   /* if(oneResult.rating == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"At this time, there is no information associtated with this airline\r\nPlease check back later or submit an airline info from the Menu options", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
        [alert show];
        return;
    }*/
    AirlineViewController *airLine = [[AirlineViewController alloc] init];
    [airLine setSelectedAirline:oneResult];
    [self.navigationController pushViewController:airLine animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return(indexPath);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kSSAutoCompleteCell = @"kSSAutoCompleteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSSAutoCompleteCell];
    
    if(cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kSSAutoCompleteCell];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setTextColor:greenFontcolor]; //[UIColor colorWithRed:54.0 / 255.0 green:154.0 / 255.0 blue:238.0 / 255.0 alpha:0.9]];
        [cell.textLabel setFont:[UIFont fontWithName:@"Baskerville" size:14.0]];
        cell.accessoryType             = UITableViewCellAccessoryNone;
        cell.textLabel.numberOfLines   = 0;
        cell.selectionStyle            = UITableViewCellSelectionStyleGray;
        cell.backgroundColor           = [UIColor whiteColor];
        
        [cell.detailTextLabel setTextColor:greenFontcolor]; //[UIColor colorWithRed:54.0 / 255.0 green:154.0 / 255.0 blue:238.0 / 255.0 alpha:0.9]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Baskerville" size:12.0]];
    }
    
    cell.accessoryView = nil;
    AirlineModel *airline = [airlinesArray objectAtIndex:indexPath.row];
    if(searchResults != nil && searchResults.count > 0){
        
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = @"";
    }
    else{
        [cell.textLabel setText:airline.officialName];
        if(airline.rating != nil){
            UIImage *image = [UIImage imageNamed:@"icon40"];
            UIImageView *accessory = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            accessory.image = image;
            cell.accessoryView = accessory;
        }
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / %@",airline.name,airline.country];
    }
    return(cell);
}

- (UITableViewCell*)tableViewCellWithReuseIdentifier:(NSString*)identifier
{
    
    // Allocate a table view cell.
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    return(cell);
}



- (CGFloat)tableView:(UITableView *)tableView heightFoFooterInSection:(NSInteger)section {
        return 0.01f;
}



-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if(searchResults){
        [searchResults removeAllObjects];
    }
    

        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
        searchResults  = [NSMutableArray arrayWithArray: [searchArray filteredArrayUsingPredicate:resultPredicate]];
        [acTableView reloadData];

    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   
    
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchResults removeAllObjects];
    [acTableView reloadData];
}

@end
