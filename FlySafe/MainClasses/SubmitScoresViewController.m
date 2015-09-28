//
//  SubmitScoresViewController.m
//  SnailRun
//
//  Created by Gal Blank on 7/1/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "SubmitScoresViewController.h"
#import "AppDelegate.h"

@interface SubmitScoresViewController ()

@end

@implementation SubmitScoresViewController

@synthesize submitDelegate;

@synthesize score;

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
    [self setTitle:@"Submit Your Score"];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width - 20, 100)];
    [label setFont:[UIFont fontWithName:@"Baskerville" size:50]];
    [label setTextColor:greenFontcolor];
    [label setBackgroundColor:[UIColor clearColor]];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.view addSubview:label];
    label.text = score;
    
    
    UITextField *emailField = [[UITextField alloc] initWithFrame:CGRectMake(20, label.frame.origin.y + label.frame.size.height + 10, self.view.frame.size.width - 40, 40)];
    emailField.placeholder = @"Enter E-Mail";
    emailField.textColor = greenFontcolor;
    emailField.textAlignment = NSTextAlignmentCenter;
    emailField.borderStyle = UITextBorderStyleLine;
    emailField.font = [UIFont fontWithName:@"Baskerville" size:18];
    emailField.returnKeyType = UIReturnKeySend;
    emailField.keyboardAppearance = UIKeyboardAppearanceAlert;
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    emailField.delegate = self;
    
    [self.view addSubview:emailField];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(unloadSelf)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)unloadSelf
{
    if(submitDelegate != nil && [submitDelegate respondsToSelector:@selector(unload)])
    {
        [submitDelegate unload];
    }
}

- (BOOL)isEmailTextFieldValid:(NSString*)emailAddress
{
    BOOL isValidEmailAddress = YES;
    
    
    // Look for spaces in email.
    NSRange range = [emailAddress rangeOfString:@" "];
    
    if (range.location == NSNotFound)
    {
        // Look if the user has more than 1 of the '@' then show error.
        NSUInteger numberOfOccurrences = [[emailAddress componentsSeparatedByString:@"@"] count] - 1;
        
        if(numberOfOccurrences > 1)
        {
            
            isValidEmailAddress = NO;
        }
        else
        {
            NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
            NSString *emailRegex = stricterFilterString;
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            isValidEmailAddress = [emailTest evaluateWithObject:emailAddress];
        }
    }
    else
    {
        isValidEmailAddress = NO;
    }
    
    
    // Look for consecutive dots in email.
    NSRange rangeDots = [emailAddress rangeOfString:@".."];
    
    if (rangeDots.location != NSNotFound)
    {
        isValidEmailAddress = NO;
    }
    
    
    return(isValidEmailAddress);
}

-(void)finishedPostingData:(NSString*)result
{
    NSLog(@"Submitted scores");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:result message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [self unloadSelf];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if([self isEmailTextFieldValid:textField.text] == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter a valid email address" message:nil delegate:nil cancelButtonTitle:@"Ok"  otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    [textField resignFirstResponder];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:score forKey:@"score"];
    [params setObject:textField.text forKey:@"email"];
    [[CommManager sharedInstance] sendData:@"updatescores" params:params withDelegate:self];
    return TRUE;
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
