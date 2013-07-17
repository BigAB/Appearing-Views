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

- (AVAnimationBlock)animationBlockWithType:(AnimationType)type phase:(AnimationPhase)phase
{
    AVAnimationBlock animationBlock;
    
    animationBlock = self.animationsMap[@(type)][@(phase)];
    if (!animationBlock) {
        animationBlock = ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){};
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
                           @(AnimationTypeRevealTop) : [self revealTop],
                           @(AnimationTypeRevealBottom) : [self revealBottom],
                           @(AnimationTypeRevealLeft) : [self revealLeft],
                           @(AnimationTypeRevealRight) : [self revealRight],
                           @(AnimationTypeSpin) : [self spin],
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

- (Block)turnView:(UIView *)view byQuarterMagnitude:(CGFloat)magnitude
{
    CGFloat mag = (magnitude == 0 ? 1.0 : magnitude);
    return [^{
        
        view.transform = CGAffineTransformRotate(view.transform, M_PI_2*mag);
        
    } copy];
}

#pragma mark - Animations
#pragma mark -

- (NSDictionary *)fade
{
    return  @{
              @(AnimationPhasePrep) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  view.alpha = 0;
              },
              @(AnimationPhaseIn) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      view.alpha = 1;
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseOut) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      view.alpha = 0;
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseReset) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  view.alpha = 1;
              },
              };
}

- (NSDictionary *)slideTop
{
    __block ABAnimations *_self = self;
    return @{
             @(AnimationPhasePrep) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                 
                 [_self storeSubviewFramesForView:view];
                 [_self setSubviewsofView:view forFrame:frame axis:y magnitude:-1];
                 view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
                 
             },
             @(AnimationPhaseIn) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                 [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                     view.frame = frame;
                     [_self restoreSubviewFramesForView:view];
                 } completion:^(BOOL finished) {
                     completed();
                 }];
             },
             @(AnimationPhaseOut) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                 [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                     [_self storeSubviewFramesForView:view];
                     [_self setSubviewsofView:view forFrame:frame axis:y magnitude:-1];
                     view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
                 } completion:^(BOOL finished) {
                     completed();
                 }];
             },
             @(AnimationPhaseReset) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                 [_self restoreSubviewFramesForView:view];
             },
             };
}

- (NSDictionary *)slideBottom
{
    return  @{
              @(AnimationPhasePrep) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  CGFloat newY = frame.origin.y + frame.size.height;
                  view.frame = CGRectMake(frame.origin.x, newY, frame.size.width, 0);
              },
              @(AnimationPhaseIn) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      view.frame = frame;
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseOut) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      CGFloat newY = frame.origin.y + frame.size.height;
                      view.frame = CGRectMake(frame.origin.x, newY, frame.size.width, 0);
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseReset) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){},
              };
}

- (NSDictionary *)slideLeft
{
    __block ABAnimations *_self = self;
    return  @{
              @(AnimationPhasePrep) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  
                  [_self storeSubviewFramesForView:view];
                  [_self setSubviewsofView:view forFrame:frame axis:x magnitude:-1];
                  CGFloat newX = frame.origin.x - frame.size.width;
                  view.frame = CGRectMake(newX, frame.origin.y, 0, frame.size.height);
                  
              },
              @(AnimationPhaseIn) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      view.frame = frame;
                      [_self restoreSubviewFramesForView:view];
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseOut) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      [_self storeSubviewFramesForView:view];
                      [_self setSubviewsofView:view forFrame:frame axis:x magnitude:-1];
                      CGFloat newX = frame.origin.x - frame.size.width;
                      view.frame = CGRectMake(newX, frame.origin.y, 0, frame.size.height);
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseReset) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [_self restoreSubviewFramesForView:view];
              },
              };
}

- (NSDictionary *)slideRight
{
    return  @{
              @(AnimationPhasePrep) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  
                  CGFloat newX = frame.origin.x + frame.size.width;
                  view.frame = CGRectMake(newX, frame.origin.y, 0, frame.size.height);
                  
              },
              @(AnimationPhaseIn) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      view.frame = frame;
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseOut) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      CGFloat newX = frame.origin.x + frame.size.width;
                      view.frame = CGRectMake(newX, frame.origin.y, 0, frame.size.height);
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseReset) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){},
              };
}

