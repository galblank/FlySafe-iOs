//
//  AirlineViewController.m
//  FlySafe
//
//  Created by Gal Blank on 7/25/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "AirlineViewController.h"
#import "ProgressScene.h"


@interface AirlineViewController ()

@end

@implementation AirlineViewController

@synthesize selectedAirline;

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
    [self setTitle:NSLocalizedString(@"Airline Safety Meter", nil)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *imageNAME = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?@"clouds_ipad":@"clouds_iphone";
    UIImage *image = [UIImage imageNamed:imageNAME];
    spriteView = [[SKView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, image.size.height)];
    spriteView.backgroundColor = [UIColor clearColor];
    spriteView.showsDrawCount = NO;
    spriteView.showsNodeCount = NO;
    spriteView.showsFPS = NO;
    
    [self.view addSubview:spriteView];
    
    ProgressScene *progresc = [[ProgressScene alloc] initWithSize:CGSizeMake(spriteView.frame.size.width, spriteView.frame.size.height)];
    progresc.backgroundColor = [UIColor whiteColor];
    [progresc setSceneDelegate:self];
    [spriteView presentScene:progresc];
    
    progress = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 60, self.view.frame.size.width - 20, 50)];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 10.0f);
    progress.progressTintColor = [UIColor redColor];
    progress.progressViewStyle = UIProgressViewStyleBar;
    UIImage *track = [[UIImage imageNamed:@"trackimage"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
    [progress setTrackImage:track];
    progress.progressImage = [UIImage imageNamed:@"progressimage"];
    progress.transform = transform;
//    [self.view addSubview:progress];
    
    
    
    airlineTable = [[UITableView alloc] initWithFrame:CGRectMake(10, spriteView.frame.origin.y + spriteView.frame.size.height, self.view.frame.size.width - 20, self.view.frame.size.height - (spriteView.frame.origin.y + spriteView.frame.size.height)) style:UITableViewStylePlain];
    airlineTable.delegate = self;
    airlineTable.dataSource = self;
    airlineTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    airlineTable.separatorColor = [UIColor lightGrayColor];
    [airlineTable setBackgroundView:nil];
    [airlineTable setBackgroundView:[[UIView alloc] init]];
    airlineTable.backgroundColor = [UIColor clearColor];
    
    // Setup our list view to autoresizing in case we decide to support autorotation along the other UViewControllers
    airlineTable.autoresizesSubviews = YES;
    airlineTable.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    airlineTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:airlineTable];
    CGFloat jumpBy = (self.view.frame.size.width - 20.0) / 5;
    CGFloat middle = jumpBy / 2;
    if([selectedAirline.rating floatValue] >= RATING_RED_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_RED_HIGH){
        [progresc movePlaneToPoint:CGPointMake(middle, 30)];
    }
    else if([selectedAirline.rating floatValue] >= RATING_ORANGE_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_ORANGE_HIGH){
        [progresc movePlaneToPoint:CGPointMake(2 * jumpBy  - middle, 30)];
    }
    else if([selectedAirline.rating floatValue] >= RATING_YELLOW_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_YELLOW_TOP){
        [progresc movePlaneToPoint:CGPointMake(3 * jumpBy  - middle, 30)];
    }
    else if([selectedAirline.rating floatValue] >= RATING_SALAD_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_SALAD_TOP){
        [progresc movePlaneToPoint:CGPointMake(4 * jumpBy  - middle, 30)];
    }
    else if([selectedAirline.rating floatValue] >= RATING_GREEN_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_GREEN_TOP){
        [progresc movePlaneToPoint:CGPointMake(5 * jumpBy  - middle, 30)];
    }
    
    //[self rotateNeedle];
}

-(void)finishedAnimation
{
    NSLog(@"Finished Animation");
    
    UILabel *finishedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 60)];
    finishedLabel.font = [UIFont fontWithName:@"Baskerville-Bold" size:30];
    finishedLabel.textColor = [UIColor whiteColor];
    finishedLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:finishedLabel];
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[finishedLabel]];
    [animator addBehavior:gravityBehavior];
    
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[finishedLabel]];
    
    [collisionBehavior addBoundaryWithIdentifier:@"bottom" fromPoint:CGPointMake(0, spriteView.frame.size.height - 80) toPoint:CGPointMake(self.view.frame.size.width, spriteView.frame.size.height - 80)];
    
    [animator addBehavior:collisionBehavior];
    
    
    UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[finishedLabel]];
    elasticityBehavior.elasticity = 0.7f;
    [animator addBehavior:elasticityBehavior];
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    if([selectedAirline.rating floatValue] >= RATING_RED_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_RED_HIGH){
        finishedLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Take the train", nil) attributes:underlineAttribute];
    }
    else if([selectedAirline.rating floatValue] >= RATING_ORANGE_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_ORANGE_HIGH){
        finishedLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Below average!", nil) attributes:underlineAttribute];
    }
    else if([selectedAirline.rating floatValue] >= RATING_YELLOW_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_YELLOW_TOP){
        finishedLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"You should be fine!", nil) attributes:underlineAttribute];
    }
    else if([selectedAirline.rating floatValue] >= RATING_SALAD_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_SALAD_TOP){
        finishedLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Pretty good.", nil) attributes:underlineAttribute];
    }
    else if([selectedAirline.rating floatValue] >= RATING_GREEN_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_GREEN_TOP){
        finishedLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"As safe as it gets!", nil) attributes:underlineAttribute];
    }
    
    
}

