//
//  ViewDBRequest.m
//  NSURLSessionTest
//
//  Created by Weinstein, Randy - Nick.com on 4/10/14.
//  Copyright (c) 2014 Viacom. All rights reserved.
//

#import "ViewDBRequest.h"

@implementation ViewDBRequest

+ (instancetype)sharedInstance {
	__strong static ViewDBRequest *_sharedObject = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    _sharedObject = [self new];
	});
    
	return _sharedObject;
}

- (void) getPlayHeadPositionForUser:(NSString *)userId
                              brand:(NSString *)brand
                               mgid:(NSString *)mgid
                         completion:(PlayheadRequesHandler)completion
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *viewDBURL   = [NSString stringWithFormat:@"http://user.flux-q.mtvi.com/api/v1/user/uuid/%@/%@/playheadPositions/%@",
                             userId,
                             brand,
                             mgid];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:
                                      [NSURL URLWithString:viewDBURL]
                                            completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          __block NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          
                                          dispatch_async(
                                                         dispatch_get_main_queue(),
                                                         ^{
                                                             completion(json);
                                                         });
                                      }];
    
    [dataTask resume];
    
}


-(void) postPlayheadPositionForUser:(NSString *)userId
                           position:(NSNumber *) playHeadPosition
                              brand:(NSString *)brand
                               mgid:(NSString *)mgid
                         completion:(PlayheadPostHandler)completion

{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *urlString = [NSString stringWithFormat:@"http://user.flux-q.mtvi.com/api/v1/user/uuid/%@/%@/playheadPositions/%@",userId,brand,mgid];
    NSURL    *viewDBURL = [NSURL URLWithString:urlString];
    
    NSError *error;
    
    NSDate *referenceDate = [NSDate date];
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *submitTime = [DateFormatter stringFromDate:referenceDate];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *submitDate = [DateFormatter stringFromDate:referenceDate];
    
    NSString *lastViewed = [NSString stringWithFormat:@"%@T%@Z",submitDate,submitTime];
    
    NSLog(@"last Viewed: %@",lastViewed);
    
    //@"2014-04-08T11:29:00Z"
    
    
    NSMutableDictionary *viewDBParams = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                        @"offsetMsec" : playHeadPosition,
                                                                                        @"lastViewed" :lastViewed
                                                                                        }
                                         ];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:viewDBURL];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:viewDBParams
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    [urlRequest setHTTPBody:jsonData];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                           NSLog(@"status code %d",[httpResponse statusCode]);
                                                           
                                                           __block BOOL success = ([httpResponse statusCode] == 201);
                                                           __block NSString *statusText = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                           
                                                           
                                                           dispatch_async(
                                                                          dispatch_get_main_queue(),
                                                                          ^{
                                                                              completion(success,statusText);
                                                                          }
                                                                          );
                                                       }];
    [dataTask resume];
    
}


@end
