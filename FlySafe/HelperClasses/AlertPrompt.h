//
//  AlertPrompt.h
//  Prompt
//
//  Created by Jeff LaMarche on 2/26/09.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertPrompt : UIAlertView<UITextFieldDelegate>
{
    UITextField *textField;
	UITextField *textField2;
	NSString *nserror;
	UILabel *errorLabel;
	int y;
}
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UITextField *textField2;
@property (readonly) NSString *enteredText;
@property (nonatomic, retain) NSString *nserror;
@property (nonatomic) int y;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle adduserField:(BOOL)adduserField;

@end