//
//  ValidatedEmailAddress.h
//  Validator
//
//  Created by Lukas Kasakaitis on 12.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidatedEmailAddress : NSObject

@property NSString * emailAddress;
@property NSString * user;
@property NSString * domain;
@property NSString * status;
@property NSString * reason;
@property BOOL disposable;

- (instancetype) initWithEmail:(NSString *)emailAddress user:(NSString *)user domain:(NSString *)domain status:(NSString *)status reason:(NSString *)reason disposable:(BOOL)disposable;
- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
