//
//  TableViewController.m
//  HugoApp
//
//  Created by Niklas Dohmen on 21/11/14.
//  Copyright (c) 2014 Niklas Dohmen. All rights reserved.
//

#import "TableViewController.h"
#import "SimpleTableViewCell.h"
#import "CoverData.h"
#import <QuartzCore/QuartzCore.h>
#import "GetJSON.h"
#import "AppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "MasterViewController.h"
#import "DetailCellViewController.h"


@interface TableViewController () {
    MasterViewController *parentMasterViewController;
}
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    parentMasterViewController = (MasterViewController*) self.parentViewController;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor orangeColor];
    [self.refreshControl addTarget:self action:@selector(globalRefresh) forControlEvents:UIControlEventValueChanged];
    [self stopPullToRefreshAnimation];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
//    return [[self sectionTitles] count];
    return 1;
}

- (void) globalRefresh {
    NSLog(@"reloadData");
    [parentMasterViewController Refresh];
}

-(void)stopPullToRefreshAnimation
{
    [self.refreshControl endRefreshing]; // call to stop animation
    
    UIEdgeInsets inset = UIEdgeInsetsMake(1, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.tableView.scrollIndicatorInsets = inset;
} //stopPullToRefreshAnimation

- (void) reloadTableData {
    if (self.refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"d. MMMM, HH:mm"];
        NSString *title = [NSString stringWithFormat:@"Letztes Update: %@ Uhr", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        //[self.refreshControl endRefreshing];
        [self stopPullToRefreshAnimation];
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self FilteredData] count];
}

#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}


- (UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SimpleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[SimpleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.actualTeacher setText:[[[self FilteredData] objectAtIndex:indexPath.row] teacher]];
    [cell.nameLabel setText:[[[self FilteredData] objectAtIndex:indexPath.row] grade]];
    [cell.representTeacher setText:[[[self FilteredData] objectAtIndex:indexPath.row] supplyTeacher]];
    [cell.lesson setText:[[[self FilteredData] objectAtIndex:indexPath.row] lesson]];
    [cell.date setText:[[[self FilteredData] objectAtIndex:indexPath.row] date]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SegueDetailCell" sender:self];
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController]
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SegueDetailCell"]) {
        DetailCellViewController *detailCellController = [segue destinationViewController];
        [detailCellController setCoverDataToShow:[self.FilteredData objectAtIndex:[self.tableView indexPathForSelectedRow].row]];
    }
}


@end
