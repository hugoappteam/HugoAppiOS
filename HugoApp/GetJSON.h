//
//  GetJSON.h
//  HugoApp
//
//  Created by Niklas Dohmen on 10/11/14.
//  Copyright (c) 2014 Niklas Dohmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetJSON : NSObject
- (id) initWithValue:(NSString *)url;
- (NSDictionary*) getJSONData;

@end
