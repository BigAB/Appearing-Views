//
//  ABAppearingView.h
//  Appearing Views Demo
//
//  Created by Adam Barrett on 2013-07-02.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABAnimations.h"

@protocol ABAppearingViewDelagate;

@interface ABAppearingView : UIView

@property (nonatomic, weak) id <ABAppearingViewDelagate>delegate;

+ (void)setAnimationsObject:(id<AnimationMachine>)animationsObject;

- (void)appear;
- (void)disappear;

@end

@protocol ABAppearingViewDelagate <NSObject>
@optional
- (BOOL)appearingViewWillAnimateToFrame:(CGRect)frame;
- (void)appearingViewDidAnimateToFrame:(CGRect)frame;

- (BOOL)appearingViewWillAppearAnimated:(BOOL)animated
                               duration:(NSTimeInterval)duration
                                options:(UIViewAnimationOptions)options;
- (void)appearingViewDidAppearAnimated:(BOOL)animated;


- (BOOL)appearingViewWillDisappearAnimated:(BOOL)animated
                               duration:(NSTimeInterval)duration
                                options:(UIViewAnimationOptions)options;
- (void)appearingViewDidDisappearAnimated:(BOOL)animated;
@end