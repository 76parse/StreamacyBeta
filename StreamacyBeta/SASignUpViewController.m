//
//  SASignUpViewController.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/21/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SASignUpViewController.h"
#import <Parse/Parse.h>

@interface SASignUpViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *retypePasswordTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *currentTextField;
@property (nonatomic, assign) CGFloat lastContentOffset;
@end

@implementation SASignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.layer.borderColor = [UIColor colorWithRed:0.784 green:0.778 blue:0.801 alpha:1].CGColor;
    self.scrollView.delegate = self;
    
    NSMutableArray *textFields = [[NSMutableArray alloc]init];
    [textFields addObject:self.usernameTextField];
    [textFields addObject:self.nameTextField];
    [textFields addObject:self.passwordTextField];
    [textFields addObject:self.retypePasswordTextField];
    
    UIToolbar* SignUpToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [SignUpToolBar setBarTintColor:[UIColor colorWithRed:0.539 green:0.467 blue:0.906 alpha:1]];
    UIBarButtonItem *joinButton = [[UIBarButtonItem alloc]initWithTitle:@"Sign Up" style:UIBarButtonItemStyleDone target:self action:@selector(signUpButtonPressed)];
    joinButton.tintColor = [UIColor whiteColor];
    SignUpToolBar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           joinButton, [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           nil];
    [SignUpToolBar sizeToFit];
    
    for (UITextField *textField in textFields) {
        textField.delegate = self;
        [textField setInputAccessoryView:SignUpToolBar];
    }
}

-(void)signUpButtonPressed
{
    NSString *username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *retypePassword = [self.retypePasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (![password isEqualToString:retypePassword]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Your password does not match the check." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
        
        self.passwordTextField.text = nil;
        self.retypePasswordTextField.text = nil;
    }
    
    else if ([username length] == 0 || [password length] == 0 || [retypePassword length] == 0 || [name length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"All text fields must be completed." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        PFUser *user = [PFUser user];
        user.username = username;
        user.password = password;
        user[@"name"] = name;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
               
                UIViewController *tabBar = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
                [self presentViewController:tabBar animated:NO completion:^{
                    //completion
                }];
                
                NSLog(@"User has signed up for an account");
            }
            else
            {
                NSLog(@"Error:%@", error);
            }
        }];
    }
    

}

#pragma mark - Scroll View Delegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.lastContentOffset > scrollView.contentOffset.y)
        [self.currentTextField resignFirstResponder];
    self.lastContentOffset = scrollView.contentOffset.y;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
}

@end
