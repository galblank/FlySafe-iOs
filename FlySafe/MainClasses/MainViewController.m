//
//  MainViewController.m
//  iLibRu
//
//  Created by Gal Blank on 5/15/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "SppedScene.h"
#import "Parser.h"
#import "NSString+Helper.h"
#import "AutoCompleteResult.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Fly Safe!"];
    wizardViewsArray = [[NSMutableArray alloc] init];
    postReqParams = [[NSMutableDictionary alloc] init];
    currentTrip = [[TripModel alloc] init];
    currentTrip.adults = [NSNumber numberWithInt:1];
    currentTrip.children = [NSNumber numberWithInt:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    currentTrip.departureDate = [dateFormatter stringFromDate:[NSDate  date]];
    
    UIView *fromView = [[UIView alloc] initWithFrame:CGRectMake(20,10,self.view.frame.size.width - 40,self.view.frame.size.height - 120)];
    [fromView setBackgroundColor:[UIColor whiteColor]];
    fromView.layer.cornerRadius = 10.0;
    fromView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    fromView.layer.borderWidth = 1.0;
    [self.view addSubview:fromView];
    [wizardViewsArray addObject:fromView];
    
    UITextField *inputField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, fromView.frame.size.width - 20, 40)];
    inputField.font = globalFont;
    inputField.placeholder = NSLocalizedString(@"Flying from", nil);
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    inputField.delegate = self;
    inputField.tag = INPUTFIELD_FROM;
    inputField.textAlignment = NSTextAlignmentCenter;
    inputField.textColor = greenFontcolor;
    inputField.keyboardAppearance = UIKeyboardAppearanceLight;
    [fromView addSubview:inputField];
    [wizardViewsArray addObject:inputField];
    
    UITextField *inputToField = [[UITextField alloc] initWithFrame:CGRectMake(10, inputField.frame.origin.y + inputField.frame.size.height + 5, fromView.frame.size.width - 20, 40)];
    inputToField.font = globalFont;
    inputToField.placeholder = NSLocalizedString(@"Flying to", nil);
    inputToField.borderStyle = UITextBorderStyleRoundedRect;
    inputToField.delegate = self;
    inputToField.tag = INPUTFIELD_TO;
    inputToField.textAlignment = NSTextAlignmentCenter;
    inputToField.textColor = greenFontcolor;
    inputToField.keyboardAppearance = UIKeyboardAppearanceLight;
    [fromView addSubview:inputToField];
    [wizardViewsArray addObject:inputToField];
    
    
    adultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, inputToField.frame.origin.y + inputToField.frame.size.height + 10,fromView.frame.size.width - 20, 20)];
    adultsLabel.textColor = greenFontcolor;
    adultsLabel.font = globalFont;
    adultsLabel.backgroundColor = [UIColor clearColor];
    adultsLabel.textAlignment = NSTextAlignmentCenter;
    adultsLabel.text = NSLocalizedString(@"Adults: ", nil);
    adultsLabel.text = [adultsLabel.text stringByAppendingFormat:@"1"];
    [fromView addSubview:adultsLabel];
    [wizardViewsArray addObject:adultsLabel];
    
    UISlider *adultsSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, adultsLabel.frame.origin.y + adultsLabel.frame.size.height,fromView.frame.size.width - 20, 20)];
    adultsSlider.minimumTrackTintColor = greenFontcolor;
    adultsSlider.maximumTrackTintColor = [UIColor greenColor];
    adultsSlider.minimumValue = 1.0;
    adultsSlider.tag = ADULT_SLIDER;
    adultsSlider.maximumValue = 10.0;
    [adultsSlider addTarget:self action:@selector(updateSlider:) forControlEvents:UIControlEventValueChanged];
    [fromView addSubview:adultsSlider];
    [wizardViewsArray addObject:adultsSlider];
    
    childrenLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, adultsSlider.frame.origin.y + adultsSlider.frame.size.height + 10,fromView.frame.size.width - 20, 20)];
    childrenLabel.textColor = greenFontcolor;
    childrenLabel.font = globalFont;
    childrenLabel.backgroundColor = [UIColor clearColor];
    childrenLabel.textAlignment = NSTextAlignmentCenter;
    childrenLabel.text = NSLocalizedString(@"Children: ", nil);
    childrenLabel.text = [childrenLabel.text stringByAppendingFormat:@"0"];
    [fromView addSubview:childrenLabel];
    [wizardViewsArray addObject:childrenLabel];
    
    UISlider *childrenSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, childrenLabel.frame.origin.y + childrenLabel.frame.size.height,fromView.frame.size.width - 20, 20)];
    childrenSlider.minimumTrackTintColor = greenFontcolor;
    childrenSlider.maximumTrackTintColor = [UIColor greenColor];
    childrenSlider.minimumValue = 0.0;
    childrenSlider.tag = CHILDREN_SLIDER;
    childrenSlider.maximumValue = 10.0;
    [childrenSlider addTarget:self action:@selector(updateSlider:) forControlEvents:UIControlEventValueChanged];
    [fromView addSubview:childrenSlider];
    [wizardViewsArray addObject:childrenSlider];
    
    departureDate = [[UILabel alloc] initWithFrame:CGRectMake(10, childrenSlider.frame.origin.y + childrenSlider.frame.size.height + 10,fromView.frame.size.width - 20, 40)];
    departureDate.textColor = greenFontcolor;
    departureDate.userInteractionEnabled  = YES;
    departureDate.font = globalFont;
    departureDate.backgroundColor = [UIColor clearColor];
    departureDate.textAlignment = NSTextAlignmentLeft;
    departureDate.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Departure:", nil),currentTrip.departureDate];
    [fromView addSubview:departureDate];
    [wizardViewsArray addObject:departureDate];
    
    UIButton *buttonDepDate = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonDepDate setBackgroundImage:[UIImage imageNamed:@"cal"] forState:UIControlStateNormal];
    buttonDepDate.tag = PICKER_DEPARTURE;
    [buttonDepDate setFrame:CGRectMake(departureDate.frame.size.width - [UIImage imageNamed:@"cal"].size.width, 10, [UIImage imageNamed:@"cal"].size.width,  [UIImage imageNamed:@"cal"].size.height)];
    [buttonDepDate addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
    [departureDate addSubview:buttonDepDate];
    
    returnDate = [[UILabel alloc] initWithFrame:CGRectMake(10, departureDate.frame.origin.y + departureDate.frame.size.height + 10,fromView.frame.size.width - 20, 40)];
    returnDate.textColor = greenFontcolor;
    returnDate.userInteractionEnabled  = YES;
    returnDate.font = globalFont;
    returnDate.backgroundColor = [UIColor clearColor];
    returnDate.textAlignment = NSTextAlignmentLeft;
    returnDate.text = NSLocalizedString(@"Return:", nil);
    [fromView addSubview:returnDate];
    [wizardViewsArray addObject:returnDate];
    
    UIButton *buttonRetDate = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRetDate setBackgroundImage:[UIImage imageNamed:@"cal"] forState:UIControlStateNormal];
    buttonRetDate.tag = PICKER_RETURN;
    [buttonRetDate setFrame:CGRectMake(departureDate.frame.size.width - [UIImage imageNamed:@"cal"].size.width, 10, [UIImage imageNamed:@"cal"].size.width,  [UIImage imageNamed:@"cal"].size.height)];
    [buttonRetDate addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
    [returnDate addSubview:buttonRetDate];
    
    
    
    
    UIButton *buttonFind = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonFind setFrame:CGRectMake(10,fromView.frame.size.height - 50, fromView.frame.size.width - 20, 50)];
    buttonFind.titleLabel.font = globalFont;
    buttonFind.titleLabel.textColor = greenFontcolor;
    [buttonFind setTitle:NSLocalizedString(@"Find", nil) forState:UIControlStateNormal];
    [buttonFind addTarget:self action:@selector(findFlights) forControlEvents:UIControlEventTouchUpInside];
    [fromView addSubview:buttonFind];
    [wizardViewsArray addObject:buttonFind];
    
    
    
    acTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, inputToField.frame.origin.y + inputToField.frame.size.height, fromView.frame.size.width - 20,fromView.frame.size.height - inputToField.frame.origin.y + inputToField.frame.size.height) style:UITableViewStylePlain];
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
    [fromView addSubview:acTableView];
    [fromView sendSubviewToBack:acTableView];
    
    
    
    [self startWizard];
    
}

