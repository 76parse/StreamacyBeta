//
//  SAActionMenuViewController.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SAActionMenuViewController.h"

@interface SAActionMenuViewController ()
@property (strong, nonatomic) IBOutlet UILabel *label;
- (IBAction)exitButtonPressed:(UIButton *)sender;
@end

@implementation SAActionMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.label.text = self.labelText;

}

- (IBAction)exitButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:^{
        //completion
    }];
}
@end
