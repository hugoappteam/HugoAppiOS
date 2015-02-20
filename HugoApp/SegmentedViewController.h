//
//  SegmentedViewController.h
//  HugoApp
//
//  Created by Niklas Dohmen on 17/11/14.
//  Copyright (c) 2014 Niklas Dohmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentedViewController : UIViewController

@property(nonatomic, assign) UIViewController *selectedViewController;
@property(nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, strong) IBOutlet UIView *viewContainer;
@property(nonatomic, assign) NSInteger selectedViewControllerIndex;

- (void)setViewControllers:(NSArray *)viewControllers;
- (void)setViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles;
- (void)setViewControllers:(NSArray *)viewControllers imagesNamed:(NSArray *)imageNames;
- (void)setViewControllers:(NSArray *)viewControllers images:(NSArray *)images;
- (void)pushViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController title:(NSString *)title;
- (void)pushViewController:(UIViewController *)viewController imageNamed:(NSString *)imageName;
- (void)pushViewController:(UIViewController *)viewController image:(UIImage *)image;

@end
