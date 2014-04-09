//
//  ViewController.m
//  NSURLSessionTest
//
//  Created by Weinstein, Randy - Nick.com on 4/9/14.
//  Copyright (c) 2014 Viacom. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self httpPostWithCustomDelegate];
    [self httpGETNoDelegate];
}

- (void) httpGETNoDelegate {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *appleURL = @"https://itunes.apple.com/search?term=apple&media=software";
    NSString *viewDBURL = @"http://user.flux-q.mtvi.com/api/v1/user/uuid/123/MTV/playheadPositions/mgid32";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:
                                      [NSURL URLWithString:viewDBURL]
                                            completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          NSLog(@"%@", json);
                                      }];
    
    [dataTask resume];
    
}


-(void) httpPostWithCustomDelegate
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL    *viewDBURL = [NSURL URLWithString:@"http://user.flux-q.mtvi.com/api/v1/user/uuid/123/MTV/playheadPositions/mgid32"];

    NSError *error;
    
    NSMutableDictionary *viewDBParams = [NSMutableDictionary dictionaryWithDictionary:@{
                                                            @"offsetMsec" : @5026,
                                                            @"lastViewed" : @"2014-04-08T11:29:00Z"
                                                            }
                                         ];
    NSLog(@"%@", viewDBParams);
    
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:viewDBURL];
   
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:viewDBParams
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    //NSMutableString *requestBody = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:jsonData];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSLog(@"Data = %@",text);
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
