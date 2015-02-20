//
//  DetailCellViewController.m
//  HugoApp
//
//  Created by Niklas Dohmen on 06/02/15.
//  Copyright (c) 2015 Niklas Dohmen. All rights reserved.
//

#import "DetailCellViewController.h"
#import "CoverData.h"

@interface DetailCellViewController ()
@property (weak, nonatomic) IBOutlet UILabel *grade;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *lesson;
@property (weak, nonatomic) IBOutlet UILabel *teacher;
@property (weak, nonatomic) IBOutlet UILabel *supplyTeacher;

@property (weak, nonatomic) IBOutlet UILabel *room;
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UITextView *info;


//@property NSInteger *id;
//@property NSString *grade;
//@property NSString *teacher;
//@property NSString *date;
//@property NSString *lesson;
//@property NSString *subject;
//@property NSString *room;
//@property NSString *supplyTeacher;
//@property NSString *info;
@end

@implementation DetailCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self grade] setText:[self CoverDataToShow].grade];
    [[self date] setText:[self CoverDataToShow].date];
    [[self lesson] setText:[self CoverDataToShow].lesson];
    [[self teacher] setText:[self CoverDataToShow].teacher];
    [[self supplyTeacher] setText:[self CoverDataToShow].supplyTeacher];
    [[self room] setText:[self CoverDataToShow].room];
    [[self subject] setText:[self CoverDataToShow].subject];
    [[self info] setText:[self CoverDataToShow].info];
    
    [[[self grade] layer] setCornerRadius:5];
    [self grade].backgroundColor = [UIColor colorWithRed:0.98 green:0.506 blue:0.149 alpha:1];
    [self grade].textColor = [UIColor whiteColor];
    [[self grade] setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
