//
//  SimpleTableViewCell.h
//  HugoApp
//
//  Created by Niklas Dohmen on 28/11/14.
//  Copyright (c) 2014 Niklas Dohmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SimpleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualTeacher;
@property (weak, nonatomic) IBOutlet UILabel *representTeacher;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *lesson;



@end
