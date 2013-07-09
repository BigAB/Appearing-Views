//
//  ABAnimations.m
//  Appearing Views
//
//  Created by Adam Barrett on 2013-07-03.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import "ABAnimations.h"
typedef enum {
    x,
    y,
} PointAxis;

@interface ABAnimations()
{
    NSMutableDictionary *tmpFrameStorage;
}

@property (nonatomic, strong) NSDictionary *animationsMap;

@end

@implementation ABAnimations

- (id)init
{
    self = [super init];
    if (self) {
        tmpFrameStorage = [NSMutableDictionary new];
    }
    return self;
}

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
                           @(AnimationTypeFade) : [self fade],
                           @(AnimationTypeSlideTop) : [self slideTop],
                           @(AnimationTypeSlideBottom) : [self slideBottom],
                           @(AnimationTypeSlideLeft) : [self slideLeft],
                           @(AnimationTypeSlideRight) : [self slideRight],
                           };
    }
    return _animationsMap;
}

#pragma mark - Animations Helpers
- (void)storeSubviewFramesForView:(UIView *)view
{
    [tmpFrameStorage setObject:[view.subviews valueForKey:@"frame"] forKey:[NSValue valueWithNonretainedObject:view]];
}

- (void)restoreSubviewFramesForView:(UIView *)view
{
    NSArray *originalFrames = tmpFrameStorage[ [NSValue valueWithNonretainedObject:view] ];
    if (originalFrames) {
        [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
            subview.frame = [originalFrames[idx] CGRectValue];
        }];
        [tmpFrameStorage removeObjectForKey:[NSValue valueWithNonretainedObject:view]];
    }
}

- (void)setSubviewsofView:(UIView *)view forFrame:(CGRect)frame axis:(PointAxis)axis magnitude:(CGFloat)magnitude
{
    CGFloat propOffset;
    switch (axis) {
        case x:
            propOffset = frame.size.width * magnitude;
            break;
        case y:
            propOffset = frame.size.height * magnitude;
            break;
    }
    
    [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        CGRect f = subview.frame;
        switch (axis) {
            case x:
                subview.frame = CGRectMake(f.origin.x + propOffset, f.origin.y, f.size.width, f.size.height);
                break;
            case y:
                subview.frame = CGRectMake(f.origin.x, f.origin.y + propOffset, f.size.width, f.size.height);
                break;
        }
    }];
}

#pragma mark - Animations
#pragma mark -

- (NSDictionary *)fade
{
    return  @{
              @(AnimationPhasePrep) : ^(UIView *view, CGRect frame){
                  view.alpha = 0;
              },
              @(AnimationPhaseIn) : ^(UIView *view, CGRect frame){
                  view.alpha = 1;
              },
              @(AnimationPhaseOut) : ^(UIView *view, CGRect frame){
                  view.alpha = 0;
              },
              @(AnimationPhaseReset) : ^(UIView *view, CGRect frame){
                  view.alpha = 1;
              },
              };
}

- (NSDictionary *)slideTop
{
    __block ABAnimations *_self = self;
    return @{
             @(AnimationPhasePrep) : ^(UIView *view, CGRect frame){
                 
                 [_self storeSubviewFramesForView:view];
                 [_self setSubviewsofView:view forFrame:frame axis:y magnitude:-1];
                 view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
                 
             },
             @(AnimationPhaseIn) : ^(UIView *view, CGRect frame){
                 
                 view.frame = frame;
                 [_self restoreSubviewFramesForView:view];
                 
             },
             @(AnimationPhaseOut) : ^(UIView *view, CGRect frame){
                 
                 [_self storeSubviewFramesForView:view];
                 [_self setSubviewsofView:view forFrame:frame axis:y magnitude:-1];
                 view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
             },
             @(AnimationPhaseReset) : ^(UIView *view, CGRect frame){
                 [_self restoreSubviewFramesForView:view];
             },
             };
}

- (NSDictionary *)slideBottom
{
    return  @{
              @(AnimationPhasePrep) : ^(UIView *view, CGRect frame){
                  CGFloat newY = frame.origin.y + frame.size.height;
                  view.frame = CGRectMake(frame.origin.x, newY, frame.size.width, 0);
              },
              @(AnimationPhaseIn) : ^(UIView *view, CGRect frame){
                  view.frame = frame;
              },
              @(AnimationPhaseOut) : ^(UIView *view, CGRect frame){
                  CGFloat newY = frame.origin.y + frame.size.height;
                  view.frame = CGRectMake(frame.origin.x, newY, frame.size.width, 0);
              },
              @(AnimationPhaseReset) : ^(UIView *view, CGRect frame){
              },
              };
}

- (NSDictionary *)slideLeft
{
    __block ABAnimations *_self = self;
    return  @{
              @(AnimationPhasePrep) : ^(UIView *view, CGRect frame){
                  
                  [_self storeSubviewFramesForView:view];
                  [_self setSubviewsofView:view forFrame:frame axis:x magnitude:-1];
                  CGFloat newX = frame.origin.x - frame.size.width;
                  view.frame = CGRectMake(newX, frame.origin.y, 0, frame.size.height);
                  
              },
              @(AnimationPhaseIn) : ^(UIView *view, CGRect frame){
                  view.frame = frame;
                  [_self restoreSubviewFramesForView:view];
              },
              @(AnimationPhaseOut) : ^(UIView *view, CGRect frame){
                  
                  [_self storeSubviewFramesForView:view];
                  [_self setSubviewsofView:view forFrame:frame axis:x magnitude:-1];
                  CGFloat newX = frame.origin.x - frame.size.width;
                  view.frame = CGRectMake(newX, frame.origin.y, 0, frame.size.height);
                  
              },
              @(AnimationPhaseReset) : ^(UIView *view, CGRect frame){
                  [_self restoreSubviewFramesForView:view];
              },
              };
}

- (NSDictionary *)slideRight
{
    return  @{
              @(AnimationPhasePrep) : ^(UIView *view, CGRect frame){
                  CGFloat newX = frame.origin.x + frame.size.width;
                  view.frame = CGRectMake(newX, frame.origin.y, 0, frame.size.height);
              },
              @(AnimationPhaseIn) : ^(UIView *view, CGRect frame){
                  view.frame = frame;
              },
              @(AnimationPhaseOut) : ^(UIView *view, CGRect frame){
                  CGFloat newX = frame.origin.x + frame.size.width;
                  view.frame = CGRectMake(newX, frame.origin.y, 0, frame.size.height);
              },
              @(AnimationPhaseReset) : ^(UIView *view, CGRect frame){},
              };
}


@end
