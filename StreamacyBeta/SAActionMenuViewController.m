//
//  SAActionMenuViewController.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SAActionMenuViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Helpers.h"

@interface SAActionMenuViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *coverArtImageView;
@property (strong, nonatomic) IBOutlet UILabel *trackTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernnameLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *playCountLabel;
@property (strong, nonatomic) IBOutlet UIView *trackInfoView;
- (IBAction)exitButtonPressed:(UIButton *)sender;
@end

@implementation SAActionMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIButton *button in self.view.subviews) {
        button.layer.borderColor = [UIColor colorWithRed:0.784 green:0.778 blue:0.801 alpha:1].CGColor;
    }
    
    self.trackInfoView.layer.borderColor = [UIColor colorWithRed:0.784 green:0.778 blue:0.801 alpha:1].CGColor;
    
    NSDictionary *track = self.track;
    //Populate the cell with the data recieved from the search.
    self.trackTitleLabel.text = track[@"title"];
    self.usernnameLabel.text = track[@"user"][@"username"];
    //Format the tracks duration into a string and set the label.
    int duration = [[track objectForKey:@"duration"]intValue];
    NSString *durationString = [Helpers timeFormatted:duration];
    self.durationLabel.text = durationString;
    NSString *urlString = track[@"artwork_url"];
    if (![urlString isEqual:[NSNull null]]) {
        NSString *highRes = [urlString stringByReplacingOccurrencesOfString:@"large" withString:@"crop"];
        NSURL *artURL = [NSURL URLWithString:highRes];
        [self.coverArtImageView sd_setImageWithURL:artURL];
    }
    else
    {
        [self.coverArtImageView setImage:[UIImage imageNamed:@"no-album-art.png"]];
    }
    
    NSNumber *playbackCount = track[@"playback_count"];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *playbackformatted = [formatter stringFromNumber:playbackCount];
    
    NSString *triangle = [NSString stringWithCString:"\u25BA" encoding:NSUTF8StringEncoding];
    self.playCountLabel.text = [NSString stringWithFormat:@"%@ %@", triangle, playbackformatted];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)exitButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
