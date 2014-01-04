//
//  PPParallaxViewController.h
//  PrivatePlot
//
//  Created by Kino on 13-12-7.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import "RBParallaxTableVC.h"

@protocol PPParallaxViewControllerDelegate;

@interface PPParallaxViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView   *imageView;

@property (nonatomic, strong) UIScrollView  *imageScroller;

@property (nonatomic, strong) UITableView   *tableView;

@property (nonatomic, assign) CGFloat WindowHeight;

@property (nonatomic, assign) CGFloat ImageHeight;

@property (nonatomic, assign) id<PPParallaxViewControllerDelegate> delegate;

- (id)initWithImage:(UIImage *)image;

- (id)initWithImage:(UIImage *)image withDelegate:(id<PPParallaxViewControllerDelegate> )delegete;

@end

@protocol PPParallaxViewControllerDelegate <UITableViewDataSource, UITableViewDelegate>

@optional
- (UIScrollView *)scrollViewForBackgroundView:(UIViewController *)ParallaxVC;

@end
