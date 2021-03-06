//
//  CommMamanger.m
//  TheLine
//
//  Created by Gal Blank on 5/21/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "CommManager.h"
#import "StringHelper.h"
#import "SBJSON.h"
#import "ASIFormDataRequest.h"
@implementation CommManager


@synthesize netQueue;

static CommManager *sharedSampleSingletonDelegate = nil;


+ (CommManager *)sharedInstance {
	@synchronized(self) {
		if (sharedSampleSingletonDelegate == nil) {
			[[self alloc] init]; // assignment not done here
		}
	}
	return sharedSampleSingletonDelegate;
}



+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedSampleSingletonDelegate == nil) {
			sharedSampleSingletonDelegate = [super allocWithZone:zone];
			// assignment and return on first allocation
			return sharedSampleSingletonDelegate;
		}
	}
	// on subsequent allocation attempts return nil
	return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

-(id)init
{
	if (self = [super init]) {
		
        self.netQueue = [ASINetworkQueue queue];
        [self.netQueue setMaxConcurrentOperationCount:10];
        [self.netQueue setShouldCancelAllRequestsOnFailure:NO];
        [self.netQueue setDelegate:self];
        [self.netQueue go];
	}
	return self;
}

- (NSMutableDictionary*) readPlist: (NSString*) fileName {
    NSData* plistData;
    NSString* error;
    NSPropertyListFormat format;
    id plist;
    
    NSString* localizedPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    plistData = [NSData dataWithContentsOfFile:localizedPath];
    
    plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&error];
    
    if(!plist)
    {
        NSLog(@"Error reading plist from file '%s', error = '%s' ", [localizedPath UTF8String], [error UTF8String]);
    }
    
    return plist;
    
}

-(void)postAsyncGoogle:(NSString*)htmlLink withParams:(NSMutableDictionary*)params withDelegate:(id)theDelegate
{
    awsCommDelegate = theDelegate;
    NSMutableString *baseUrl = [[NSMutableString alloc] initWithFormat:@"%@",htmlLink];
    
    responseData = [[NSMutableData alloc] init];

    NSMutableURLRequest *arequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseUrl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    [arequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [arequest setHTTPMethod:@"POST"];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *jsonPostData = [writer stringWithObject:params];
    NSLog(@"Caling :%@",baseUrl);
    NSLog(@"Post Data : %@",jsonPostData);
    NSData *payloadData = [jsonPostData dataUsingEncoding:NSUTF8StringEncoding];
    [arequest setHTTPBody:payloadData];
    
     NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:arequest delegate:self];
    
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                          forMode:NSDefaultRunLoopMode];
    [connection start];
}


-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
        //If you need the response, you can use it here
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        [awsCommDelegate finishedPostingData:responseString];
}

//https://www.googleapis.com/qpxExpress/v1/trips/search?key=


-(void)sendAsyncGoogle:(NSString*)htmlLink withDelegate:(id)theDelegate
{
    NSString * createdLink = htmlLink;
    NSURL *lurl = [NSURL URLWithString:createdLink];
    
    ASIHTTPRequest *httpRequest = [ASIHTTPRequest requestWithURL:lurl];
    
    // Embed the callback delegate in the request object.
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:theDelegate forKey:KEY_COMM_DELEGATE];
    [httpRequest setUserInfo:requestDict];
    
    [httpRequest setDelegate:self];
    [httpRequest setUserInfo:requestDict];
    [httpRequest setDidFinishSelector:@selector(sendAsyncNowNewIsFinished:)];
    [httpRequest setDidFailSelector:@selector(sendAsyncNowNewDidFail:)];
    
    [self.netQueue addOperation:httpRequest];
}

- (void)sendAsyncNowNewIsFinished:(ASIHTTPRequest*)theRequest
{
    NSLog(@"[CommunicationManager::sendAsyncNowNewIsFinished]");
    
    NSData *myResponseData = [theRequest responseData];
    NSString *result = [[NSString alloc] initWithData:myResponseData encoding:NSUTF8StringEncoding];
    NSLog(@" - - - ");
    NSLog(@"RESPONSE = %@", result);
    NSLog(@" - - - ");
    
    NSDictionary *infoDict = [theRequest userInfo];
    
    if(infoDict && [infoDict isKindOfClass:[NSDictionary class]])
    {
        id requestDelegate = [infoDict objectForKey:KEY_COMM_DELEGATE];
        
        if([requestDelegate respondsToSelector:@selector(sendAsyncNowNewIsFinished:)])
        {
            [requestDelegate performSelector:@selector(sendAsyncNowNewIsFinished:) withObject:theRequest];
        }
        else
        {
            NSLog(@"Warning! [CommunicationManager] respondsToSelector FOR sendAsyncNowNewIsFinished FAILED");
        }
    }
    else
    {
        NSLog(@"Warning! [CommunicationManager] sendAsyncNowNewIsFinished infoDict is nil");
    }
}


