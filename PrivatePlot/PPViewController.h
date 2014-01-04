//
//  PPViewController.h
//  PrivatePlot
//
//  Created by Kino on 13-12-6.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *topContentView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UIButton *faceButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;

- (IBAction)presentSettingVC:(id)sender;

@end
