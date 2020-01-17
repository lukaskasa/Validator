//
//  PreviewView.h
//  Validator
//
//  Created by Lukas Kasakaitis on 16.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

@import UIKit;

@class AVCaptureSession;

@interface PreviewView : UIView

@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic) AVCaptureSession *sesssion;

@end
