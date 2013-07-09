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

@property (nonatomic, strong) ABAppearingView *happyView;

@end

@implementation ABViewController

#pragma mark - Property Accessors
- (ABAppearingView *)happyView
{
    if (!_happyView) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"Happy"];
        _happyView = vc.view.subviews[0];
        _happyView.animationDuration = 0.5;
        _happyView.animationType = AnimationTypeSlideRight;
        _happyView.animationOptions = UIViewAnimationOptionBeginFromCurrentState;
        _happyView.delegate = self;
        [self.view addSubview:_happyView];
    }
    return _happyView;
}

#pragma mark - LifeCycle
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

- (void)getHappySquare
{
    [self.happyView appear];
    NSLog(@"HappyView COME!");
}

- (void)dismissHappySquare
{
    [self.happyView disappear];
    NSLog(@"HappyView GO AWAY!");
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
    if (view == self.happyView) {
        __block ABViewController *_self = self;
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            CGRect f = _self.topBanner.frame;
            CGFloat squishedWidth = f.size.width - _self.happyView.frame.size.width;
            _self.topBanner.frame = CGRectMake(f.origin.x-10, f.origin.y, squishedWidth, f.size.height);
        } completion:nil];
    }
    
    return YES;
}

- (void)appearingViewDidAppear:(ABAppearingView *)view
{
    //NSLog(@"%@ did appear", view);
    if (view == self.mainTitle) {
        [self.topBanner appear];
        [self.mainTitle performSelector:@selector(disappear) withObject:nil afterDelay:1];
    }
    
    if (view == self.topBanner) {
        //NSLog(@"NOW WHAT?");
    }
    
}

- (BOOL)appearingView:(ABAppearingView *)view
willDisappearFromFrame:(CGRect)frame
        animationType:(AnimationType)type
             duration:(NSTimeInterval)duration
              options:(UIViewAnimationOptions)options
{
    if (view == self.happyView) {
        __block ABViewController *_self = self;
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            CGRect f = _self.topBanner.frame;
            _self.topBanner.frame = CGRectMake(0, f.origin.y, self.view.bounds.size.width, f.size.height);
        } completion:nil];
    }
    
    return YES;
}

- (void)appearingViewDidDisappear:(ABAppearingView *)view
{
    //NSLog(@"View did disappear");
}

#pragma mark - Actions
- (IBAction)dismissTopBanner:(id)sender {
    if (self.happyView.hidden) {
        [self getHappySquare];
    } else {
        [self dismissHappySquare];
    }
}
 
@end
