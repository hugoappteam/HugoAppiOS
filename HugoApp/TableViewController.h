//
//  TableViewController.h
//  HugoApp
//
//  Created by Niklas Dohmen on 21/11/14.
//  Copyright (c) 2014 Niklas Dohmen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property NSArray *FilteredData;
- (void) reloadTableData;
@end
