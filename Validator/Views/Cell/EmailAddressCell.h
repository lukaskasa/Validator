//
//  EmailAddressCell.h
//  Validator
//
//  Created by Lukas Kasakaitis on 11.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *emailAddress;
@property (weak, nonatomic) IBOutlet UIImageView *disposableCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mxCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *aliasCheckImageView;

@end

