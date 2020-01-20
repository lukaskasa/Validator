//
//  VerifiedTableViewController.h
//  Validator
//
//  Created by Lukas Kasakaitis on 11.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface VerifiedTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

