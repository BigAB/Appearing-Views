//
//  ABAppearingView.h
//  Appearing Views Demo
//
//  Created by Adam Barrett on 2013-07-02.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//
#define AppearingViewWillAppear @"ABAppearingViewWillAppear"
#define AppearingViewDidAppear @"ABAppearingDidWillAppear"
#define AppearingViewWillDisappear @"ABAppearingViewWillDisappear"
#define AppearingViewDidDisappear @"ABAppearingViewDidDisappear"

#define AppearingViewViewKey      @"view"
#define AppearingViewFrameKey     @"frame"
#define AppearingViewTypeKey      @"type"
#define AppearingViewDurationKey  @"duration"
#define AppearingViewOptionsKey   @"options"

#import <UIKit/UIKit.h>
#import "ABAnimations.h"

@protocol ABAppearingViewDelagate;

@interface ABAppearingView : UIView

@property (nonatomic, weak) id <ABAppearingViewDelagate>delegate;
@property (nonatomic, strong) NSNotificationCenter *notificationCenter;

@property (nonatomic, assign) AnimationType animationType;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) UIViewAnimationOptions animationOptions;

+ (void)setAnimationsObject:(id<AnimationMachine>)animationsObject;

- (void)appear;
- (void)disappear;

@end

@protocol ABAppearingViewDelagate <NSObject>
@optional

- (void)appearingView:(ABAppearingView *)view
    willAppearToFrame:(CGRect)frame
        animationType:(AnimationType)type
             duration:(NSTimeInterval)duration
              options:(UIViewAnimationOptions)options;

- (void)appearingViewDidAppear:(ABAppearingView *)view;

- (void)appearingView:(ABAppearingView *)view
willDisappearFromFrame:(CGRect)frame
        animationType:(AnimationType)type
             duration:(NSTimeInterval)duration
              options:(UIViewAnimationOptions)options;

- (void)appearingViewDidDisappear:(ABAppearingView *)view;
@end