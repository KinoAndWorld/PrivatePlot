//
//  CameraCapture.m
//  PrivatePlot
//
//  Created by Kino on 13-12-19.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import "CameraCapture.h"
#import <ImageIO/ImageIO.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

@interface CameraCapture()
@property (nonatomic, assign) BOOL adjustingFocus;

@end

@implementation CameraCapture


#pragma mark - 初始化
/**
 *  初始化
 */
- (void) initialize
{
    //1.创建会话层
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    
    //2.创建、配置输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
#if 1
    int flags = NSKeyValueObservingOptionNew; //监听自动对焦
    [device addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
#endif
    
	NSError *error;
	AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!captureInput)
	{
		NSLog(@"Error: %@", error);
		return;
	}
    [self.session addInput:captureInput];
    
    
    //3.创建、配置输出
    _captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [_captureOutput setOutputSettings:outputSettings];
    
	[self.session addOutput:_captureOutput];
}

- (id) init
{
	if (self = [super init])
        [self initialize];
	return self;
}

/**
 *  对焦监听
 *
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if( [keyPath isEqualToString:@"adjustingFocus"] ){
        _adjustingFocus = [ [change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1] ];
        NSLog(@"Is adjusting focus? %@", _adjustingFocus ? @"YES" : @"NO" );
        NSLog(@"Change dictionary: %@", change);
        if (_delegate && [_delegate respondsToSelector:@selector(cameraCaptureFoucusStatus:)]) {
            [_delegate cameraCaptureFoucusStatus:_adjustingFocus];
        }
    }
}

- (void) dealloc
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device removeObserver:self forKeyPath:@"adjustingFocus"];
    
	self.session = nil;
	self.image = nil;
}

#pragma mark - 

/**
 *  开始运行  不停取景
 */
- (void)startRunning{
    [[self session] startRunning];
}

/**
 *  暂停取景
 */
- (void)stopRunning{
    [[self session] stopRunning];
}

/**
 *  拍照
 */
- (void)captureImage{
    //get connection
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    //get UIImage
    [_captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         CFDictionaryRef exifAttachments =
         CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             // Do something with the attachments.
         }
         
         // Continue as appropriate.
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *t_image = [UIImage imageWithData:imageData];
         _image = [[UIImage alloc]initWithCGImage:t_image.CGImage scale:1.0 orientation:_g_orientation];
         
         [self giveImg2Delegate];
     }];
}

-(void)captureStillImage{
    [self captureImage];
//    while (true) {
//        if (_adjustingFocus) {
//            
//            break;
//        }
//    }
}


/**
 *  设置取景的View
 *
 *  @param aView 显示相机数据的view
 */
- (void)embedPreviewInView: (UIView *) aView{
    if (!_session) return;
    //设置取景
    _preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    _preview.frame = aView.bounds;
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _g_orientation = UIImageOrientationRight;
    _preview.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    [aView.layer addSublayer: _preview];
}

- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (!_preview) {
        return;
    }
    [CATransaction begin];
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        _g_orientation = UIImageOrientationUp;
        _preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        
    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        _g_orientation = UIImageOrientationDown;
        _preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        
    }else if (interfaceOrientation == UIDeviceOrientationPortrait){
        _g_orientation = UIImageOrientationRight;
        _preview.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
    }else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown){
        _g_orientation = UIImageOrientationLeft;
        _preview.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
    }
    [CATransaction commit];
}

#pragma mark - 照片传输

- (void)giveImg2Delegate{
    if (_delegate && [_delegate respondsToSelector:@selector(cameraCaptureDidFinishedCapture:)]) {
        [_delegate cameraCaptureDidFinishedCapture:_image];
    }
}


@end
