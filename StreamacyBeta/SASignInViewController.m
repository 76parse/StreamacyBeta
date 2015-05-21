//
//  SASignInViewController.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/21/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SASignInViewController.h"
#import <Parse/Parse.h>

@interface SASignInViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *currentTextField;
@property (nonatomic, assign) CGFloat lastContentOffset;
@end

@implementation SASignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    
    NSMutableArray *textFields = [[NSMutableArray alloc]init];
    [textFields addObject:self.usernameTextField];
    [textFields addObject:self.passwordTextField];
    
    
    self.navigationItem.title = @"Sign In";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    UIToolbar* SignUpToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [SignUpToolBar setBarTintColor:[UIColor colorWithRed:0.539 green:0.467 blue:0.906 alpha:1]];
    UIBarButtonItem *joinButton = [[UIBarButtonItem alloc]initWithTitle:@"Sign In" style:UIBarButtonItemStyleDone target:self action:@selector(signInButtonPressed)];
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

-(void)signInButtonPressed
{
    NSString *username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    
    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Both text fields must be filled" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        PFUser *user = [PFUser user];
        user.username = username;
        user.password = password;
        
        [PFUser logInWithUsernameInBackground:user.username password:user.password block:^(PFUser *user, NSError *error) {
            if (user) {
                NSLog(@"Signed in");
                UIViewController *tabBar = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
                [self presentViewController:tabBar animated:NO completion:^{
                    //completion
                }];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Incorrect username or password." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [alert show];
            }
            
        }];
    }
    [self.view endEditing:YES];
    self.usernameTextField.text = nil;
    self.passwordTextField.text = nil;

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
