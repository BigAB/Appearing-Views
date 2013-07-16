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
    AnimationPhaseReset,
} AnimationPhase;

typedef enum {
    AnimationTypeNone,
    AnimationTypeFade,
    AnimationTypeSlideTop,
    AnimationTypeSlideBottom,
    AnimationTypeSlideLeft,
    AnimationTypeSlideRight,
    AnimationTypeRevealTop,
    AnimationTypeRevealBottom,
    AnimationTypeRevealLeft,
    AnimationTypeRevealRight,
    
    AnimationTypeSpin,
    
} AnimationType;

typedef void (^Block)(void);

typedef void (^CompletionBlock)();

typedef void (^FrameAnimationBlock)(UIView *view, CGRect frame, NSTimeInterval duration, CompletionBlock completed);

@protocol AnimationMachine <NSObject>

- (FrameAnimationBlock)animationBlockWithType:(AnimationType)type phase:(AnimationPhase)phase;

@end

@interface ABAnimations : NSObject<AnimationMachine>

- (FrameAnimationBlock)animationBlockWithType:(AnimationType)type phase:(AnimationPhase)phase;

@end