//
//  WebViewViewController.h
//  SnailRun
//
//  Created by Gal Blank on 7/1/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewViewController : UIViewController
{
    UIWebView *helpView;
    NSString *url;
}

@property(nonatomic,strong)NSString *url;
@end
