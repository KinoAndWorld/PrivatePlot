//
//  PPImagePickerViewController.m
//  PrivatePlot
//
//  Created by Kino on 13-12-7.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import "PPImagePickerViewController.h"

#import "CameraCapture.h"

#import "UIImage+Resize.h"

@interface PPImagePickerViewController ()<CameraCaptureDelegate>

@property(retain,nonatomic) CameraCapture *cameraCapture;

@end

@implementation PPImagePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initCamera];
    
}

- (void)initCamera{
    _cameraCapture = [[CameraCapture alloc] init];
    [_cameraCapture setDelegate:self];
    [_cameraCapture startRunning];
    [_cameraCapture embedPreviewInView:self.cameraView];
    
    self.previewView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [_cameraCapture changePreviewOrientation:(UIInterfaceOrientation)toInterfaceOrientation];
}

#pragma mark - camera delegate

- (void)cameraCaptureDidFinishedCapture:(UIImage*)image{
    //image = [image resizedImage:CGSizeMake(image.size.width/3, image.size.height/3)
    //       interpolationQuality:kCGInterpolationHigh];
    
    CGSize newSize = CGSizeMake(self.previewView.frame.size.width*2,
                                self.previewView.frame.size.height*2);
    
    UIImage *newImage = [image getImageFillSize:newSize];
    
    self.previewView.image = newImage;
    NSLog(@"%f,%f",newImage.size.height,newImage.size.width);
}

- (void)cameraCaptureFoucusStatus:(BOOL)isadjusting{
    
}

- (IBAction)takePhoto:(id)sender {
    [_cameraCapture captureStillImage];
}
@end
