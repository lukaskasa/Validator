//
//  AppDelegate.h
//  Validator
//
//  Created by Lukas Kasakaitis on 10.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

// Properties
@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

// Methods
- (void) saveContext;

@end

