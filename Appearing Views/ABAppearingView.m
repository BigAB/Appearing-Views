//
//  ABAppearingView.m
//  Appearing Views Demo
//
//  Created by Adam Barrett on 2013-07-02.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import "ABAppearingView.h"

static id<AnimationMachine> _animations;

@interface ABAppearingView()

@end

@implementation ABAppearingView{}

#pragma mark - Class Methods
+(void)initialize
{
    _animations = [ABAnimations new];
}

+ (void)setAnimationsObject:(id)animationsObject
{
    _animations = animationsObject;
}

#pragma mark - LifeCycle
- (void)_initialization
{
    self.hidden = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initialization];
    }
    return self;
}

#pragma mark - Appearing and Disappearing
- (void)appear
{
    if (!self.hidden) return;
    
    [self prepareForAnimatedAppearance];
    self.hidden = NO;
    [self appearWithAnimation];
}

- (void)disappear
{
    //
}

- (void)prepareForAnimatedAppearance
{
    
}

- (void)appearWithAnimation
{
    
}

#pragma mark - ABAppearingViewDelagate

@end
