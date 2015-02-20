//
//  MasterViewController.m
//  HugoApp
//
//  Created by Niklas Dohmen on 17/11/14.
//  Copyright (c) 2014 Niklas Dohmen. All rights reserved.
//

#import "MasterViewController.h"
#import <Foundation/Foundation.h>
#import "TableViewController.h"

#import "TableViewController.h"
#import "SimpleTableViewCell.h"
#import "CoverData.h"
#import <QuartzCore/QuartzCore.h>
#import "GetJSON.h"
#import "AppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import <Parse/Parse.h>

@interface MasterViewController () {
    NSMutableArray *_objects;
    int count;
    NSMutableArray *allData;
    NSMutableArray *weekdays;
    NSMutableArray *allDates;
    NSMutableArray *filtered;
    

    __weak IBOutlet UIBarButtonItem *timestampBarItem;
    __weak IBOutlet UIBarButtonItem *RefreshButton;
    Reachability *networkReachability;
    NetworkStatus networkStatus;
}

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    
    
    networkReachability = [Reachability reachabilityForInternetConnection];

    weekdays = [[NSMutableArray alloc] init];
    //all JSON Data in Arrays as an CoverData object
    allDates = [[NSMutableArray alloc] init];
    filtered = [[NSMutableArray alloc] init];
    
    #pragma get data
    // Check for network status
    // if network ist not reachable -> load last local data from Core Data
    networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There is NO internet connection");
        allData = [self loadDataFromCoreData];
    } else {
        NSLog(@"There IS internet connection");
        allData = [self loadJSONDataFromServer];
    }
    [self setLastUpdateStamp];

    for (int i = 0; i < [weekdays count]; i++) {
        TableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tableSubViewController"];
        
        for (CoverData *cover in allData) {
            if ([cover.date isEqualToString:[allDates objectAtIndex:i]]) {
                [filtered addObject:cover];
            }
        }
        [viewController setFilteredData:filtered];
        NSLog(@"AllData info: %@", [[allData objectAtIndex:i] description]);
        [self pushViewController:viewController title:[weekdays objectAtIndex:i]];
        filtered = [[NSMutableArray alloc] init];
    }
    [self setSelectedViewControllerIndex:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@", @"viewDidAppear here.");
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    BOOL isLoggedIn = [prefs boolForKey:@"ISLOGGEDIN"];
//    if(!isLoggedIn) {
//        //isn't logged in
//        [self performSegueWithIdentifier:@"goto_login" sender:self];
//    } else {
//        
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) Refresh {
    NSLog(@"Refresh!");
    NSLog(@"ChildViewController: %lu", (unsigned long)[[self childViewControllers] objectAtIndex:0]);
    [filtered removeAllObjects];
    networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"UPDATE - There is NO internet connection");
        allData = [self loadDataFromCoreData];
    } else {
        NSLog(@"UPDATE - There IS internet connection");
        allData = [self loadJSONDataFromServer];
    }
    while ([weekdays  count] > [[self childViewControllers] count]) {
        TableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tableSubViewController"];
        [self pushViewController:viewController];
    }
    while ([weekdays  count] < [[self segmentedControl] numberOfSegments]) {
        [[self segmentedControl] removeSegmentAtIndex:[[self segmentedControl]numberOfSegments]-1 animated:TRUE];
        [self setSelectedViewControllerIndex:0];
    }
    for (int i = 0; i < [weekdays count]; i++) {
        for (CoverData *cover in allData) {
            if ([cover.date isEqualToString:[allDates objectAtIndex:i]]) {
                [filtered addObject:cover];
            }
        }
        [[[self childViewControllers] objectAtIndex:i] setFilteredData:filtered];
        [[self segmentedControl] setTitle:[weekdays objectAtIndex:i] forSegmentAtIndex:i];
        filtered = [[NSMutableArray alloc] init];
    }
    for (int i = 0; i < [weekdays count]; i++) {
        [[[self childViewControllers] objectAtIndex:i] reloadTableData];
    }
    [self setLastUpdateStamp];
}

- (IBAction)RefreshButton:(id)sender {
    //[self Refresh];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:false forKey:@"ISLOGGEDIN"];
    [self performSegueWithIdentifier:@"goto_login" sender:self];
    
    

}