-(void)datePicked:(UIDatePicker *)picker{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"%@",[dateFormatter stringFromDate:picker.date]);
    
    if(picker.tag == PICKER_DEPARTURE){
        currentTrip.departureDate = [dateFormatter stringFromDate:picker.date];
        departureDate.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Departure: ", nil),currentTrip.departureDate];
    }
    else if(picker.tag == PICKER_RETURN){
        currentTrip.returnDate = [dateFormatter stringFromDate:picker.date];
        returnDate.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Return: ", nil),currentTrip.returnDate];
    }
}

-(void)chooseDate:(UIButton*)button
{
    
    UIView *view = [wizardViewsArray objectAtIndex:0];
    
    // Add the picker
    pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height,view.frame.size.width, 300)];
    pickerView.backgroundColor = [UIColor whiteColor];
    
    

    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.frame = CGRectMake(pickerView.frame.size.width / 2 - 25, 5, 50, 20);
    doneButton.titleLabel.font            = globalFont;
    [doneButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(hidePicker) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:doneButton];
    
    
    UIDatePicker *pickerViewStartFence = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,doneButton.frame.origin.y  + doneButton.frame.size.height,view.frame.size.width, 200)];
    pickerViewStartFence.backgroundColor = [UIColor whiteColor];
    pickerViewStartFence.datePickerMode = UIDatePickerModeDate;
    pickerViewStartFence.tag = button.tag;
    [pickerViewStartFence addTarget:self action:@selector(datePicked:) forControlEvents:UIControlEventValueChanged];
    [pickerView addSubview:pickerViewStartFence];

    [view addSubview:pickerView];
    
    [UIView animateWithDuration:0.25 animations:^{
        pickerView.frame = CGRectMake(0, departureDate.frame.origin.y, view.frame.size.width, pickerView.frame.size.height);
        
    }];
    
    
}