- (void)sendAsyncNowNewDidFail:(ASIHTTPRequest*)theRequest
{
    NSLog(@"[CommunicationManager::getFlexConfigurationDidFail]");
    
    NSError *theError = [theRequest error];
    
    NSLog(@"%@", [theError localizedDescription]);
    NSLog(@"%@", [theError localizedFailureReason]);
    NSLog(@"%@", [theError localizedRecoverySuggestion]);
    
    NSDictionary *infoDict = [theRequest userInfo];
    
    if(infoDict)
    {
        id requestDelegate = [infoDict objectForKey:KEY_COMM_DELEGATE];
        
        if([requestDelegate respondsToSelector:@selector(sendAsyncNowNewDidFail:)])
        {
            [requestDelegate performSelector:@selector(sendAsyncNowNewDidFail:) withObject:theError];
        }
        else
        {
            NSLog(@"Warning! [CommunicationManager] respondsToSelector FOR sendAsyncNowNewDidFail FAILED");
        }
    }
    else
    {
        NSLog(@"Warning! [CommunicationManager] sendAsyncNowNewDidFail infoDict is nil");
    }
}



-(NSString*)getServerUrl
{

        if(_server_settings_dictionary == nil || _server_settings_dictionary.count == 0){
            _server_settings_dictionary = [self readPlist:@"ServerSettings"];
        }
        return [_server_settings_dictionary valueForKey:@"api_root"];
}





-(void)sendData:(NSString*)api params:(NSMutableDictionary*)params withDelegate:(id)theDelegate
{
    NSMutableString *baseUrl = [[NSMutableString alloc] initWithFormat:@"%@/%@", [self getServerUrl],api];
    
    NSMutableString *tempURL = [[NSMutableString alloc] initWithString:baseUrl];
    if(params != nil){
        [tempURL appendParams:params];
    }
    
    ASIHTTPRequest *snapOnePostData = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:tempURL]];
    [snapOnePostData setDelegate:self];
    [snapOnePostData setTimeOutSeconds:15];
    
    // Embed the callback delegate in the request object.
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    if(theDelegate != nil){
        [requestDict setObject:theDelegate forKey:KEY_COMM_DELEGATE];
    }
    [snapOnePostData setUserInfo:requestDict];
    
    [snapOnePostData setDidFinishSelector:@selector(sendDataFinishedSuccess:)];
    [snapOnePostData setDidFailSelector:@selector(sendDataFinishedFailed:)];
    
    NSLog(@"Caling :%@",tempURL);
    
    [self.netQueue addOperation:snapOnePostData];
}


- (void)sendDataFinishedSuccess:(ASIHTTPRequest*)theRequest
{
    NSLog(@"[CommunicationManager::sendDataFinishedSuccess]");
    
	NSData *myResponseData = [theRequest responseData];
    NSString *result = [[NSString alloc] initWithData:myResponseData encoding:NSUTF8StringEncoding];
    NSLog(@" - - - ");
	NSLog(@"RESPONSE = %@", result);
    NSLog(@" - - - ");
    
    
    
    NSDictionary *infoDict = [theRequest userInfo];
    
    if(infoDict && [infoDict isKindOfClass:[NSDictionary class]])
    {
        id requestDelegate = [infoDict objectForKey:KEY_COMM_DELEGATE];
        
        if(requestDelegate)
        {
            [requestDelegate finishedPostingData:result];
        }
        else
        {
            NSLog(@"Warning! [CommunicationManager] requestDelegate FOR sendDataFinishedSuccess FAILED");
        }
    }
    else
    {
        NSLog(@"Warning! [CommunicationManager] sendDataFinishedSuccess infoDict is nil");
    }
    
}