- (void) setLastUpdateStamp {
    NSLog(@"load last update info");
    networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There is NO internet connection");
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"LastUpdateTimestamp" inManagedObjectContext:context];
        NSFetchRequest *request= [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        NSManagedObject *matches = nil;
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request
                                                  error:&error];
        if ([objects count] == 0)
        {
            NSLog(@"No matches");
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
            NSDate *date = [objects[[objects count] - 1] valueForKey:@"updateTimestamp"];
            NSLog([date description]);
            
            [timestampBarItem setTitle:[@"Letzte Akt.: " stringByAppendingString:[dateFormatter stringFromDate:date]]];
        }
        
    } else {
        NSLog(@"There IS internet connection");
        GetJSON *json = [[GetJSON alloc] initWithValue:@"http://hjg.pf-control.de/JSONLastUpdate.php"];
        NSString *JSONData = [json getJSONData];
        NSLog(@"JSON data desc: %@", JSONData);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:JSONData];
        NSLog(@"Date %@", [date description]);
        //storing new date
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSManagedObject *newUpdateTimestamp;
        NSError *error;
        newUpdateTimestamp = [NSEntityDescription insertNewObjectForEntityForName:@"LastUpdateTimestamp" inManagedObjectContext:context];
        [newUpdateTimestamp setValue:date forKey:@"updateTimestamp"];
        [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
        NSLog(@"New date: %@", [dateFormatter stringFromDate:date]);
        [timestampBarItem setTitle:[@"Letzte Akt.: " stringByAppendingString:[dateFormatter stringFromDate:date]]];
    }
}


///////// Have to work on /////////
- (NSString *) getDateWithName:(NSString *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.YYYY"];
    NSDate *todaysDate = [NSDate date];
    NSDate *givenDate = [dateFormatter dateFromString:date];
    NSComparisonResult result = [todaysDate compare:givenDate];
    switch (result) {
        case NSOrderedAscending:
            NSLog(@"Future date!!!!!");
            break;
        case NSOrderedDescending:
            
            break;
        case NSOrderedSame:
            NSLog(@"Today");
            break;
            
        default:
            return nil;
            break;
    }
    return nil;
}
///////////////////////////////////

- (NSMutableArray *)loadDataFromCoreData {
    NSLog(@"load data from core data");
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"CoverData" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSMutableArray *loadedData = [[NSMutableArray alloc] init];
    
    // commented because all rows must selected
    //NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id > %@)", @"1"];
    //[request setPredicate:pred];
    NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    if ([objects count] == 0)
    {
        NSLog(@"No matches");
    }
    else
    {
        CoverData *coverData = [[CoverData alloc] init];
        for (int i = 0; i < [objects count]; i++)
        {
            matches = objects[i];
            [coverData setId: [[matches valueForKey:@"id"] integerValue]];
            [coverData setSubject: [matches valueForKey:@"subject"]];
            [coverData setInfo: [matches valueForKey:@"info"]];
            [coverData setGrade: [matches valueForKey:@"grade"]];
            [coverData setTeacher: [matches valueForKey:@"teacher"]];
            [coverData setRoom: [matches valueForKey:@"room"]];
            [coverData setLesson: [matches valueForKey:@"lesson"]];
            [coverData setDate: [matches valueForKey:@"date"]];
            [coverData setSupplyTeacher: [matches valueForKey:@"supplyTeacher"]];
            NSLog(@"Grade: %@", coverData.grade);
            [loadedData addObject:coverData];
            coverData = [[CoverData alloc] init];
        }
    }
    
    [allDates removeAllObjects];
    for (CoverData *cover in loadedData) {
        //        if (![sectionTitles containsObject:[cover lesson]]) {
        //            [sectionTitles addObject:[cover lesson]];
        //        }
        // get all dates from data
        if(![allDates containsObject:[cover date]]) {
            NSLog(@"object not in allDates, %@", [cover date]);
            [allDates addObject:[cover date]];
            NSLog(@"Add object to allDates, %@", [cover date]);
        }
    }
    
    
    // converts all given dates in weekdays
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [weekdays removeAllObjects];
    for (NSString *date in allDates) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //NSLog(@"Date: %@", date);
        NSDate *newDate = [dateFormatter dateFromString:date];
        dateFormatter.dateFormat=@"EEEE";
        [weekdays addObject:[[dateFormatter stringFromDate:newDate] capitalizedString]];
    }
    NSLog(@"weekdays: %@", [weekdays description]);
    
    return loadedData;
}