-(void)hidePicker
{
    [UIView animateWithDuration:0.25 animations:^{
        pickerView.frame = CGRectMake(0, self.view.frame.size.height,pickerView.frame.size.width, 300);
        
    }];
}

-(void)updateSlider:(UISlider*)slider
{
    if(slider.tag == ADULT_SLIDER){
        currentTrip.adults = [NSNumber numberWithInt:slider.value];
        adultsLabel.text = NSLocalizedString(@"Adults: ", nil);
        adultsLabel.text = [adultsLabel.text stringByAppendingFormat:@"%d",[currentTrip.adults intValue]];
    }
    else if(slider.tag == CHILDREN_SLIDER){
        currentTrip.children = [NSNumber numberWithInt:slider.value];
        childrenLabel.text = NSLocalizedString(@"Children: ", nil);
        childrenLabel.text = [childrenLabel.text stringByAppendingFormat:@"%d",[currentTrip.children intValue]];
    }
}

-(void)unload
{

}

-(void)startWizard
{
    UIView *view = [wizardViewsArray objectAtIndex:0];
    
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[view]];
    [animator addBehavior:gravityBehavior];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[view]];
    
    [collisionBehavior addBoundaryWithIdentifier:@"bottom" fromPoint:CGPointMake(0, self.view.frame.size.height - 80) toPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height - 80)];
    
    [animator addBehavior:collisionBehavior];
    
    
    UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
    elasticityBehavior.elasticity = 0.7f;
    [animator addBehavior:elasticityBehavior];
    
    /*
    view.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        view.hidden = NO;
        view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];*/
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)sendAsyncNowNewIsFinished:(ASIHTTPRequest*)theRequest
{
    NSData *myResponseData = [theRequest responseData];
    NSString *results = [[NSString alloc] initWithData:myResponseData encoding:NSUTF8StringEncoding];
    autocompleteResults = [[Parser sharedInstance] parseAutocompleteResults:results];
    
    UIView *fromView = [wizardViewsArray objectAtIndex:0];
    [fromView bringSubviewToFront:acTableView];
    
    
    [acTableView reloadData];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    currentTextField = textField;
    if(textField.text.length > 2){
        //https://maps.googleapis.com/maps/api/place/textsearch/json?query=jcc&sensor=true&key=AIzaSyDnubl66O4G0WbBJmi99BKh4JjS1MAahOE
        //NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?types=airport&input=%@&key=AIzaSyAXAjpfd_khLc4vypfqJqNJKAw0qkjatl4",[textField.text urlEncode]];
        NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&key=AIzaSyAXAjpfd_khLc4vypfqJqNJKAw0qkjatl4",[textField.text urlEncode]];
        [[CommManager sharedInstance] sendAsyncGoogle:url withDelegate:self];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    currentTextField = textField;
    [textField resignFirstResponder];
    
    
    if(currentTextField.tag == INPUTFIELD_FROM){
        currentTrip.from = currentTextField.text;
    }
    else if(currentTextField.tag == INPUTFIELD_TO){
        currentTrip.to = currentTextField.text;
    }

    return TRUE;
}

-(void)findFlights
{
    /*
     {
     "request": {
     "passengers": {
     "adultCount": 1,
     "childCount": 1
     },
     "slice": [
     {
     "origin": "OGG",
     "destination": "NCE",
     "date": "2014-09-19",
     "permittedDepartureTime":
     {
     "kind": "qpxexpress#timeOfDayRange",
     "earliestTime": "22:00",
     "latestTime": "23:00"
     }
     },
     {
     "origin": "NCE",
     "destination": "OGG",
     "date": "2014-09-28",
     "permittedDepartureTime":
     {
     "kind": "qpxexpress#timeOfDayRange",
     "earliestTime": "05:00",
     "latestTime": "12:00"
     }
     }
     ],
     "maxPrice": "USD5400",
     "solutions": 10
     }
     }
     */
    
    
    /*
     {
     "request": {
     "passengers": {
     "adultCount": 1
     },
     "slice": [
     {
     "origin": "BOS",
     "destination": "LAX",
     "date": "YYYY-MM-DD"
     },
     {
     "origin": "LAX",
     "destination": "BOS",
     "date": "YYYY-MM-DD"
     }
     ]
     }
     }
     */
    
    NSMutableDictionary *request = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *passengers = [[NSMutableDictionary alloc] init];
    [passengers setObject:currentTrip.adults        forKey:@"adultCount"];
    [passengers setObject:currentTrip.children      forKey:@"childCount"];
    [postReqParams setObject:passengers forKey:@"passengers"];
    
    
    NSMutableArray *slice = [[NSMutableArray alloc] init];
    NSMutableDictionary *sliceFrom = [[NSMutableDictionary alloc] init];
    [sliceFrom setObject:currentTrip.from forKey:@"origin"];
    [sliceFrom setObject:currentTrip.to forKey:@"destination"];
    [sliceFrom setObject:currentTrip.departureDate forKey:@"date"];
    
    
    [slice addObject:sliceFrom];
    
    if(currentTrip.returnDate != nil && currentTrip.returnDate.length > 0){
        NSMutableDictionary *sliceBack = [[NSMutableDictionary alloc] init];
        [sliceBack setObject:currentTrip.to forKey:@"origin"];
        [sliceBack setObject:currentTrip.from forKey:@"destination"];
        [sliceBack setObject:currentTrip.returnDate forKey:@"date"];
        [slice addObject:sliceBack];
    }
    
    [postReqParams setObject:slice forKey:@"slice"];
    
    [request setObject:postReqParams forKey:@"request"];
    
    [[CommManager sharedInstance] postAsyncGoogle:@"https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyAXAjpfd_khLc4vypfqJqNJKAw0qkjatl4" withParams:request withDelegate:self];
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
    
    return autocompleteResults.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AutoCompleteResult *oneResult = [autocompleteResults objectAtIndex:indexPath.row];
    currentTextField.text = oneResult.description;
    [currentTextField resignFirstResponder];
    [autocompleteResults removeAllObjects];
    
    UIView *fromView = [wizardViewsArray objectAtIndex:0];
    [fromView sendSubviewToBack:acTableView];
    
    if(currentTextField.tag == INPUTFIELD_FROM){
        currentTrip.from = currentTextField.text;
        //https://maps.googleapis.com/maps/api/place/nearbysearch/json?
    }
    else if(currentTextField.tag == INPUTFIELD_TO){
        currentTrip.to = currentTextField.text;
    }
    
    
    [tableView reloadData];
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
    
    
    AutoCompleteResult *oneResult = [autocompleteResults objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = oneResult.address;
    [cell.textLabel setText:oneResult.description];
    
    return(cell);
}

- (UITableViewCell*)tableViewCellWithReuseIdentifier:(NSString*)identifier
{
    
    // Allocate a table view cell.
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    return(cell);
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(autocompleteResults == nil || autocompleteResults.count == 0){
        return 0.01f;
    }
    return 40;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if(autocompleteResults == nil || autocompleteResults.count == 0){
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UIImage *googleLogo = [UIImage imageNamed:@"powered-by-google-on-white"];
    UIImageView *imageGoogle = [[UIImageView alloc] initWithFrame:CGRectMake(0,5, googleLogo.size.width, googleLogo.size.height)];
    imageGoogle.image = googleLogo;
    [view addSubview:imageGoogle];
    return view;
}




-(void)finishedPostingData:(NSString*)result
{
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
    NSMutableDictionary * flights = [jsonParser objectWithString:result];
    
    NSLog(@"Flights INFO : %@",flights);
}
@end
