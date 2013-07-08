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
    return [_animations animationBlockWithType:self.animationType phase:AnimationPhasePrep];
}

-(FrameAnimationBlock)appearanceBlock
{
    return [_animations animationBlockWithType:self.animationType phase:AnimationPhaseIn];
}

-(FrameAnimationBlock)disappearanceBlock
{
    return [_animations animationBlockWithType:self.animationType phase:AnimationPhaseOut];
}


- (NSNotificationCenter *)notificationCenter
{
    if (!_notificationCenter) {
        _notificationCenter = [NSNotificationCenter defaultCenter];
    }
    return _notificationCenter;
}

#pragma mark - Appearing and Disappearing
- (void)appear
{
    if (!self.hidden) return;
    if ( ![self notifyListenersWill:AnimationPhaseIn] ) return;
    
    [self prepareForAnimatedAppearance];
    self.hidden = NO;
    [self appearWithAnimation];
}

- (void)disappear
{
    if (self.hidden) return;
    if ( ![self notifyListenersWill:AnimationPhaseOut] ) return;
    self.fullFrame = self.frame;
    [self disappearWithAnimation];
}

- (void)prepareForAnimatedAppearance
{
    self.fullFrame = self.frame;
    self.appearancePrepBlock(self, self.fullFrame);
}

- (void)appearWithAnimation
{
    __block ABAppearingView *_self = self;
    [UIView animateWithDuration:self.animationDuration animations:^{
        _self.appearanceBlock(self, self.fullFrame);
    } completion:^(BOOL finished){
        [self notifyListenersDid:AnimationPhaseIn];
    }];
}

- (void)disappearWithAnimation
{
    __block ABAppearingView *_self = self;
    [UIView animateWithDuration:self.animationDuration animations:^{
        _self.disappearanceBlock(self, self.frame);
    } completion:^(BOOL finished){
        _self.hidden = YES;
        [self notifyListenersDid:AnimationPhaseOut];
        [_self resetFrame];
    }];
}

- (void)resetFrame
{
    self.frame = self.fullFrame;
    self.fullFrame = CGRectZero;
}

#pragma mark - ABAppearingViewDelagate stuff
- (void)notifyListenersDid:(AnimationPhase)phase
{
    NSDictionary *userInfo = [self animationInfo];
    switch (phase) {
        case AnimationPhaseIn:
            if (self.delegate && [self.delegate respondsToSelector:@selector(appearingViewDidAppear:)]) {
                [self.delegate appearingViewDidAppear:self];
            }
            [self.notificationCenter postNotificationName:AppearingViewDidAppear object:self userInfo:userInfo];
            break;
            
        case AnimationPhaseOut:
            if (self.delegate && [self.delegate respondsToSelector:@selector(appearingViewDidDisappear:)]) {
                [self.delegate appearingViewDidDisappear:self];
            }
            [self.notificationCenter postNotificationName:AppearingViewDidDisappear object:self userInfo:userInfo];
            break;
            
        case AnimationPhasePrep:
        default:
            break;
    }
    
}

- (BOOL)notifyListenersWill:(AnimationPhase)phase
{
    NSDictionary *animationInfo = [self animationInfo];
    BOOL itWill = YES;
    
    switch (phase) {
        case AnimationPhaseIn:
            if (self.delegate && [self.delegate respondsToSelector:@selector(appearingView:willAppearToFrame:animationType:duration:options:)]) {
                itWill = [self.delegate appearingView:self
                                    willAppearToFrame:[animationInfo[AppearingViewFrameKey] CGRectValue]
                                        animationType:[animationInfo[AppearingViewTypeKey] intValue]
                                             duration:[animationInfo[AppearingViewDurationKey] intValue]
                                              options:[animationInfo[AppearingViewOptionsKey] intValue]
                          ];
            }
            [self.notificationCenter postNotificationName:AppearingViewWillAppear object:self userInfo:animationInfo];
            break;
            
        case AnimationPhaseOut:
            if (self.delegate && [self.delegate respondsToSelector:@selector(appearingView:willDisappearFromFrame:animationType:duration:options:)]) {
                itWill = [self.delegate appearingView:self
                               willDisappearFromFrame:[animationInfo[AppearingViewFrameKey] CGRectValue]
                                        animationType:[animationInfo[AppearingViewTypeKey] intValue]
                                             duration:[animationInfo[AppearingViewDurationKey] intValue]
                                              options:[animationInfo[AppearingViewOptionsKey] intValue]
                          ];
            }
            [self.notificationCenter postNotificationName:AppearingViewWillDisappear object:self userInfo:animationInfo];
            break;
            
        case AnimationPhasePrep:
        default:
            break;
    }
    return itWill;
}

- (NSDictionary *)animationInfo
{
    return @{
             AppearingViewViewKey     : self,
             AppearingViewFrameKey    : [NSValue valueWithCGRect:self.fullFrame],
             AppearingViewTypeKey     : @(self.animationType),
             AppearingViewDurationKey : @(self.animationDuration),
             AppearingViewOptionsKey  : @(self.animationOptions),
            };
}

@end
