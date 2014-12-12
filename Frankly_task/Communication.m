//
//  Communication.m
//  PoliticalApp
//
//  Created by Phani vihari on 2/14/12.
//  Copyright 2012 Zytrix Labs. All rights reserved.
//

#import "Communication.h"
#import "SBJSON.h"
//#import "LeveyHUD.h"
#define TIMEOUT_INTERVAL 30

@implementation Communication
@synthesize delegate = delegate_;
@synthesize serviceFor = serviceFor_;
@synthesize responseData = responseData_;

-(void)makeAsynchronousRequestWithUrl:(NSURL *)url withBodyString:(NSString *)body andWithMethod:(NSString *)method{
	NSLog(@"Url = %@",url);
    NSLog(@"Body = %@",body);
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[theRequest setHTTPMethod:method];	
	[theRequest setTimeoutInterval:TIMEOUT_INTERVAL];
    if (body != nil) {
        [theRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if(theConnection){
		//responseData_ = [[NSMutableData data] retain];
        responseData_ = [[NSMutableData alloc] init];
		theConnection = nil;
	}
	else {
	}
    theRequest = nil;
    body = nil;
}

-(void)makeSynchronousRequestWithUrl:(NSURL *)url withBodyString:(NSString *)body andWithMethod:(NSString *)method{
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	[theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[theRequest setTimeoutInterval:TIMEOUT_INTERVAL];
    if (body != nil) {
        [theRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *responseData1 = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
	NSString *str =  [[NSString alloc] initWithData:responseData1 encoding:NSUTF8StringEncoding];
	SBJSON *parser = [[SBJSON alloc] init];  
	id data = [parser objectWithString:str error:nil];
	 parser = nil;
	 str	= nil;
	if (error && [responseData1 length] == 0) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(failedToGetDataWithError:andWithServiceName:)]) {
			if (error) {
				[self.delegate failedToGetDataWithError:[NSString stringWithFormat:@"Could not register you,%@",[error localizedDescription]] andWithServiceName:self.serviceFor];
			}
			else {
				[self.delegate failedToGetDataWithError:@"No Data Found" andWithServiceName:self.serviceFor];
			}
		}
        data = nil;
		return;
	}
	else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseData:andWithServiceName:)]) {
            [self.delegate responseData:data andWithServiceName:self.serviceFor];
        }
	}
    data = nil;
}


-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response{
	[self.responseData setLength:0];
//	NSHTTPURLResponse * httpResponse;
//	
//	httpResponse = (NSHTTPURLResponse *) response;
//	
//	NSLog(@"HTTP error %zd", (ssize_t) httpResponse.statusCode);	
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
	[self.responseData appendData:data];	
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error{
	responseData_ = nil;
	if (self.delegate) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(failedToGetDataWithError:andWithServiceName:)]) {
			[self.delegate failedToGetDataWithError:[error localizedDescription] andWithServiceName:self.serviceFor];
		}
	}
}

- (void)enoughBaby{
    //[[LeveyHUD sharedHUD] delayDisappear:0.1f withText:activity_indicator_stop];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    connection = nil;
	NSString *str =  [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"+++++++++++++++String+++++++++++++++++++++++++%@",str);
	SBJSON *parser = [[SBJSON alloc] init];
    id data = [parser objectWithString:str error:nil];
    NSLog(@".............output............>%@",data);
	 parser = nil;
	 str	= nil;
    if ([self.responseData length] == 0) {
        if (self.delegate && self.delegate && [self.delegate respondsToSelector:@selector(failedToGetDataWithError:andWithServiceName:)]){
            [self.delegate failedToGetDataWithError:@"No Data Found" andWithServiceName:self.serviceFor];
        }
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(responseData:andWithServiceName:)]) {
            [self.delegate responseData:data andWithServiceName:self.serviceFor];
        }
    }
    data = nil;
    responseData_ = nil;
}

-(void) dealloc{
	//self.delegate = nil;
   // [super dealloc];
    delegate_ = nil;
    if (self.responseData) {
    }
}
@end
