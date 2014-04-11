//
//  ViewDBRequest.h
//  NSURLSessionTest
//
//  Created by Weinstein, Randy - Nick.com on 4/10/14.
//  Copyright (c) 2014 Viacom. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^PlayheadRequesHandler)(NSDictionary *playHeadPositionData);
typedef void (^PlayheadPostHandler)(BOOL success, NSString *statusMessage);

@interface ViewDBRequest : NSObject

+ (ViewDBRequest *)sharedInstance;

- (void) getPlayHeadPositionForUser:(NSString *)userId
                              brand:(NSString *)brand
                               mgid:(NSString *)mgid
                         completion:(PlayheadRequesHandler)completion;
-(void) postPlayheadPositionForUser:(NSString *)userId
                           position:(NSNumber *) playHeadPosition
                              brand:(NSString *)brand
                               mgid:(NSString *)mgid
                         completion:(PlayheadPostHandler)completion;


@end
