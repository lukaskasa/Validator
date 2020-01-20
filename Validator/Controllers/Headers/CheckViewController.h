//
//  ViewController.h
//  Validator
//
//  Created by Lukas Kasakaitis on 10.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "EmailAddressMO.h"
#import "VisionViewController.h"
#import "ValidatorAPIClient.h"

@protocol ResultReceiver <NSObject>
@required
- (void)passResult:(NSString *)result;
@end

@interface CheckViewController : UIViewController <ResultReceiver>

// Properties
@property (nonatomic) ValidatorAPIClient * validatorApiClient;
@property (nonatomic) AVCaptureSession *captureSession;

@end