- (void)sendDataFinishedFailed:(ASIHTTPRequest*)theRequest
{
    NSLog(@"[CommunicationManager::sendDataFinishedFailed]");
    NSData *myResponseData = [theRequest responseData];
    NSString *result = [[NSString alloc] initWithData:myResponseData encoding:NSUTF8StringEncoding];
    NSError *theError = [theRequest error];
    
    NSLog(@"%@", [theError localizedDescription]);
    NSLog(@"%@", [theError localizedFailureReason]);
    NSLog(@"%@", [theError localizedRecoverySuggestion]);
    
    NSDictionary *infoDict = [theRequest userInfo];
    
    if(infoDict)
    {
        id requestDelegate = [infoDict objectForKey:KEY_COMM_DELEGATE];
        
        if(requestDelegate)
        {
            [requestDelegate finishedPostingData:result];
        }
        else
        {
            NSLog(@"Warning! [CommunicationManager] requestDelegate FOR sendDataFinishedFailed FAILED");
        }
    }
    else
    {
        NSLog(@"Warning! [CommunicationManager] postDataFinishedFailed infoDict is nil");
    }
}



-(void)mgPostData:(NSMutableDictionary*)params postData:(NSData*)postData withDelegate:(id)theDelegate
{
    
    NSMutableString *baseUrl = [[NSMutableString alloc] initWithFormat:@"%@", [self getServerUrl]];
    
    NSMutableString *tempURL = [[NSMutableString alloc] initWithString:baseUrl];
    if(params != nil){
        [tempURL appendParams:params];
    }

    ASIHTTPRequest *snapOnePostData = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:tempURL]];
    [snapOnePostData setDelegate:self];
    [snapOnePostData setTimeOutSeconds:15];
    
    // Embed the callback delegate in the request object.
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    if(theDelegate != nil){
        [requestDict setObject:theDelegate forKey:KEY_COMM_DELEGATE];
    }
    [snapOnePostData setUserInfo:requestDict];
    
    [snapOnePostData setRequestMethod:@"POST"];
    [snapOnePostData addRequestHeader:@"Content-Type" value:@"application/json"];
    [snapOnePostData appendPostData:postData];
    
    [snapOnePostData setDidFinishSelector:@selector(postDataFinishedSuccess:)];
    [snapOnePostData setDidFailSelector:@selector(postDataFinishedFailed:)];
    
    NSLog(@"Caling :%@",tempURL);
    
    [self.netQueue addOperation:snapOnePostData];
}


- (void)postDataFinishedSuccess:(ASIHTTPRequest*)theRequest
{
    NSLog(@"[CommunicationManager::postDataFinishedSuccess]");
    
	NSData *myResponseData = [theRequest responseData];
    NSString *result = [[NSString alloc] initWithData:myResponseData encoding:NSUTF8StringEncoding];
    NSLog(@" - - - ");
	NSLog(@"RESPONSE = %@", result);
    NSLog(@" - - - ");
    
    
    
    NSDictionary *infoDict = [theRequest userInfo];
    
    if(infoDict && [infoDict isKindOfClass:[NSDictionary class]])
    {
        id requestDelegate = [infoDict objectForKey:KEY_COMM_DELEGATE];
        
        if(requestDelegate)
        {
            [requestDelegate finishedPostingData:result];
        }
        else
        {
            NSLog(@"Warning! [CommunicationManager] requestDelegate FOR postDataFinishedSuccess FAILED");
        }
    }
    else
    {
        NSLog(@"Warning! [CommunicationManager] postDataFinishedSuccess infoDict is nil");
    }
    
}

- (void)postDataFinishedFailed:(ASIHTTPRequest*)theRequest
{
    NSLog(@"[CommunicationManager::postDataFinishedFailed]");
    NSData *myResponseData = [theRequest responseData];
    NSString *result = [[NSString alloc] initWithData:myResponseData encoding:NSUTF8StringEncoding];
    NSError *theError = [theRequest error];
    
    NSLog(@"%@", [theError localizedDescription]);
    NSLog(@"%@", [theError localizedFailureReason]);
    NSLog(@"%@", [theError localizedRecoverySuggestion]);
    
    NSDictionary *infoDict = [theRequest userInfo];
    
    if(infoDict)
    {
        id requestDelegate = [infoDict objectForKey:KEY_COMM_DELEGATE];
        
        if(requestDelegate)
        {
            [requestDelegate finishedPostingData:result];
        }
        else
        {
            NSLog(@"Warning! [CommunicationManager] requestDelegate FOR postDataFinishedFailed FAILED");
        }
    }
    else
    {
        NSLog(@"Warning! [CommunicationManager] postDataFinishedFailed infoDict is nil");
    }
}


@end
