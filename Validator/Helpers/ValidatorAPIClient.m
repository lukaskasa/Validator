//
//  ValidatorAPIClient.m
//  Validator
//
//  Created by Lukas Kasakaitis on 12.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import "ValidatorAPIClient.h"

@interface ValidatorAPIClient()

@property ValidatedEmailAddress *internalValidatedEmailAddress;

@end

@implementation ValidatorAPIClient

static NSString *const baseURLString = @"https://www.validator.pizza/email/";

- (ValidatedEmailAddress *)validatedEmailAddress {
    return self.internalValidatedEmailAddress;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _internalValidatedEmailAddress = [[ValidatedEmailAddress alloc] init];
    }
    return self;
}

- (void)validateEmailAddress:(NSString *)email completion:(void (^)(NSError *error))completion {
    
    NSURL *url =  [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", baseURLString, email]];
    
    NSURLRequest * requestUrl = [[NSURLRequest alloc] initWithURL:url];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL: [requestUrl URL]
                                                        cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:10.0];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionDataTask *apiCallDataTask = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(error);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            completion(nil);
            return;
        }
        
        if (![json isKindOfClass:[NSDictionary class]]) {
            NSLog(@"JSON was not a dictionary as expected.");
            completion([[NSError alloc] init]);
        }
        
        ValidatedEmailAddress *validatedAddress = [[ValidatedEmailAddress alloc] initWithDictionary:json];
        
        self.internalValidatedEmailAddress = validatedAddress;
        completion(nil);
        
    }];
    
    [apiCallDataTask resume];
}


@end
