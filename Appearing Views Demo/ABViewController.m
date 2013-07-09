//
//  ABViewController.m
//  Appearing Views Demo
//
//  Created by Adam Barrett on 2013-07-02.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import "ABViewController.h"

@interface ABViewController ()

@property (weak, nonatomic) IBOutlet ABAppearingView *mainTitle;
@property (weak, nonatomic) IBOutlet ABAppearingView *topBanner;

@end

@implementation ABViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainTitle.animationDuration = 1;
    self.mainTitle.animationType = AnimationTypeFade;
    self.mainTitle.delegate = self;
    
    self.topBanner.animationDuration = 0.5;
    self.topBanner.animationType = AnimationTypeSlideTop;
    self.topBanner.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.mainTitle appear];
}

#pragma mark - ABAppearingViewDelegate
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMainTitle:nil];
    [self setTopBanner:nil];
    [super viewDidUnload];
}

- (BOOL)appearingView:(ABAppearingView *)view
    willAppearToFrame:(CGRect)frame
        animationType:(AnimationType)type
             duration:(NSTimeInterval)duration
              options:(UIViewAnimationOptions)options
{
    NSLog(@"View will appear");
    return YES;
}

- (void)appearingViewDidAppear:(ABAppearingView *)view
{
    NSLog(@"%@ did appear", view);
    if (view == self.mainTitle) {
        [self.topBanner appear];
        [self.mainTitle performSelector:@selector(disappear) withObject:nil afterDelay:1];
    }
    
    if (view == self.topBanner) {
        NSLog(@"NOW WHAT?");
    }
}

- (BOOL)appearingView:(ABAppearingView *)view
willDisappearFromFrame:(CGRect)frame
        animationType:(AnimationType)type
             duration:(NSTimeInterval)duration
              options:(UIViewAnimationOptions)options
{
    NSLog(@"View will disappear");
    return YES;
}

- (void)appearingViewDidDisappear:(ABAppearingView *)view
{
    NSLog(@"View did disappear");
}

#pragma mark - Actions
- (IBAction)dismissTopBanner:(id)sender {
    [self.topBanner disappear];
}
 
@end
