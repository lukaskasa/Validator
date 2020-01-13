//
//  ViewController.h
//  Validator
//
//  Created by Lukas Kasakaitis on 10.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValidatorAPIClient.h"

@interface CheckViewController : UIViewController

@property (nonatomic) ValidatorAPIClient * validatorApiClient;

@end

