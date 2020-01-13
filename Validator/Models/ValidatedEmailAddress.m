//
//  ValidatedEmailAddress.m
//  Validator
//
//  Created by Lukas Kasakaitis on 12.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import "ValidatedEmailAddress.h"

@implementation ValidatedEmailAddress

- (instancetype) initWithStatus:(int)status emailAddress:(NSString *)emailAddress domain:(NSString *)domain mx:(BOOL)mx disposable:(BOOL)disposable alias:(BOOL)alias {
    if (self = [super init]) {
        _status = status;
        _emailAddress = emailAddress;
        _domain = domain;
        _mx = mx;
        _disposable = disposable;
        _alias = alias;
    }
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    int status = [dictionary[@"status"] intValue];
    NSString * emailAddress = dictionary[@"email"];
    NSString * domain = dictionary[@"domain"];
    
    BOOL mx = [[dictionary objectForKey:@"mx"] integerValue] == 1 ? YES : NO;
    BOOL disposable = [[dictionary objectForKey:@"disposable"] integerValue]  == 1 ? YES : NO;
    BOOL alias = [[dictionary objectForKey:@"alias"] integerValue] == 1 ? YES : NO;
    
    return [self initWithStatus:status
            emailAddress:emailAddress
                     domain:domain
                             mx:mx
                     disposable:disposable
                          alias:alias];
}

@end
