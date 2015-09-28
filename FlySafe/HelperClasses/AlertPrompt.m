//
//  AlertPrompt.m
//  Prompt
//
//  Created by Jeff LaMarche on 2/26/09.

#import "AlertPrompt.h"
#import "UIImage+Resizing.h"

@implementation AlertPrompt
@synthesize textField,textField2;
@synthesize enteredText,nserror,y;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle adduserField:(BOOL)adduserField
{
	y = 0;
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:nil otherButtonTitles:nil, nil])
    //if (self = [super init])
	{
		nserror = @"";
        textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 90.0, 260.0, 25.0)]; 
        [textField setBackgroundColor:[UIColor clearColor]]; 
		[textField setBorderStyle:UITextBorderStyleRoundedRect];
		[textField setPlaceholder:@"Invitation ID"];
		textField.delegate = self;
		textField.tag = 1;
        [self addSubview:textField];
		
		if(adduserField == YES){
			[self adduserField];
		}
				
		UIImage *logoimage = [UIImage imageNamed:@"vivatinclogo.png"];
		logoimage = [UIImage imageOfSize:CGSizeMake(90, 45) fromImage:logoimage];
		UIImageView *logoview = [[UIImageView alloc] initWithImage:logoimage];
		logoview.tag = 1;
		logoview.frame = CGRectMake(180.0, 130.0, logoimage.size.width,logoimage.size.height);
		[self addSubview:logoview];
		
		errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160,160,60)];
		[errorLabel setBackgroundColor:[UIColor clearColor]];
		[errorLabel setNumberOfLines:0];
		[errorLabel setTextColor:[UIColor redColor]];
		[errorLabel setFont:[UIFont systemFontOfSize:13]];
		errorLabel.tag = 100;
		[self addSubview:errorLabel];
		
		[self addButtonWithTitle:@"Ok"];
		[self addButtonWithTitle:@"Cancel"];
		[self setMessage:message];
		[self setDelegate:delegate];
		[self setTitle:title];
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0); 
        [self setTransform:translate];
		
    }
	
	//self.frame = CGRectMake(50, 50, 200, 300);
    return self;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
	
	//return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0);
	if(textField.tag == 1){
		NSString *text = [NSString stringWithFormat:@"%@%@",textField.text,string];
		if([string length] == 0)
		{
			//delete hit
			text = [NSString stringWithFormat:@"%@",textField.text];
			if([text length] > 0){
				text = [text substringToIndex:text.length-1];
			}
		}
		
		if([text caseInsensitiveCompare:@"VOM"] == NSOrderedSame && y == 0){
			[self adduserField];
		}
		else if([text length] < 3){
			[self removeuserField];
		}
	}
	return TRUE;
	
}

-(void)removeuserField
{
	y = 0;
	if(textField2 != nil){
		[textField2 removeFromSuperview];
		textField2 = nil;
		self.frame = CGRectMake( self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 230);
		NSArray *views = [self subviews];
		for(int i=0;i<[views count];i++)
		{
			UIView *oneView = [views objectAtIndex:i];
			if(([oneView isKindOfClass:[UILabel class]] == YES && oneView.tag != 100) ||  [oneView isKindOfClass:[UITextField class]] == YES || ([oneView isKindOfClass:[UIImageView class]] == YES && oneView.tag != 1)){
				continue;
			}
			else
			{
				oneView.frame = CGRectMake( oneView.frame.origin.x, oneView.frame.origin.y - 40, oneView.frame.size.width, oneView.frame.size.height);
			}
		}
	}//if
}

-(void)adduserField
{
	y = 30;
	textField2 = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 120.0, 260.0, 25.0)]; 
	textField2.tag = 2;
	[textField2 setBackgroundColor:[UIColor clearColor]]; 
	[textField2 setBorderStyle:UITextBorderStyleRoundedRect];
	[textField2 setPlaceholder:@"Enter Username"];
	[self addSubview:textField2];
	textField2.delegate = self;
	
	self.frame = CGRectMake( self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 230 + [self y]);
	NSArray *views = [self subviews];
	for(int i=0;i<[views count];i++)
	{
		UIView *oneView = [views objectAtIndex:i];
		if(([oneView isKindOfClass:[UILabel class]] == YES && oneView.tag != 100) ||  [oneView isKindOfClass:[UITextField class]] == YES || ([oneView isKindOfClass:[UIImageView class]] == YES && oneView.tag != 1)){
			continue;
		}
		else
		{
			int n = oneView.tag;
			oneView.frame = CGRectMake( oneView.frame.origin.x, oneView.frame.origin.y + 40, oneView.frame.size.width, oneView.frame.size.height);
			
		}
	}
}



- (void)show
{
	if([nserror length] > 2){
		[errorLabel setText:nserror];
	}
    [textField becomeFirstResponder];
    [super show];
}


- (NSString *)enteredText
{
    return textField.text;
	
}

@end