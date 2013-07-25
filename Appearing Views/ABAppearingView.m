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
@property (nonatomic, readonly) AVAnimationBlock appearancePrepBlock;
@property (nonatomic, readonly) AVAnimationBlock appearanceBlock;
@property (nonatomic, readonly) AVAnimationBlock disappearanceBlock;
@property (nonatomic, readonly) AVAnimationBlock resetBlock;

@property (nonatomic, assign) BOOL originalClipsToBounds;

- (void)viewWillAppearWithAnimation:(AnimationType)animation;
- (void)viewDidAppearWithAnimation:(AnimationType)animation;
- (void)viewWillDisappearWithAnimation:(AnimationType)animation;
- (void)viewDidDisappearWithAnimation:(AnimationType)animation;

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

+ (UIWindow *)mainWindow {
    NSLog(@"Windows: %@", [UIApplication sharedApplication].windows);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window || ![window isMemberOfClass:[UIWindow class]])
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    return window;
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
- (AVAnimationBlock)appearancePrepBlock
{
    return [_animations animationBlockWithType:self.animationType phase:AnimationPhasePrep];
}

-(AVAnimationBlock)appearanceBlock
{
    return [_animations animationBlockWithType:self.animationType phase:AnimationPhaseIn];
}

-(AVAnimationBlock)disappearanceBlock
{
    return [_animations animationBlockWithType:self.animationType phase:AnimationPhaseOut];
}

-(AVAnimationBlock)resetBlock
{
    return [_animations animationBlockWithType:self.animationType phase:AnimationPhaseReset];
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
    [self prepareForAnimatedAppearance];
    [self notifyListenersWill:AnimationPhaseIn];
    [self viewWillAppearWithAnimation:self.animationType];
    
    self.hidden = NO;
    [self appearWithAnimation];
}

- (void)disappear
{
    if (self.hidden) return;
    self.fullFrame = self.frame;
    [self notifyListenersWill:AnimationPhaseOut];
    [self viewWillDisappearWithAnimation:self.animationType];
    [self disappearWithAnimation];
}

- (void)prepareForAnimatedAppearance
{
    self.fullFrame = self.frame;
    self.originalClipsToBounds = self.clipsToBounds;
    self.clipsToBounds = YES;
    self.appearancePrepBlock(self, self.fullFrame, self.animationDuration, ^(){});
}

- (void)appearWithAnimation
{
    self.appearanceBlock(self, self.fullFrame, self.animationDuration, [self appearCompletionBlock]);
}

- (void)disappearWithAnimation
{
    self.disappearanceBlock(self, self.fullFrame, self.animationDuration, [self disappearCompletionBlock]);
}

- (CompletionCallback)appearCompletionBlock
{
    __weak typeof(self) _self = self;
    return [^(){
        [_self notifyListenersDid:AnimationPhaseIn];
        [_self viewDidAppearWithAnimation:_self.animationType];
    } copy];
}

- (CompletionCallback)disappearCompletionBlock
{
    __weak typeof(self) _self = self;
    return [^(){
        _self.hidden = YES;
        [_self resetView];
        [_self notifyListenersDid:AnimationPhaseOut];
        [_self viewDidDisappearWithAnimation:_self.animationType];
    } copy];
}

- (void)resetView
{
    self.clipsToBounds = self.originalClipsToBounds;
    self.frame = self.fullFrame;
    self.resetBlock(self, self.fullFrame, self.animationDuration, ^(){});
    self.fullFrame = CGRectZero;
}

- (void)viewWillAppearWithAnimation:(AnimationType)animation
{
    // for subclassing
}

- (void)viewDidAppearWithAnimation:(AnimationType)animation
{
    // for subclassing
}

- (void)viewWillDisappearWithAnimation:(AnimationType)animation
{
    // for subclassing
}

- (void)viewDidDisappearWithAnimation:(AnimationType)animation
{
    // for subclassing
}

#pragma mark - ABAppearingViewDelagate stuff
- (void)notifyListenersDid:(AnimationPhase)phase
{
    NSDictionary *userInfo = [self animationInfo];
    switch (phase) {
        case AnimationPhaseIn:
            if (self.delegate && [self.delegate respondsToSelector:@selector(viewDidAppear:withAnimation:)]) {
                [self.delegate viewDidAppear:self withAnimation:self.animationType];
            }
            [self.notificationCenter postNotificationName:ViewDidAppearWithAnimation object:self userInfo:userInfo];
            break;
            
        case AnimationPhaseOut:
            if (self.delegate && [self.delegate respondsToSelector:@selector(viewDidDisappear:withAnimation:)]) {
                [self.delegate viewDidDisappear:self withAnimation:self.animationType];
            }
            [self.notificationCenter postNotificationName:ViewDidDisappearWithAnimation object:self userInfo:userInfo];
            break;
            
        case AnimationPhasePrep:
        default:
            break;
    }
    
}

- (void)notifyListenersWill:(AnimationPhase)phase
{
    NSDictionary *animationInfo = [self animationInfo];
    
    switch (phase) {
        case AnimationPhaseIn:
            if (self.delegate && [self.delegate respondsToSelector:@selector(viewWillAppear:withAnimation:toFrame:duration:options:)]) {
                [self.delegate viewWillAppear:self
                                withAnimation:[animationInfo[AppearingViewTypeKey] intValue]
                                      toFrame:[animationInfo[AppearingViewFrameKey] CGRectValue]
                                     duration:[animationInfo[AppearingViewDurationKey] floatValue]
                                      options:[animationInfo[AppearingViewOptionsKey] intValue]
                 ];
            }
            [self.notificationCenter postNotificationName:ViewWillAppearWithAnimation object:self userInfo:animationInfo];
            break;
            
        case AnimationPhaseOut:
            if (self.delegate && [self.delegate respondsToSelector:@selector(viewWillDisappear:withAnimation:fromFrame:duration:options:)]) {
                [self.delegate viewWillDisappear:self
                                   withAnimation:[animationInfo[AppearingViewTypeKey] intValue]
                                       fromFrame:[animationInfo[AppearingViewFrameKey] CGRectValue]
                                        duration:[animationInfo[AppearingViewDurationKey] floatValue]
                                         options:[animationInfo[AppearingViewOptionsKey] intValue]
                 ];
            }
            [self.notificationCenter postNotificationName:ViewWillDisappearWithAnimation object:self userInfo:animationInfo];
            break;
            
        case AnimationPhasePrep:
        default:
            break;
    }
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
