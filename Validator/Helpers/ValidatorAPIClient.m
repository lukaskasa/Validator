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
    
    // 1. Check Domain
    
    NSString *urlWithAddress = [NSString stringWithFormat:@"%@%@", baseURLString, email];
    
    NSURL *requestUrl = [NSURL URLWithString:urlWithAddress];
    
    NSURLSessionDataTask *dataTask = [NSURLSession.sharedSession dataTaskWithURL:requestUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        /// Test if domain is valid
        
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
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"https://%@", validatedAddress.domain]]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request setHTTPMethod:@"GET"];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSUInteger respCode=[(NSHTTPURLResponse  *)response statusCode];
            
            if ( !error&&respCode == 200 ) {
                self.internalValidatedEmailAddress = validatedAddress;
                completion(nil);
            } else {
                ValidatedEmailAddress * address = [[ValidatedEmailAddress alloc] initWithStatus:(int)respCode emailAddress:nil domain:nil mx:nil disposable:nil alias:nil];
                self.internalValidatedEmailAddress = address;
                completion(nil);
            }
            
        }];
        
        [postDataTask resume];
        
    }];
    
    [dataTask resume];
}


@end
