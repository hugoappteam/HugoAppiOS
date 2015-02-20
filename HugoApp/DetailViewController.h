//
//  DetailViewController.h
//  HugoApp
//
//  Created by Niklas Dohmen on 17/11/14.
//  Copyright (c) 2014 Niklas Dohmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
