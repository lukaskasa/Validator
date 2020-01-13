//
//  ValidatorAPIClient.h
//  Validator
//
//  Created by Lukas Kasakaitis on 12.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValidatedEmailAddress.h"

@interface ValidatorAPIClient : NSObject

@property (nonatomic) ValidatedEmailAddress * validatedEmailAddress;

- (void)validateEmailAddress:(NSString *)email completion:(void (^)(NSError *error))completion;
//- (void) queryResponseForURL: (NSURL *)inURL;
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

@end
