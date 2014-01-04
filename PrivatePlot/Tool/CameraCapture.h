//
//  CameraCapture.h
//  PrivatePlot
//
//  Created by Kino on 13-12-19.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol CameraCaptureDelegate;

@interface CameraCapture : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (retain) AVCaptureSession *session;
@property (retain) AVCaptureStillImageOutput *captureOutput;
@property (retain) UIImage *image;
@property (assign) UIImageOrientation g_orientation;
@property (assign) AVCaptureVideoPreviewLayer *preview;
@property (assign,setter = setDelegate:) id<CameraCaptureDelegate>delegate;

- (void)startRunning;

- (void)stopRunning;

- (void)captureStillImage;

- (void)embedPreviewInView: (UIView *) aView;

- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation;


@end

@protocol CameraCaptureDelegate <NSObject>

- (void)cameraCaptureDidFinishedCapture:(UIImage*)image;
- (void)cameraCaptureFoucusStatus:(BOOL)isadjusting;

@end