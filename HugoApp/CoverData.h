//
//  VertretungData.h
//  HugoApp
//
//  Created by Niklas Dohmen on 28/11/14.
//  Copyright (c) 2014 Niklas Dohmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoverData : NSObject

@property NSInteger *id;
@property NSString *grade;
@property NSString *teacher;
@property NSString *date;
@property NSString *lesson;
@property NSString *subject;
@property NSString *room;
@property NSString *supplyTeacher;
@property NSString *info;

@end
