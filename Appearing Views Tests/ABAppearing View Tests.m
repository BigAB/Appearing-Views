//
//  ABAppearing View Tests.m
//  Appearing Views
//
//  Created by Adam Barrett on 2013-07-03.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//
#import "Kiwi.h"
#import "ABAppearingView.h"

@interface ABAppearingView()
- (void)prepareForAnimatedAppearance;
- (void)appearWithAnimation;
@end

SPEC_BEGIN(ABAppearingViewSpec)

describe(@"Initialization", ^{
    
    __block ABAppearingView *appearingView;
    
    beforeEach(^{
        appearingView = [[ABAppearingView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    });
    
    it(@"should always start our hidden", ^{
        [[theValue(appearingView.hidden) should] equal:theValue(YES)];
    });
    
});

describe(@"Appearing", ^{
    
    __block ABAppearingView *appearingView;
    
    beforeEach(^{
        appearingView = [[ABAppearingView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    });
    
    describe(@"- appear", ^{
        
        it(@"should prepare to animate in, become visible, then animate in", ^{
            //expected
            [[appearingView should] receive:@selector(prepareForAnimatedAppearance)];
            [[appearingView should] receive:@selector(setHidden:) withArguments:theValue(NO)];
            [[appearingView should] receive:@selector(appearWithAnimation)];
            
            //actual
            [appearingView appear];
        });
        
        it(@"should do nothing if appearingView is already visible", ^{
            //setup
            appearingView.hidden = NO;
            
            //expected
            [[appearingView shouldNot] receive:@selector(prepareForAnimatedAppearance)];
            [[appearingView shouldNot] receive:@selector(setHidden:) withArguments:theValue(NO)];
            [[appearingView shouldNot] receive:@selector(appearWithAnimation)];
            
            //actual
            [appearingView appear];
        });
        
    });
    
    describe(@"- appear", ^{
        
        it(@"should prepare to animate in, become visible, then animate in", ^{
            [[appearingView should] receive:@selector(prepareForAnimatedAppearance)];
            [[appearingView should] receive:@selector(setHidden:) withArguments:theValue(NO)];
            [[appearingView should] receive:@selector(appearWithAnimation)];
            
            [appearingView appear];
        });
        
    });
    
});

SPEC_END
