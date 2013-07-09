//
//  ABAnimations.m
//  Appearing Views
//
//  Created by Adam Barrett on 2013-07-03.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import "ABAnimations.h"

@interface ABAnimations()
{
    NSArray *_subviewPostAnimationFrames;
}
@property (nonatomic, strong) NSDictionary *animationsMap;

@end

@implementation ABAnimations

- (FrameAnimationBlock)animationBlockWithType:(AnimationType)type phase:(AnimationPhase)phase
{
    FrameAnimationBlock animationBlock;
    
    animationBlock = self.animationsMap[@(type)][@(phase)];
    if (!animationBlock) {
        animationBlock = ^(UIView *view, CGRect frame){};
    }
    
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
                           @(AnimationTypeSlideTop) : @{
                                   @(AnimationPhasePrep) : ^(UIView *view, CGRect frame){
                                       view.clipsToBounds = YES;
                                       view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
                                       _subviewPostAnimationFrames = [view.subviews valueForKey:@"frame"];
                                       [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
                                           CGRect f = subview.frame;
                                           CGFloat offsetY = (f.origin.y - frame.size.height);
                                           subview.frame = CGRectMake(f.origin.x, offsetY, f.size.width, f.size.height);
                                       }];
                                   },
                                   @(AnimationPhaseIn) : ^(UIView *view, CGRect frame){
                                       view.frame = frame;
                                       [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
                                           subview.frame = [_subviewPostAnimationFrames[idx] CGRectValue];
                                       }];
                                   },
                                   @(AnimationPhaseOut) : ^(UIView *view, CGRect frame){
                                       view.alpha = 0;
                                   },
                                   @(AnimationPhaseReset) : ^(UIView *view, CGRect frame){
                                       view.alpha = 0;
                                   },
                                   },
                           };
    }
    return _animationsMap;
}
@end
