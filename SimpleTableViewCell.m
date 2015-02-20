//
//  SimpleTableViewCell.m
//  HugoApp
//
//  Created by Niklas Dohmen on 28/11/14.
//  Copyright (c) 2014 Niklas Dohmen. All rights reserved.
//

#import "SimpleTableViewCell.h"

@implementation SimpleTableViewCell

@synthesize nameLabel;
@synthesize actualTeacher;
@synthesize representTeacher;

- (void)awakeFromNib {
    // Initialization code
    //[[nameLabel layer] setBorderColor:[[UIColor colorWithRed:0.98 green:0.506 blue:0.149 alpha:1.0] CGColor]];
    //[[nameLabel layer] backgroundColor];
    //[[nameLabel layer] setBackgroundColor:[[UIColor colorWithRed:0.98 green:0.506 blue:0.149 alpha:1] CGColor]];
    //[[nameLabel layer] setBorderWidth:0];
    [[nameLabel layer] setCornerRadius:5];
    nameLabel.backgroundColor = [UIColor colorWithRed:0.98 green:0.506 blue:0.149 alpha:1];
    nameLabel.textColor = [UIColor whiteColor];
    [nameLabel setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
