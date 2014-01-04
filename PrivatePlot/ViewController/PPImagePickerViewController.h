//
//  PPImagePickerViewController.h
//  PrivatePlot
//
//  Created by Kino on 13-12-7.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ImagePickerDelegate;

@interface PPImagePickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *previewView;
@property (weak, nonatomic) IBOutlet UIView *cameraView;

@property (assign, nonatomic) id<ImagePickerDelegate> delegate;
- (IBAction)takePhoto:(id)sender;

@end

@protocol ImagePickerDelegate <NSObject>
/**
 *  回调 获取的图片
 *
 *  @param imagePickerVC
 *  @param image
 */
- (void)imagePickerDidCapture:(PPImagePickerViewController *)imagePickerVC withImage:(UIImage *)image;

@end