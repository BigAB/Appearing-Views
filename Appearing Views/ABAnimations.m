//
//  ABAnimations.m
//  Appearing Views
//
//  Created by Adam Barrett on 2013-07-03.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import "ABAnimations.h"

@interface ABAnimations()

@property (nonatomic, strong) NSDictionary *animationsMap;

@end

@implementation ABAnimations

- (FrameAnimationBlock)animationBlockWithType:(AnimationType)type phase:(AnimationPhase)phase
{
    FrameAnimationBlock animationBlock;
    
    animationBlock = self.animationsMap[@(type)][@(phase)];
    
    return [animationBlock copy];
}

- (NSDictionary *)animationsMap
{
    if (!_animationsMap) {
        _animationsMap = @{
                           @(AnimationTypeNone) : @{
                                   @(AnimationPhasePrep) : ^(UIView *view, CGRect frame){},
                                   @(AnimationPhaseIn) : ^(UIView *view, CGRect frame){},
                                   @(AnimationPhaseOut) : ^(UIView *view, CGRect frame){},
                                   },
                           @(AnimationTypeFade) : @{
                                   @(AnimationPhasePrep) : ^(UIView *view, CGRect frame){
                                       view.alpha = 0;
                                   },
                                   @(AnimationPhaseIn) : ^(UIView *view, CGRect frame){
                                       view.alpha = 1;
                                   },
                                   @(AnimationPhaseOut) : ^(UIView *view, CGRect frame){
                                       view.alpha = 0;
                                   },
                                   },
                           };
    }
    return _animationsMap;
}
@end
