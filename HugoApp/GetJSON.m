//
//  GetJSON.m
//  HugoApp
//
//  Created by Niklas Dohmen on 10/11/14.
//  Copyright (c) 2014 Niklas Dohmen. All rights reserved.
//

#import "GetJSON.h"

@implementation GetJSON
{
    NSString *URL;
}

- (id) initWithValue:(NSString *)url {
    self = [super init];
    if (self) {
        URL = url;
    }
    return self;
}

- (NSDictionary *) getJSONData {
    NSData *data = [[NSString stringWithContentsOfURL: [NSURL URLWithString:URL] encoding:NSUTF8StringEncoding error: nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    // the option NSJSONReadingAllowFragments ist for updating the LastUpdateTimeStamp because the php code do not give a right json wrapper
    NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&error];
    
    if (!jsonResult) {
        NSLog(@"Error while parsing JSON data: %@", error);
    }
    return jsonResult;
}



- (NSArray *) sendJSONData {
    NSDictionary *newDatasetInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"niklas", @"name", @"2511", @"password", nil];
    
   // convert object to data
    NSError *error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
    // print json:
    NSLog(@"JSON summary: %@", [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding]);
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://webstar52.com/demo/webcommunity/work.php"]]];
//    NSString *post = [NSString stringWithFormat:@"&tag=%@&user_id=%@",@"getcontact",@"10408"];
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
//    [request setHTTPBody:postData];
//    conn  = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    return nil;
}

@end





/*
- (void) ReceiveItems {
    // http://hjg.pf-control.de/login.php
    NSString *url = @"http://hjg.pf-control.de/JSON.php";
    NSData *jsonDataString = [[NSString stringWithContentsOfURL: [NSURL URLWithString:url]
                                                       encoding:NSUTF8StringEncoding error: nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonDataString options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
    
    NSLog(@"Dictionary: %@", [results description]);
}

*/