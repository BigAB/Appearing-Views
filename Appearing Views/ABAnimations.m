//
//  ABAnimations.m
//  Appearing Views
//
//  Created by Adam Barrett on 2013-07-03.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//

#import "ABAnimations.h"

@implementation ABAnimations

- (FrameAnimationBlock)animationBlockWithType:(AnimationType)type phase:(AnimationPhase)phase
{
    return [^(CGRect viewFrame){} copy];
}

@end
