//
//  VMNViewDBRequest.h
//  NSURLSessionTest
//
//  Created by Weinstein, Randy - Nick.com on 4/10/14.
//  Copyright (c) 2014 Viacom. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^PlayheadRequestHandler)(BOOL success, NSDictionary *playHeadPositionData);
typedef void (^PlayheadPostHandler)(BOOL success, NSString *statusMessage);

@interface VMNViewDBRequest : NSObject

+ (VMNViewDBRequest *)sharedInstance;

- (void) getPlayHeadPositionForUser:(NSString *)userId
                              brand:(NSString *)brand
                               mgid:(NSString *)mgid
                         completion:(PlayheadRequestHandler)completion;

-(void) postPlayheadPositionForUser:(NSString *)userId
                           position:(NSNumber *) playHeadPosition
                              brand:(NSString *)brand
                               mgid:(NSString *)mgid
                         completion:(PlayheadPostHandler)completion;


@end
