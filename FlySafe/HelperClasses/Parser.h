//
//  Parser.h
//  First App
//
//  Created by Natalie Blank on 23/08/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Parser : NSObject {

}


+ (Parser *)sharedInstance;
-(NSMutableArray*)parseRequests:(NSString*)stringtoparse;
-(NSMutableArray*)parseData:(NSString*)stringtoparse;
-(NSMutableArray*)extractStores:(NSArray*)jsonarray;
-(NSMutableArray*)extractOrders:(NSArray*)jsonarray;
-(NSMutableArray*)extractItems:(NSArray*)jsonarray;
-(NSMutableArray*)extractArrayFromJSONString:(NSString*)jsonString;
-(NSMutableArray*)extractData:(NSString*)jsonString :(NSString*)category;
-(NSMutableDictionary *)parseProfile:(NSString*)data;
-(UIImage *)getImageForItem:(NSString*)code;
-(NSMutableArray *)parseImages:(NSString*)data;
-(NSMutableArray*)crosswordsList:(NSString*)data;
-(NSMutableDictionary*)searchResults:(NSString*)data;
-(NSMutableDictionary*)authorsFromMirroredLibRu:(NSString*)data;
-(NSMutableDictionary*)authors:(NSString*)data;
-(NSMutableArray*)parseAutocompleteResults:(NSString*)data;
-(NSMutableDictionary*)parseGooglePlacesDetails:(NSString*)data;
@end