-(void) rotateNeedle
{
    if(selectedAirline.rating != nil){
        if([selectedAirline.rating floatValue] >= RATING_RED_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_RED_HIGH){
       //     progress.progressTintColor = [UIColor redColor];
        }
        else if([selectedAirline.rating floatValue] >= RATING_ORANGE_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_ORANGE_HIGH){
       //     progress.progressTintColor = [UIColor orangeColor];
        }
        else if([selectedAirline.rating floatValue] >= RATING_YELLOW_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_YELLOW_TOP){
      //      progress.progressTintColor = [UIColor colorWithRed:242.0 / 255.0 green:238.0 / 255.0 blue:5.0 / 255.0 alpha:1.0];
        }
        else if([selectedAirline.rating floatValue] >= RATING_SALAD_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_SALAD_TOP){
       //     progress.progressTintColor = [UIColor colorWithRed:158.0 / 255.0 green:212.0 / 255.0 blue:83.0 / 255.0 alpha:1.0];
        }
        else if([selectedAirline.rating floatValue] >= RATING_GREEN_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_GREEN_TOP){
       //     progress.progressTintColor = [UIColor colorWithRed:0 / 255.0 green:227.0 / 255.0 blue:19.0 / 255.0 alpha:1.0];
        }

        [progress setProgress:[selectedAirline.rating floatValue] animated:YES];
    }
    else{
        [progress setProgress:0.8 animated:YES];
    }
    
    
    
    /*[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0f];
    
     [needleImageView setTransform: CGAffineTransformMakeRotation((M_PI / 180) * [selectedAirline.rating intValue])];
    [UIView commitAnimations];*/
    
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
    return 6;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSSAutoCompleteCell];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setTextColor:[UIColor blackColor]]; //[UIColor colorWithRed:54.0 / 255.0 green:154.0 / 255.0 blue:238.0 / 255.0 alpha:0.9]];
        [cell.textLabel setFont:[UIFont fontWithName:@"Baskerville" size:16.0]];
        cell.accessoryType             = UITableViewCellAccessoryNone;
        cell.textLabel.numberOfLines   = 0;
        cell.selectionStyle            = UITableViewCellSelectionStyleGray;
        cell.backgroundColor           = [UIColor whiteColor];
        
        [cell.detailTextLabel setTextColor:[UIColor greenColor]];
        //[UIColor colorWithRed:54.0 / 255.0 green:154.0 / 255.0 blue:238.0 / 255.0 alpha:0.9]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Baskerville" size:12.0]];
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = selectedAirline.officialName;
            if(selectedAirline.comments != nil && [selectedAirline.comments isEqualToString:@"No Comments"] == NO){
                cell.detailTextLabel.text = selectedAirline.comments;
            }
            else{
               cell.detailTextLabel.text = @"";
            }
            break;
            
        case 1:
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Last Crash:", nil),selectedAirline.lastCrash != nil?selectedAirline.lastCrash:NSLocalizedString(@"Never", nil)];
            break;
            
            
            
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Number of crashes in last 10 years:", nil),selectedAirline.fatalAccidents10Years!= nil?selectedAirline.fatalAccidents10Years:NSLocalizedString(@"Never", nil)];
            break;
            
            
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Number of crashes in last 20 years:", nil),selectedAirline.fatalAccidents20Years!= nil?selectedAirline.fatalAccidents20Years:NSLocalizedString(@"Never", nil)];
            break;
            
        case 4:
            if(selectedAirline.fleetAgeAVG == nil){
                cell.textLabel.text = NSLocalizedString(@"Average Plane Age: Uknown",nil);
            }
            else{
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"Average Plane Age:", nil),selectedAirline.fleetAgeAVG,NSLocalizedString(@"years", nil)];
            }
            break;
        case 5:
            if(selectedAirline.country == nil){
                cell.textLabel.text = NSLocalizedString(@"Country: Uknown",nil);
            }
            else{
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Country:", nil),selectedAirline.country];
            }
            break;
        default:
            break;
    }
    
    return(cell);
}

- (UITableViewCell*)tableViewCellWithReuseIdentifier:(NSString*)identifier
{
    
    // Allocate a table view cell.
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    return(cell);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectZero];
    return header;
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *resultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, view.frame.size.width - 20, view.frame.size.height - 20)];
    resultsLabel.font = [UIFont fontWithName:@"Baskerville-Bold" size:16];
    resultsLabel.textAlignment = NSTextAlignmentCenter;
    resultsLabel.numberOfLines = 0;
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};

    
    if(selectedAirline.rating != nil){
        if([selectedAirline.rating floatValue] >= RATING_RED_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_RED_HIGH){
            resultsLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Take the train", nil) attributes:underlineAttribute];
        }
        else if([selectedAirline.rating floatValue] >= RATING_ORANGE_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_ORANGE_HIGH){
            resultsLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Below average!", nil) attributes:underlineAttribute];
        }
        else if([selectedAirline.rating floatValue] >= RATING_YELLOW_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_YELLOW_TOP){
            resultsLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"You should be fine!", nil) attributes:underlineAttribute];
        }
        else if([selectedAirline.rating floatValue] >= RATING_SALAD_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_SALAD_TOP){
            resultsLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Pretty good.", nil) attributes:underlineAttribute];
        }
        else if([selectedAirline.rating floatValue] >= RATING_GREEN_BOTTOM &&  [selectedAirline.rating floatValue] <= RATING_GREEN_TOP){
            resultsLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"As safe as it gets!", nil) attributes:underlineAttribute];
        }
    }
    else{
        resultsLabel.text = NSLocalizedString(@"Uknown Results", nil);
    }
    
    [view addSubview:resultsLabel];
    return view;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return [[UIView alloc] initWithFrame:CGRectZero];

}

- (CGFloat)tableView:(UITableView *)tableView heightFoFooterInSection:(NSInteger)section {
    return 0.01f;
}

@end
