//
//  ViewController.m
//  Validator
//
//  Created by Lukas Kasakaitis on 10.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import "CheckViewController.h"
#import "ValidatorAPIClient.h"
#import <Vision/Vision.h>

@interface CheckViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextfield;

@property (weak, nonatomic) IBOutlet UILabel *disposableLabel;
@property (weak, nonatomic) IBOutlet UILabel *mxLabel;
@property (weak, nonatomic) IBOutlet UILabel *aliasLabel;

@property (weak, nonatomic) IBOutlet UIImageView *disposableImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mxImageView;
@property (weak, nonatomic) IBOutlet UIImageView *aliasImageView;

@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;

// Core Data
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) AppDelegate *delegate;


@end

@implementation CheckViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _validatorApiClient = [[ValidatorAPIClient alloc] init];
        _delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = self.delegate.persistentContainer.viewContext;
    }
    return self;
}

#pragma mark View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup
    [self setUpUI];
}

#pragma mark Actions

- (IBAction)validateEmailAddress:(UIButton *)sender {
    
    // 1. Call to endpoint https://www.validator.pizza/email
    
    NSError *regexError = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([a-zA-Z0-9_\\-\\.]+@)([a-zA-Z0-9_\\-\\.]+\\.)([a-zA-Z]{2,5})" options:NSRegularExpressionCaseInsensitive error:&regexError];
    NSTextCheckingResult *match = [regex firstMatchInString:self.emailAddressTextfield.text options:0 range: NSMakeRange(0, [self.emailAddressTextfield.text length])];
    
    if (match) {
        
        [self.validatorApiClient validateEmailAddress:self.emailAddressTextfield.text completion:^(NSError *error) {
            
            if (error) {
                NSLog(@"Error");
                return;
            }
            
            NSNumber *remainingRequests = self.validatorApiClient.validatedEmailAddress.remainingRequests;
            
            [[NSUserDefaults standardUserDefaults] setObject:remainingRequests forKey:@"remainingRequests"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (error) {
                    [self showAlertWithTitle: @"Error" message:[error localizedDescription]];
                } else {
                    [self setImageViews: self.validatorApiClient.validatedEmailAddress];
                    
                    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"remainingRequests"] integerValue] == 10) {
                        [self showAlertWithTitle: @"Info" message:[NSString stringWithFormat:@"You have %@ checks remaining!", [[NSUserDefaults standardUserDefaults] stringForKey:@"remainingRequests"]]];
                    }
                }
                
            });
            
            // 2. Save to CoreData
            
            if (error == NULL) {
                [self saveEmailAddress:self.validatorApiClient.validatedEmailAddress];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view endEditing:YES];
            });
            
        }];
    } else {
        [self showAlertWithTitle: @"Validator" message:@"Please enter an E-mail address."];
    }
    
}

- (IBAction)scanForEmailAddress:(UIButton *)sender {
    [self performSegueWithIdentifier:@"showVisionViewController" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showVisionViewController"]) {
        VisionViewController * visionViewController = [segue destinationViewController];
        visionViewController.resultReceiverDelegate = self;
    }
}

#pragma mark Helper methods

- (void) passResult:(NSString *)result {
    [self.emailAddressTextfield setText:result];
}

- (void) saveEmailAddress:(ValidatedEmailAddress *)address {
    EmailAddressMO *newAddress = [[EmailAddressMO alloc] initWithContext:self.managedObjectContext];
    
    newAddress.address = address.emailAddress;
    newAddress.isDisposable = address.disposable;
    newAddress.isMx = address.mx;
    newAddress.isAlias = address.alias;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"An error occured: %@", error);
    }}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)setImageViews:(ValidatedEmailAddress *)validatedAddress {
    
    UIImage * checkImage = [[UIImage imageNamed:@"icon-checkmark"] init];
    UIImage * crossImage = [[UIImage imageNamed:@"icon-cross"] init];
    
    [self.disposableLabel setHidden:NO];
    [self.mxLabel setHidden:NO];
    [self.aliasLabel setHidden:NO];
    
    NSString *messageIfInvalid = @"This E-mail address is invalid."; // !mx && !disposable && !alias
    NSString *messageIfValid = @"This E-mail address is not disposable and probably exists!"; // !disposable && mx && !alias
    NSString *messageIfDisposable = @"This E-mail address is disposable!"; // dsposable
    NSString *messageIfAlias = @"This E-mail address is an alias."; // alias
    
    if (validatedAddress.disposable) {
        self.messageTextLabel.text = messageIfDisposable;
    } else if (validatedAddress.alias) {
        self.messageTextLabel.text = messageIfAlias;
    } else if (!validatedAddress.disposable && !validatedAddress.mx && !validatedAddress.alias) {
        self.messageTextLabel.text = messageIfInvalid;
    } else if (!validatedAddress.disposable && validatedAddress.mx && !validatedAddress.alias) {
        self.messageTextLabel.text = messageIfValid;
    }
    
    [self.messageTextLabel setHidden:NO];
    
    self.disposableImageView.image = validatedAddress.disposable ? checkImage : crossImage;
    self.mxImageView.image = validatedAddress.mx ? checkImage : crossImage;
    self.aliasImageView.image = validatedAddress.alias ? checkImage : crossImage;
}

-(void)setUpUI {
    [self.disposableLabel setHidden:YES];
    [self.mxLabel setHidden:YES];
    [self.aliasLabel setHidden:YES];
    [self.messageTextLabel  setHidden:YES];
    
    self.disposableImageView.image = [[UIImage alloc] init];
    self.mxImageView.image = [[UIImage alloc] init];
    self.aliasImageView.image = [[UIImage alloc] init];
}

/// Create and present a simple alert with a specified title and message
-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


@end
