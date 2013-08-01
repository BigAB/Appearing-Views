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

@property (weak, nonatomic) IBOutlet UIButton *pressMe;
@property (nonatomic, assign) CGFloat pressMeX;

@property (nonatomic, strong) ABAppearingView *happySun;
@property (nonatomic, strong) ABAppearingView *grass;
@property (nonatomic, strong) ABAppearingView *moon;

@end

@implementation ABViewController

#pragma mark - Property Accessors
- (ABAppearingView *)happySun
{
    if (!_happySun) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"Happy"];
        _happySun = vc.view.subviews[0];
        _happySun.animationDuration = 0.5;
        _happySun.animationType = AnimationTypeSlideRight;
        _happySun.animationOptions = UIViewAnimationOptionBeginFromCurrentState;
        _happySun.delegate = self;
        
        __weak typeof(self) _self = self;
        _happySun.viewWillAppearWithAnimationCallback = ^(UIView *view, NSDictionary *animationInfo) {
            [_self.moon disappear];
        };
        _happySun.viewDidDisappearWithAnimationCallback = ^(UIView *view, NSDictionary *animationInfo) {
            [_self.moon appear];
        };
        
        [self.view addSubview:_happySun];
    }
    return _happySun;
}

- (ABAppearingView *)grass
{
    if (!_grass) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"Happy"];
        _grass = vc.view.subviews[1];
        _grass.animationDuration = 2.5;
        _grass.animationType = AnimationTypeSlideBottom;
        _grass.animationOptions = UIViewAnimationOptionAllowUserInteraction;
        _grass.delegate = self;
        [self.view addSubview:_grass];
    }
    return _grass;
}

- (ABAppearingView *)moon
{
    if (!_moon) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"Happy"];
        _moon = vc.view.subviews[2];
        _moon.animationDuration = 4.5;
        _moon.animationType = AnimationTypeFade;
        //_moon.animationOptions = UIViewAnimationOptionAllowUserInteraction;
        _moon.delegate = self;
        [self.view addSubview:_moon];
    }
    return _moon;
}

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainTitle.animationDuration = 0.5;
    self.mainTitle.animationType = AnimationTypeSpin;
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
    [self.happySun appear];
    NSLog(@"happySun COME!");
}

- (void)dismissHappySquare
{
    [self.happySun disappear];
    NSLog(@"happySun GO AWAY!");
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
    [self setPressMe:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(ABAppearingView *)view
         withAnimation:(AnimationType)type
               toFrame:(CGRect)frame
              duration:(NSTimeInterval)duration
               options:(UIViewAnimationOptions)options
{
    if (view == self.happySun) {
        __block ABViewController *_self = self;
        UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState;
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            CGRect f = _self.pressMe.frame;
            self.pressMeX = f.origin.x;
            _self.pressMe.frame = CGRectMake(30, f.origin.y, f.size.width, f.size.height);
        } completion:nil];
    }
}

- (void)viewDidAppear:(ABAppearingView *)view withAnimation:(AnimationType)type
{
    if (view == self.mainTitle) {
        [self.topBanner appear];
        [self.mainTitle performSelector:@selector(disappear) withObject:nil afterDelay:1];
    }
    
    if (view == self.happySun) {
        __block ABViewController *_self = self;
        UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState;
        [UIView animateWithDuration:3 delay:0 options:options animations:^{
            _self.view.backgroundColor = [UIColor colorWithHue:134.0/360.0 saturation:0.16 brightness:0.98 alpha:1];
        } completion:nil];
        
        [self.grass performSelector:@selector(appear) withObject:nil afterDelay:1];
    }
    
}

- (void)viewWillDisappear:(ABAppearingView *)view
            withAnimation:(AnimationType)type
                fromFrame:(CGRect)frame
                 duration:(NSTimeInterval)duration
                  options:(UIViewAnimationOptions)options
{
    if (view == self.happySun) {
        __block ABViewController *_self = self;
        UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState;
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            CGRect f = _self.pressMe.frame;
            _self.pressMe.frame = CGRectMake(self.pressMeX, f.origin.y, f.size.width, f.size.height);
        } completion:nil];
    }
}

- (void)viewDidDisappear:(ABAppearingView *)view withAnimation:(AnimationType)type
{
    if (view == self.happySun) {
        __block ABViewController *_self = self;
        UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState;
        [UIView animateWithDuration:3 delay:0 options:options animations:^{
            _self.view.backgroundColor = [UIColor colorWithHue:242.0/360.0 saturation:0.07 brightness:0.88 alpha:1];
        } completion:nil];
    }
}

#pragma mark - Actions
- (IBAction)dismissTopBanner:(id)sender {
    if (self.happySun.hidden) {
        [self getHappySquare];
    } else {
        [self dismissHappySquare];
    }
}
 
@end
