//
//  DataHandler.h
//  First App
//
//  Created by Gal Blank on 9/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataHandler : NSObject {

}

+ (DataHandler *)sharedInstance;
- (NSString*)getSerialNumber;

@end
