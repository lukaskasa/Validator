//
//  ValidatedEmailAddress.m
//  Validator
//
//  Created by Lukas Kasakaitis on 12.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import "ValidatedEmailAddress.h"

@implementation ValidatedEmailAddress

- (instancetype) initWithEmail:(NSString *)emailAddress user:(NSString *)user domain:(NSString *)domain status:(NSString *)status reason:(NSString *)reason disposable:(BOOL)disposable; {
    
    self =  [super init];
    
    if (self) {
        _emailAddress = emailAddress;
        _user = user;
        _domain = domain;
        _status = status;
        _reason = reason;
        _disposable = disposable;
    }
    
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    NSString * emailAddress = dictionary[@"email"];
    NSString * user = dictionary[@"user"];
    NSString * domain = dictionary[@"domain"];
    NSString * status = dictionary[@"status"];
    NSString * reason = dictionary[@"reason"];
    
    BOOL disposable = [[dictionary objectForKey:@"disposable"] integerValue]  == 1 ? YES : NO;
    
    return [self initWithEmail:emailAddress
                          user:user
                        domain:domain
                        status:status
                        reason:reason
                    disposable:disposable
            ];
}

@end
