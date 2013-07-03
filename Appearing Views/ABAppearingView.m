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

@property (nonatomic, assign) CGRect fullFrame;
@property (nonatomic, readonly) FrameAnimationBlock appearancePrepBlock;
@property (nonatomic, readonly) FrameAnimationBlock appearanceBlock;
@property (nonatomic, readonly) FrameAnimationBlock disappearanceBlock;

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
    self.animationDuration = 1.0f;
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

#pragma mark - Property Accessors
- (FrameAnimationBlock)appearancePrepBlock
{
    return [_animations animationBlockWithType:AnimationTypeSlideTop phase:AnimationPhaseIn];
}

-(FrameAnimationBlock)appearanceBlock
{
    return [_animations animationBlockWithType:AnimationTypeSlideTop phase:AnimationPhaseIn];
}

- (FrameAnimationBlock)disappearancePrepBlock
{
    return [_animations animationBlockWithType:AnimationTypeSlideTop phase:AnimationPhaseOut];
}

-(FrameAnimationBlock)disappearanceBlock
{
    return [_animations animationBlockWithType:AnimationTypeSlideTop phase:AnimationPhaseOut];
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
    if (self.hidden) return;
    self.fullFrame = self.frame;
    [self disappearWithAnimation];
}

- (void)prepareForAnimatedAppearance
{
    self.fullFrame = self.frame;
    self.appearancePrepBlock(self.fullFrame);
}

- (void)appearWithAnimation
{
    __block ABAppearingView *_self = self;
    [UIView animateWithDuration:self.animationDuration animations:^{
        _self.appearanceBlock(self.fullFrame);
    } completion:^(BOOL finished){
        // notify done
    }];
}

- (void)disappearWithAnimation
{
    __block ABAppearingView *_self = self;
    [UIView animateWithDuration:self.animationDuration animations:^{
        _self.disappearanceBlock(self.frame);
    } completion:^(BOOL finished){
        _self.hidden = YES;
        [_self resetFrame];
        // notify done
    }];
}

- (void)resetFrame
{
    self.frame = self.fullFrame;
}

#pragma mark - ABAppearingViewDelagate

@end
