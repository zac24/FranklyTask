//
//  Communication.h
//  AmgonnaApp
//
//  Created by Phani vihari on 2/14/12.
//  Copyright 2012 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommunicatonDelegate
@required
-(void)responseData:(id)data andWithServiceName:(NSString *)serviceName;
-(void)failedToGetDataWithError:(NSString *)error andWithServiceName:(NSString *)serviceName;
@end


@interface Communication : NSObject {
//	id delegate;
	
//	NSString *serviceFor;
}

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) NSString *serviceFor;
@property (nonatomic, strong) NSMutableData *responseData;

-(void)makeAsynchronousRequestWithUrl:(NSURL *)url withBodyString:(NSString *)body andWithMethod:(NSString *)method;
-(void)makeSynchronousRequestWithUrl:(NSURL *)url withBodyString:(NSString *)body andWithMethod:(NSString *)method;

@end
