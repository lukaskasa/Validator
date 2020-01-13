//
//  ValidatedEmailAddress.h
//  Validator
//
//  Created by Lukas Kasakaitis on 12.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidatedEmailAddress : NSObject

@property int status;
@property NSString * emailAddress;
@property NSString * domain;
@property BOOL mx;
@property BOOL disposable;
@property BOOL alias;

- (instancetype) initWithStatus:(int)status emailAddress:(NSString *)emailAddress domain:(NSString *)domain mx:(BOOL)mx disposable:(BOOL)disposable alias:(BOOL)alias;
- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

//@property id * didYouMean;
//@property NSInteger * remainingRequests;
//@property NSString * error;

@end
