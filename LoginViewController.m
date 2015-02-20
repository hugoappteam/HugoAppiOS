//
//  LoginViewController.m
//  HugoApp
//
//  Created by Niklas Dohmen on 25/01/15.
//  Copyright (c) 2015 Niklas Dohmen. All rights reserved.
//

#import "LoginViewController.h"
#import "GetJSON.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *Login;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@end

@implementation LoginViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL isLoggedIn = [prefs boolForKey:@"ISLOGGEDIN"];
    if(isLoggedIn) {
        [self performSegueWithIdentifier:@"goto_main" sender:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSegueWithIdentifier:@"goto_main" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)LoginPressed:(id)sender {
//    NSURL *loginURL = [NSURL URLWithString:@"http://hjg.pf-control.de/JSONlogin.php"];
//    [[self usernameTF] text];
//    
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:loginURL
//                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                       timeoutInterval:60.0];
//    [request setHTTPMethod:@"POST"];
//    NSString *postString = [NSString stringWithFormat:@"username=%@", [[self usernameTF] text]];
//    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
//                                                            delegate:self];
//    [connection start];
    //[connection paste:stringa];
    //NSLog(@"conntection: %@", [connection description]);
    
    
    [PFUser logInWithUsernameInBackground:[[self usernameTF] text] password:[[self passwordTF] text]
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                                [self performSegueWithIdentifier:@"goto_main" sender:self];
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"Login failed");
                                        }
                                    }];
    
    //[self performSegueWithIdentifier:@"goto_main" sender:self];

    
    
//    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setBool:true forKey:@"ISLOGGEDIN"];
//    [self performSegueWithIdentifier:@"goto_main" sender:self];
}




//- (NSMutableArray *) loadJSONDataFromServer {
//    NSLog(@"load data from server");
//    NSMutableArray *loadedData = [[NSMutableArray alloc] init];
//    CoverData *data = [[CoverData alloc] init];
//    
//    GetJSON *json = [[GetJSON alloc] initWithValue:@"http://hjg.pf-control.de/JSON.php"];
//    NSDictionary *JSONData = [json getJSONData];



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
