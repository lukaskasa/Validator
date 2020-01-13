//
//  ViewController.m
//  Validator
//
//  Created by Lukas Kasakaitis on 10.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import "CheckViewController.h"

@interface CheckViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextfield;

@property (weak, nonatomic) IBOutlet UILabel *disposableLabel;
@property (weak, nonatomic) IBOutlet UILabel *mxLabel;
@property (weak, nonatomic) IBOutlet UILabel *aliasLabel;

@property (weak, nonatomic) IBOutlet UIImageView *disposableImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mxImageView;
@property (weak, nonatomic) IBOutlet UIImageView *aliasImageView;

@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;

@end

@implementation CheckViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _validatorApiClient = [[ValidatorAPIClient alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
}

- (IBAction)validateEmailAddress:(UIButton *)sender {
    
    NSLog(@"Validating E-mail Addresses...");
    NSLog(@"E-Mail Address: %@", self.emailAddressTextfield.text);
    
    // 1. Call to Validating API endpoint https://www.validator.pizza
    
    NSString *textFieldText = self.emailAddressTextfield.text;
    
    [self.validatorApiClient validateEmailAddress:textFieldText completion:^(NSError *error) {
        
        if (error) {
            NSLog(@"Error");
            return;
        }
        
        int statusCode = self.validatorApiClient.validatedEmailAddress.status;
        NSString *address = self.validatorApiClient.validatedEmailAddress.emailAddress;
        NSString * domain = self.validatorApiClient.validatedEmailAddress.domain;
        
        BOOL mx = self.validatorApiClient.validatedEmailAddress.mx;
        BOOL disposable = self.validatorApiClient.validatedEmailAddress.disposable;
        BOOL alias = self.validatorApiClient.validatedEmailAddress.alias;
        
        
        if (statusCode != 200) {

            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertWith:@"This is not a valid email address!"];
                [self setUpUI];
            });
            
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImageViews: self.validatorApiClient.validatedEmailAddress];
        });
        
        NSLog(@"Status code: %i", statusCode);
        NSLog(@"E-mail Address: %@", address);
        NSLog(@"Domain: %@", domain);
        
        NSLog(@"MX: %s", mx ? "true" : "false");
        NSLog(@"Disposable: %s", disposable ? "true" : "false");
        NSLog(@"Alias: %s", alias ? "true" : "false");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view endEditing:YES];
        });
        
    }];
    
    // 2. Save to CoreData
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)setImageViews:(ValidatedEmailAddress *)validatedAddress {
    
    UIImage * checkImage = [[UIImage imageNamed:@"icon-checkmark"] init];
    UIImage * crossImage = [[UIImage imageNamed:@"icon-cross"] init];
    
    [self.disposableLabel setHidden:NO];
    [self.mxLabel setHidden:NO];
    [self.aliasLabel setHidden:NO];
    
    self.disposableImageView.image = validatedAddress.disposable ? checkImage : crossImage;
    self.mxImageView.image = validatedAddress.mx ? checkImage : crossImage;
    self.aliasImageView.image = validatedAddress.alias ? checkImage : crossImage;
    
}

-(void)setUpUI {
    [self.disposableLabel setHidden:YES];
    [self.mxLabel setHidden:YES];
    [self.aliasLabel setHidden:YES];
    
    self.disposableImageView.image = [[UIImage alloc] init];
    self.mxImageView.image = [[UIImage alloc] init];
    self.aliasImageView.image = [[UIImage alloc] init];
    
    self.messageTextLabel.text = @"";
}

-(void)showAlertWith:(NSString *)message {
    
    // 1. Create UIAlertController
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 2. Create and add a default action to dismiss alert
    
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    
    // 3. Present the Alert
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