- (NSDictionary *)revealTop
{
    return  @{
              @(AnimationPhasePrep) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
              },
              @(AnimationPhaseIn) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      view.frame = frame;
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseOut) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseReset) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){},
              };
}

- (NSDictionary *)revealBottom
{
    __block ABAnimations *_self = self;
    return  @{
              @(AnimationPhasePrep) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [_self storeSubviewFramesForView:view];
                  [_self setSubviewsofView:view forFrame:frame axis:y magnitude:-1];
                  view.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, 0);
              },
              @(AnimationPhaseIn) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      [_self restoreSubviewFramesForView:view];
                      view.frame = frame;
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseOut) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      [_self storeSubviewFramesForView:view];
                      [_self setSubviewsofView:view forFrame:frame axis:y magnitude:-1];
                      view.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, 0);
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseReset) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                [_self restoreSubviewFramesForView:view];
              },
              };
}

- (NSDictionary *)revealLeft
{
    return  @{
              @(AnimationPhasePrep) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  view.frame = CGRectMake(frame.origin.x, frame.origin.y, 0, frame.size.height);
              },
              @(AnimationPhaseIn) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      view.frame = frame;
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseOut) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      view.frame = CGRectMake(frame.origin.x, frame.origin.y, 0, frame.size.height);
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseReset) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){},
              };
}

- (NSDictionary *)revealRight
{
    __block ABAnimations *_self = self;
    return  @{
              @(AnimationPhasePrep) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [_self storeSubviewFramesForView:view];
                  [_self setSubviewsofView:view forFrame:frame axis:x magnitude:-1];
                  
                  view.frame = CGRectMake(frame.origin.x + frame.size.width, frame.origin.y, 0, frame.size.height);
              },
              @(AnimationPhaseIn) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      [_self restoreSubviewFramesForView:view];
                      view.frame = frame;
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseOut) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      [_self storeSubviewFramesForView:view];
                      [_self setSubviewsofView:view forFrame:frame axis:x magnitude:-1];
                      view.frame = CGRectMake(frame.origin.x + frame.size.width, frame.origin.y, 0, frame.size.height);
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseReset) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [_self restoreSubviewFramesForView:view];
              },
              };
}

- (NSDictionary *)spin
{
    //__block ABAnimations *_self = self;
    return  @{
              @(AnimationPhasePrep) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  view.transform = CGAffineTransformMakeScale(0.1, 0.1);
                  completed();
              },
              @(AnimationPhaseIn) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
                  
                  __block CGAffineTransform transform = view.transform;
                  
                  [UIView animateWithDuration:duration/3.0 delay:0 options:options animations:^{
                      transform = CGAffineTransformScale(transform, 10, 10);
                      view.transform = CGAffineTransformRotate(transform, -M_PI_2);
                      
                  } completion:^(BOOL finished){
                      //stops the chain
                      if(! finished) {
                          completed();
                          return;
                      }
                      
                      //animation 2
                      [UIView animateWithDuration:duration/3.0 delay:0 options:options  animations:^{
                          transform = CGAffineTransformScale(transform, 2, 2);
                          view.transform = CGAffineTransformRotate(transform, -2*M_PI_2);
                          
                      } completion:^(BOOL finished){
                          //stops the chain
                          if(! finished) {
                              completed();
                              return;
                          }
                          
                          //animation 3
                          [UIView animateWithDuration:duration/3.0 delay:0 options:options  animations:^{
                              transform = CGAffineTransformScale(transform, 0.8, 0.8);
                              view.transform = CGAffineTransformRotate(transform, -3*M_PI_2);
                              
                          } completion:^(BOOL finished){
                              //stops the chain
                              if(! finished) {
                                  completed();
                                  return;
                              }
                              //animation 4
                              [UIView animateWithDuration:duration/3.0 delay:0 options:options animations:^{
                                  view.transform = CGAffineTransformIdentity;
                              } completion:^(BOOL finished){
                                  completed();
                              }];
                              
                          }];
                      }];
                  }];
                  
              },
              @(AnimationPhaseOut) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  [UIView animateWithDuration:duration delay:0 options:kNilOptions animations:^{
                      view.alpha = 0;
                  } completion:^(BOOL finished) {
                      completed();
                  }];
              },
              @(AnimationPhaseReset) : ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionCallback completed){
                  view.alpha = 1;
                  completed();
              },
              };
}
@end
