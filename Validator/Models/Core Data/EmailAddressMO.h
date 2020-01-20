//
//  EmailAddressMO.h
//  Validator
//
//  Created by Lukas Kasakaitis on 18.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface EmailAddressMO : NSManagedObject

@property (nullable, nonatomic, copy) NSString *address;
@property (nonatomic) BOOL isDisposable;
@property (nonatomic) BOOL isMx;
@property (nonatomic) BOOL isAlias;

@end
