//
//  MenuViewController.m
//  iLibRu
//
//  Created by Gal Blank on 5/15/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "SBJSON.h"
#import "WebViewViewController.h"


@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize aMainViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    // Create the table view controller.
    // Allocate the table view controller.
    self.menuTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.menuTableView.delegate        = self;
    self.menuTableView.dataSource      = self;
    self.menuTableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
    self.menuTableView.separatorColor  = greenFontcolor;
    self.menuTableView.tag = 0;
    self.menuTableView.scrollEnabled = NO;
    // NOTE: These next two lines are required to fix the issue of the
    // background view not updating it's color properly for a grouped table view.
    // [self.menuTableView setBackgroundView:nil];
    // [self.menuTableView setBackgroundView:[[UIView alloc] init]];
    self.menuTableView.backgroundColor = [UIColor whiteColor];
    
    // Setup our list view to autoresizing in case we decide to support autorotation along the other UViewControllers
    self.menuTableView.autoresizesSubviews = YES;
    self.menuTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    //self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.menuTableView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(tableView.tag == 0){
        return 200.0;
    }
    
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];

    return footer;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    
    CGFloat sectionHeight = 50.0;
    
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect viewRect = CGRectMake(0.0, 0.0, screenWidth, sectionHeight);
    
    bgView.frame = viewRect;
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, bgView.bounds.size.height - 25.0, bgView.bounds.size.width - 15.0, 25.0)];
    
    titleLabel.numberOfLines = 1;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = greenFontcolor;
    titleLabel.font = [UIFont fontWithName:@"Baskerville-Bold" size:18];
    
   
    titleLabel.text = @"MENU";
    
    [bgView addSubview:titleLabel];
    
    return(bgView);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 4;

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHeight = 40;
    
    return(cellHeight);
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return(indexPath);
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kSSMenuStandardCellID          = @"kSSMenuStandardCellID";
    
    
    UITableViewCell *cell = nil;
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:kSSMenuStandardCellID];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSSMenuStandardCellID];
        cell.accessoryType             = UITableViewCellAccessoryNone;
        cell.textLabel.font            = [UIFont fontWithName:@"Baskerville" size:17.0];
        cell.textLabel.textColor       = [UIColor colorWithRed:199.0 / 255.0 green:31.0 / 255.0 blue:12.0 / 255.0 alpha:1.0];
        cell.textLabel.numberOfLines   = 1;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.font      = [UIFont fontWithName:@"Baskerville" size:17.0];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.selectionStyle            = UITableViewCellSelectionStyleGray;
        cell.accessoryView             = nil;
    }
    

    
  
        if(indexPath.row == 0)
        {
            cell.textLabel.text = NSLocalizedString(@"Main", nil);
            cell.imageView.image = [UIImage imageNamed:@"connect.png"];
        }
        
        if(indexPath.row == 1)
        {
            cell.textLabel.text = NSLocalizedString(@"Share", nil);
            cell.imageView.image = [UIImage imageNamed:@"share.png"];
        }
        if(indexPath.row == 2)
        {
            cell.textLabel.text = NSLocalizedString(@"Help", nil);
            cell.imageView.image = [UIImage imageNamed:@"share.png"];
        }
        if(indexPath.row == 3)
        {
            cell.textLabel.text = NSLocalizedString(@"Submit Airline Data & Corrections", nil);
            cell.imageView.image = [UIImage imageNamed:@"share.png"];
        }
        return(cell);
}



- (UITableViewCell*)tableViewCellWithReuseIdentifier:(NSString*)identifier
{
    
    // Allocate a table view cell.
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    return(cell);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Turn off the highlighting.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  
        if(indexPath.row == 0)
        {
            if(aMainView == nil){
                aMainView = [[UINavigationController alloc] initWithRootViewController:self.aMainViewController];
                aMainView.navigationBar.barTintColor = yellowBGcolor;
                aMainView.navigationBar.translucent = NO;
                aMainView.navigationBar.tintColor = greenFontcolor;
            }
            [[AppDelegate shared] switchControllers:aMainView];
        }
        else if(indexPath.row == 1){
            [self shareApp];
        }
        else if(indexPath.row == 2){
            [self showHelp];
        }
        else if(indexPath.row == 3){
            [self submitNewInfo];
        }
}

-(void)showHelp
{
     [[CommManager sharedInstance] sendData:@"gethelp" params:nil withDelegate:self];
    
    
}

