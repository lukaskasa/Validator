//
//  PreviewView.m
//  Validator
//
//  Created by Lukas Kasakaitis on 16.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

@import AVFoundation;

#import "PreviewView.h"

@implementation PreviewView

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureVideoPreviewLayer*) videoPreviewLayer {
    return (AVCaptureVideoPreviewLayer *)self.layer;
}

- (AVCaptureSession*) session {
    return self.videoPreviewLayer.session;
}

-(void)setSesssion:(AVCaptureSession *)sesssion {
    self.videoPreviewLayer.session = sesssion;
    self.videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
}

@end