- (NSMutableArray *) loadJSONDataFromServer {
    NSLog(@"load data from server");
    NSMutableArray *loadedData = [[NSMutableArray alloc] init];
    CoverData *data = [[CoverData alloc] init];
    
    GetJSON *json = [[GetJSON alloc] initWithValue:@"http://hjg.pf-control.de/JSON.php"];
    NSDictionary *JSONData = [json getJSONData];
    //NSLog(@"Dictionary: %@", [JSONData description]);
    /*
     NSString *key = [[NSString alloc] init];
     key = @"Stunde";
     titles = [[JSONData valueForKey:key] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
     for (int i = 0; i < [titles count]; i++) {
     if (![sectionTitles containsObject:[titles objectAtIndex:i]]) {
     [sectionTitles addObject:[titles objectAtIndex:i]];
     }
     }
     NSLog(@"Sectiontitles: %@", [sectionTitles description]);
     
     */
    // sort Dictionary with Key "Stunde" ? Is there an return?
    //NSArray *JSONDataKeys = [JSONData allKeys];
    //NSArray *sortedKeys = [JSONDataKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newCoverData;
    NSError *error;
    
    for (NSDictionary *dict in JSONData) {
        NSLog(@"Fach: %@", [dict valueForKey:@"Fach"]);
        NSLog(@"Info: %@", [dict valueForKey:@"Info"]);
        NSLog(@"Klasse: %@", [dict valueForKey:@"Klasse"]);
        NSLog(@"Lehrer: %@", [dict valueForKey:@"Lehrer"]);
        NSLog(@"Raum: %@", [dict valueForKey:@"Raum"]);
        NSLog(@"Stunde: %@", [dict valueForKey:@"Stunde"]);
        NSLog(@"Tag: %@", [dict valueForKey:@"Tag"]);
        NSLog(@"Vertreter: %@", [dict valueForKey:@"Vertreter"]);
        NSLog(@"id: %@", [dict valueForKey:@"id"]);
        
        [data setId: [[dict valueForKey:@"id"] integerValue]];
        [data setSubject: [dict valueForKey:@"Fach"]];
        [data setInfo: [dict valueForKey:@"Info"]];
        [data setGrade: [dict valueForKey:@"Klasse"]];
        [data setTeacher: [dict valueForKey:@"Lehrer"]];
        [data setRoom: [dict valueForKey:@"Raum"]];
        [data setLesson: [dict valueForKey:@"Stunde"]];
        [data setDate: [dict valueForKey:@"Tag"]];
        [data setSupplyTeacher: [dict valueForKey:@"Vertreter"]];
        [loadedData addObject:data];
        
        newCoverData = [NSEntityDescription insertNewObjectForEntityForName:@"CoverData" inManagedObjectContext:context];
        [newCoverData setValue:[dict valueForKey:@"Fach"] forKey:@"subject"];
        [newCoverData setValue:[dict valueForKey:@"Info"] forKey:@"info"];
        [newCoverData setValue:[dict valueForKey:@"Klasse"] forKey:@"grade"];
        [newCoverData setValue:[dict valueForKey:@"Lehrer"] forKey:@"teacher"];
        [newCoverData setValue:[dict valueForKey:@"Raum"] forKey:@"room"];
        [newCoverData setValue:[dict valueForKey:@"Stunde"] forKey:@"lesson"];
        [newCoverData setValue:[dict valueForKey:@"Tag"] forKey:@"date"];
        [newCoverData setValue:[dict valueForKey:@"Vertreter"] forKey:@"supplyTeacher"];
        [context save:&error];
        data = [[CoverData alloc] init];
    }
    
    [allDates removeAllObjects];
    for (CoverData *cover in loadedData) {
//        if (![sectionTitles containsObject:[cover lesson]]) {
//            NSLog(@"Add object to sectionTitles %@", [cover lesson]);
//            [sectionTitles addObject:[cover lesson]];
//        }
         // get all dates from data
        if(![allDates containsObject:[cover date]]) {
            NSLog(@"object not in allDates, %@", [cover date]);
            [allDates addObject:[cover date]];
            NSLog(@"Add object to allDates, %@", [cover date]);
        }
    }
    
    
    // converts all given dates in weekdays
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [weekdays removeAllObjects];
    for (NSString *date in allDates) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //NSLog(@"Date: %@", date);
        NSDate *newDate = [dateFormatter dateFromString:date];
        dateFormatter.dateFormat=@"EEEE";
        //NSLog(@"Weekday: %@", [[dateFormatter stringFromDate:newDate] capitalizedString]);
        [weekdays addObject:[[dateFormatter stringFromDate:newDate] capitalizedString]];
    }
    NSLog(@"weekdays: %@", [weekdays description]);
    
    return loadedData;
}


@end
