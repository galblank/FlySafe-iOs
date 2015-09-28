//
//  WebViewViewController.m
//  SnailRun
//
//  Created by Gal Blank on 7/1/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()

@end

@implementation WebViewViewController

@synthesize url;

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
    //https://docs.google.com/document/d/1K7A1KnB8MEGexY79if2CC75avXubx8oZGoMUqwGU8bc/edit?usp=sharing
    [self setTitle:@"HELP"];
        helpView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [helpView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]]];
        [self.view addSubview:helpView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