-(void)finishedPostingData:(NSString*)result
{
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSMutableArray *urlslist = [NSMutableArray arrayWithArray:[jsonParser objectWithString:result]];
    // For this response, the top level JSON object is an array.
    NSMutableDictionary *aboutOne = [urlslist objectAtIndex:0];
    NSString *url = [aboutOne objectForKey:@"abouturl"];
    WebViewViewController *aUIWalkthroughViewController = [[WebViewViewController alloc] init];
    aUIWalkthroughViewController.url = url;
    UINavigationController *aDeviceSetupNavController = [[UINavigationController alloc] initWithRootViewController:aUIWalkthroughViewController];
    NSArray *viewControllers = aDeviceSetupNavController.viewControllers;
    aDeviceSetupNavController.navigationBar.barTintColor = yellowBGcolor;
    aDeviceSetupNavController.navigationBar.translucent = NO;
    aDeviceSetupNavController.navigationBar.tintColor = greenFontcolor;
    
    [[AppDelegate shared] switchControllers:aDeviceSetupNavController];
    
}


//////////MAIL/////////////
-(void)submitNewInfo
{
    if (![MFMailComposeViewController canSendMail])
        // The device can send email.
    {
        return;
    }
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self; // &lt;- very important step if you want feedbacks on what the user did with your email sheet
    [picker setToRecipients:@[@"galblank@gmail.com"]];
    [picker setSubject:[NSString stringWithFormat:@"Airline info and corrections"]];
    //NSMutableArray *recepients = [[NSMutableArray alloc] initWithObjects:@"info@inteltrain.com",nil];
    //[picker setToRecipients:recepients];
    // Fill out the email body text
    NSString *iTunesLink = @"<a href=\"https://itunes.apple.com/us/app/flysafe/id903016055?ls=1&mt=8\">Download FlySafe!</a>"; // replate it with yours
    
    UIImage *emailImage = [UIImage imageNamed:@"icon40.png"];
    //Convert the image into data
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(emailImage)];
    
    [picker addAttachmentData:imageData mimeType:@"image/png" fileName:@"Icon"];
    //Create a base64 string representation of the data using NSData+Base64
    //NSString *base64String = [imageData base64EncodedString];
    //Add the encoded string to the emailBody string
    //Don't forget the "<b>" tags are required, the "<p>" tags are optional
    //NSString *ilibRuImage = [NSString stringWithFormat:@"<img src='data:image/png;base64,%@'>",base64String];
    //You could repeat here with more text or images, otherwise
    NSString *emailBody = [NSString stringWithFormat:@"Please add as many details as you can about the airline<br />Airline:<br />Country:<br />Incidents Data:<br />"];
    
    [picker setMessageBody:emailBody isHTML:YES]; // depends. Mostly YES, unless you want to send it as plain text (boring)
    picker.navigationBar.barTintColor = yellowBGcolor;
    picker.navigationBar.translucent = NO;
    picker.navigationBar.tintColor = greenFontcolor;
    //picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

-(void)shareApp
{
    if (![MFMailComposeViewController canSendMail])
        // The device can send email.
    {
        return;
    }
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self; // &lt;- very important step if you want feedbacks on what the user did with your email sheet
    
    [picker setSubject:[NSString stringWithFormat:@"Make sure you flye safely!"]];
    //NSMutableArray *recepients = [[NSMutableArray alloc] initWithObjects:@"info@inteltrain.com",nil];
    //[picker setToRecipients:recepients];
    // Fill out the email body text
    NSString *iTunesLink = @"<a href=\"https://itunes.apple.com/us/app/flysafe/id903016055?ls=1&mt=8\">Download FlySafe!</a>"; // replate it with yours
    
    UIImage *emailImage = [UIImage imageNamed:@"icon40.png"];
    //Convert the image into data
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(emailImage)];
    
    [picker addAttachmentData:imageData mimeType:@"image/png" fileName:@"Icon"];
    //Create a base64 string representation of the data using NSData+Base64
    //NSString *base64String = [imageData base64EncodedString];
    //Add the encoded string to the emailBody string
    //Don't forget the "<b>" tags are required, the "<p>" tags are optional
    //NSString *ilibRuImage = [NSString stringWithFormat:@"<img src='data:image/png;base64,%@'>",base64String];
    //You could repeat here with more text or images, otherwise
    NSString *emailBody = [NSString stringWithFormat:@"<p>FlySafe tells you how safe is the airline you use, so it might just save your life<br>\
                           %@<br />\
                           </font>",iTunesLink];
    
    [picker setMessageBody:emailBody isHTML:YES]; // depends. Mostly YES, unless you want to send it as plain text (boring)
    picker.navigationBar.barTintColor = yellowBGcolor;
    picker.navigationBar.translucent = NO;
    picker.navigationBar.tintColor = greenFontcolor;
    //picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }
            
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
