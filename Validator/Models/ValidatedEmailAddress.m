//
//  ValidatedEmailAddress.m
//  Validator
//
//  Created by Lukas Kasakaitis on 12.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import "ValidatedEmailAddress.h"

@implementation ValidatedEmailAddress

- (instancetype) initWithStatus:(NSNumber *)status remainingRequests:(NSNumber *)remainingRequests emailAddress:(NSString *)emailAddress domain:(NSString *)domain didYouMean:(NSString *)didYouMean alias:(BOOL)alias mx:(BOOL)mx disposable:(BOOL)disposable {
    
    self =  [super init];
    
    if (self) {
        _status = status;
        _emailAddress = emailAddress;
        _domain = domain;
        _didYouMean = didYouMean;
        _remainingRequests = remainingRequests;
        _alias = alias;
        _mx = mx;
        _disposable = disposable;
    }
    
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    NSNumber *status = dictionary[@"status"];
    NSNumber *remainingRequests = dictionary[@"remaining_requests"];
    NSString *emailAddress = dictionary[@"email"];
    NSString *domain = dictionary[@"domain"];
    NSString *didYouMean = dictionary[@"did_you_mean"];
    BOOL mx = [[dictionary objectForKey:@"mx"] integerValue] == 1 ? YES : NO;
    BOOL disposable = [[dictionary objectForKey:@"disposable"] integerValue]  == 1 ? YES : NO;
    BOOL alias = [[dictionary objectForKey:@"alias"] integerValue] == 1 ? YES : NO;
    
    return [self initWithStatus:status
              remainingRequests:remainingRequests
                   emailAddress:emailAddress
                        domain:domain
                        didYouMean:didYouMean
                          alias:alias
                             mx:mx
                    disposable:disposable
            ];
}

@end
