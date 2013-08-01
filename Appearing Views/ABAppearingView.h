//
//  ABAppearingView.h
//  Appearing Views Demo
//
//  Created by Adam Barrett on 2013-07-02.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//
#define ViewWillAppearWithAnimation    @"ABViewWillAppearWithAnimation"
#define ViewDidAppearWithAnimation     @"ABViewDidAppearWithAnimation"
#define ViewWillDisappearWithAnimation @"ABViewWillDisappearWithAnimation"
#define ViewDidDisappearWithAnimation  @"ABViewDidDisappearWithAnimation"

#define AppearingViewViewKey      @"view"
#define AppearingViewFrameKey     @"frame"
#define AppearingViewTypeKey      @"type"
#define AppearingViewDurationKey  @"duration"
#define AppearingViewOptionsKey   @"options"

#import <UIKit/UIKit.h>
#import "ABAnimations.h"

@class ABAppearingView;
@protocol ABAppearingViewDelagate;

typedef void (^ViewAppearanceCallback)(UIView *view, NSDictionary *animationInfo);

@interface ABAppearingView : UIView

@property (nonatomic, weak) id <ABAppearingViewDelagate>delegate;
@property (nonatomic, strong) NSNotificationCenter *notificationCenter;

@property (nonatomic, assign) AnimationType animationType;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) UIViewAnimationOptions animationOptions;

@property (nonatomic, copy) ViewAppearanceCallback viewWillAppearWithAnimationCallback;
@property (nonatomic, copy) ViewAppearanceCallback viewDidAppearWithAnimationCallback;
@property (nonatomic, copy) ViewAppearanceCallback viewWillDisappearWithAnimationCallback;
@property (nonatomic, copy) ViewAppearanceCallback viewDidDisappearWithAnimationCallback;

+ (void)setAnimationsObject:(id<AnimationMachine>)animationsObject;

- (void)appear;
- (void)disappear;

@end

@protocol ABAppearingViewDelagate <NSObject>
@optional

- (void)viewWillAppear:(ABAppearingView *)view
         withAnimation:(AnimationType)type
               toFrame:(CGRect)frame
              duration:(NSTimeInterval)duration
               options:(UIViewAnimationOptions)options;

- (void)viewDidAppear:(ABAppearingView *)view withAnimation:(AnimationType)type;

- (void)viewWillDisappear:(ABAppearingView *)view
            withAnimation:(AnimationType)type
                fromFrame:(CGRect)frame
                 duration:(NSTimeInterval)duration
                  options:(UIViewAnimationOptions)options;

- (void)viewDidDisappear:(ABAppearingView *)view withAnimation:(AnimationType)type;

@end