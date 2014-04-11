//
//  ViewController.m
//  NSURLSessionTest
//
//  Created by Weinstein, Randy - Nick.com on 4/9/14.
//  Copyright (c) 2014 Viacom. All rights reserved.
//

#import "ViewController.h"
#import "VMNViewDBRequest.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
   [[VMNViewDBRequest sharedInstance] postPlayheadPositionForUser:@"123"
                        position:@8000
                         brand:@"MTV"
                          mgid:@"mgid32"
                        completion:^(BOOL success, NSString *statusMessage) {
                            if (!success) {
                                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"DBView Submission Error"
                                                                                  message:statusMessage
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"OK"
                                                                        otherButtonTitles:nil];
                                
                                [message show];
                            } else {
                                NSLog(@"%@",statusMessage);
                            }
                            
                        }
     ];
    
    [[VMNViewDBRequest sharedInstance] getPlayHeadPositionForUser:@"123"
                               brand:@"MTV"
                                mgid:@"mgid32"
                          completion:^( BOOL  success, NSDictionary *playHeadPositionData ) {
                              if (!success) {
                                  UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"DBView Retrieval Error"
                                                                                    message:@"Could not retrieve playhead position"
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil];
                                  
                                  [message show];
                              } else {
                                  NSLog(@"got the info:%@",playHeadPositionData);
                              }
                          }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
