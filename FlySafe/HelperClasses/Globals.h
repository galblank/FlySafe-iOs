//
//  Globals.h
//  First App
//
//  Created by Gal Blank on 9/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define GLOBAL_VERSION @"0.1.6"

#define GLOBAL_INFOTEXT @"© 2008-2011 Gal Blank All rights reserved."

#define GLOBAL_IPLOCATIONDBKEY @"7658cfea9270c2bfa0ba5fcd437a2756136350433c2542b4e21ba276e57edb27"

#define FEMALE 1
#define MALE 2

#define DOCSFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface Globals : NSObject {
	NSString *username;
	NSString *password;
	UIColor *textColor;
	NSString * userCountry;
	NSString *userCity;
	NSString *deviceToken;
	NSMutableDictionary *errorsMap;
	NSMutableDictionary *globalMeetingDetails;
    NSMutableDictionary *mainmenuLinks;
    NSString *currentUrlPath;
    NSMutableDictionary *savedBooks;
    NSMutableArray * urlPathArray;
    NSMutableArray * siteMirrorsArray;
    int nSavedBooksCount;
    BOOL bReadingSavedBook;
    BOOL bRunningOniPad;
    NSMutableDictionary * countryList;
}


@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString * userCountry;
@property (nonatomic, retain) NSString * userCity;
@property (nonatomic, retain) NSString *deviceToken;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) NSMutableDictionary *errorsMap;
@property (nonatomic, retain) NSMutableDictionary *globalMeetingDetails;
@property (nonatomic, retain) NSMutableDictionary *mainmenuLinks;
@property (nonatomic, retain) NSString *currentUrlPath;
@property (nonatomic, retain) NSMutableDictionary *savedBooks;
@property (nonatomic, retain) NSMutableArray * urlPathArray;
@property (nonatomic, retain)NSMutableArray * siteMirrorsArray;
@property (nonatomic, retain)NSMutableDictionary *countryList;
@property (nonatomic)int nSavedBooksCount;
@property (nonatomic)BOOL bReadingSavedBook;
@property (nonatomic)BOOL bRunningOniPad;


-(CGFloat)getWidth;
-(CGFloat)getHeight;
-(void)setActiveCountries;
- (NSString *) stripTags:(NSString *)str;
-(NSMutableArray*)splitBookToPages:(NSString*)text;
-(NSMutableArray*) getLocationFromAddressString:(NSString*) addressStr;

+ (Globals *)sharedInstance;
@end
