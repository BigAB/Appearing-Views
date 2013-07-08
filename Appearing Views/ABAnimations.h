//
//  ABAnimations.h
//  Appearing Views
//
//  Created by Adam Barrett on 2013-07-03.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AnimationPhasePrep,
    AnimationPhaseIn,
    AnimationPhaseOut,
} AnimationPhase;

typedef enum {
    AnimationTypeNone,
    AnimationTypeFade,
    AnimationTypeSlideTop,
    AnimationTypeSlideBottom,
    AnimationTypeSlideLeft,
    AnimationTypeSlideRight,
} AnimationType;

typedef void (^FrameAnimationBlock)(UIView *view, CGRect frame);

@protocol AnimationMachine <NSObject>

- (FrameAnimationBlock)animationBlockWithType:(AnimationType)type phase:(AnimationPhase)phase;

@end

@interface ABAnimations : NSObject<AnimationMachine>

- (FrameAnimationBlock)animationBlockWithType:(AnimationType)type phase:(AnimationPhase)phase;

@end