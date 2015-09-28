//
//  GameOverViewController.m
//  SnailRun
//
//  Created by Gal Blank on 7/3/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "GameOverViewController.h"
#import "AppDelegate.h"

@interface GameOverViewController ()

@end

@implementation GameOverViewController

@synthesize distance,overDelegate;

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

    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"grass"];
    [self.view addSubview:bgView];
    
    
    UILabel *finishedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height / 2)];
    finishedLabel.font = [UIFont fontWithName:@"Baskerville" size:40];
    finishedLabel.textColor = [UIColor whiteColor];
    finishedLabel.textAlignment = NSTextAlignmentCenter;
    finishedLabel.numberOfLines = 0;
    finishedLabel.backgroundColor = [UIColor clearColor];
    finishedLabel.text = [NSString stringWithFormat:@"RACE ENDED\r\nDISTANCE %@",self.distance];
    [self.view addSubview:finishedLabel];
    

    UIButton * submitResultsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitResultsButton.frame = CGRectMake(10, finishedLabel.frame.origin.y + finishedLabel.frame.size.height, self.view.frame.size.width - 20, 50);
    [submitResultsButton.titleLabel setFont:[UIFont fontWithName:@"Baskerville" size:30]];
    [submitResultsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitResultsButton setTitle:@"SUBMIT RESULTS" forState:UIControlStateNormal];
    [submitResultsButton addTarget:self action:@selector(submitResults) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitResultsButton];
    
    
    UIButton * newGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newGameButton.frame = CGRectMake(10, submitResultsButton.frame.origin.y + submitResultsButton.frame.size.height, self.view.frame.size.width - 20, 50);
    [newGameButton.titleLabel setFont:[UIFont fontWithName:@"Baskerville" size:30]];
    [newGameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newGameButton setTitle:@"NEW RACE" forState:UIControlStateNormal];
    [newGameButton addTarget:self action:@selector(raceAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newGameButton];
    
    NSLog(@"Game over");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)raceAgain
{
    if(self.overDelegate != nil && [self.overDelegate respondsToSelector:@selector(unload)]){
        [self.overDelegate unload];
    }
}

-(void)unload
{
    [aNavController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)submitResults
{
    SubmitScoresViewController * submit = [[SubmitScoresViewController alloc] init];
    [submit setSubmitDelegate:self];
    submit.score = self.distance;
    aNavController = [[UINavigationController alloc] initWithRootViewController:submit];
    aNavController.navigationBar.translucent = NO;
    aNavController.navigationBar.barTintColor = yellowBGcolor;
    aNavController.navigationBar.tintColor = greenFontcolor;
    
    [self.navigationController presentViewController:aNavController animated:YES completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
