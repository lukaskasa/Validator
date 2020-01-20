//
//  ValidatedEmailAddress.h
//  Validator
//
//  Created by Lukas Kasakaitis on 12.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidatedEmailAddress : NSObject

@property NSNumber *status;
@property NSNumber *remainingRequests; // User defaults
@property NSString *emailAddress;
@property NSString *domain;
@property NSString *didYouMean;
@property BOOL alias;
@property BOOL mx;
@property BOOL disposable;

- (instancetype) initWithStatus:(NSNumber *)status remainingRequests:(NSNumber *)remainingRequests emailAddress:(NSString *)emailAddress domain:(NSString *)domain didYouMean:(NSString *)didYouMean alias:(BOOL)alias mx:(BOOL)mx disposable:(BOOL)disposable;
- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
