//
//  VisionViewController.h
//  Validator
//
//  Created by Lukas Kasakaitis on 16.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Vision/Vision.h>
#import <AVFoundation/AVFoundation.h>

@protocol ResultReceiver;

@interface VisionViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic) VNRecognizeTextRequest *request;
@property (nonatomic) CAShapeLayer *maskLayer;
@property (nonatomic) NSString * resultEmailAddress;

@property (nonatomic, weak) id <ResultReceiver> resultReceiverDelegate;

@end
