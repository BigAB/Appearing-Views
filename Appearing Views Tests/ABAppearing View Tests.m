//
//  ABAppearing View Tests.m
//  Appearing Views
//
//  Created by Adam Barrett on 2013-07-03.
//  Copyright (c) 2013 Adam Barrett. All rights reserved.
//
#import "Kiwi.h"
#import "ABAppearingView.h"

#pragma mark - All these are here so as to test "private" methods/properties
#pragma mark -
@interface ABAppearingView()

@property (nonatomic, assign) CGRect fullFrame;
@property (nonatomic, readonly) FrameAnimationBlock appearancePrepBlock;
@property (nonatomic, readonly) FrameAnimationBlock appearanceBlock;
@property (nonatomic, readonly) FrameAnimationBlock disappearanceBlock;
@property (nonatomic, readonly) FrameAnimationBlock resetBlock;

@property (nonatomic, assign) BOOL originalClipsToBounds;

- (void)prepareForAnimatedAppearance;
- (void)appearWithAnimation;
- (void)disappearWithAnimation;
- (void)resetView;
@end
#pragma mark -
#pragma mark -

SPEC_BEGIN(ABAppearingViewSpec)

describe(@"Initialization", ^{
    
    __block ABAppearingView *appearingView;
    
    beforeEach(^{
        appearingView = [[ABAppearingView alloc] initWithFrame:CGRectZero];
    });
    
    it(@"should always start our hidden", ^{
        [[theValue(appearingView.hidden) should] equal:theValue(YES)];
    });
    
});

describe(@"Appearing", ^{
    
    __block ABAppearingView *appearingView;
    CGRect initialFrame = CGRectMake(0, 0, 100, 100);
    
    beforeEach(^{
        appearingView = [[ABAppearingView alloc] initWithFrame:initialFrame];
    });
    
    describe(@"-appear", ^{
        
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
            [[appearingView shouldNot] receive:@selector(setHidden:)];
            [[appearingView shouldNot] receive:@selector(appearWithAnimation)];
            
            //actual
            [appearingView appear];
        });
        
        it(@"should notify the delegate and the notification center that it is about to animate in", ^{
            //setup
            [appearingView stub:@selector(prepareForAnimatedAppearance)];
            [appearingView stub:@selector(setHidden:)];
            [appearingView stub:@selector(appearWithAnimation)];
            
            // expected
            [[appearingView should] receive:@selector(notifyListenersWill:) withArguments:theValue(AnimationPhaseIn)];
            
            //actual
            [appearingView appear];
        });
        
        it(@"should do nothing if the delegate responds NO to willappearWithAnimation", ^{
            //setup
            id delegateMock = [KWMock mockForProtocol:@protocol(ABAppearingViewDelagate)];
            [delegateMock stub:@selector(appearingView:willAppearToFrame:animationType:duration:options:) andReturn:theValue(NO)];
            appearingView.delegate = delegateMock;
            
            //expected
            [[appearingView shouldNot] receive:@selector(prepareForAnimatedAppearance)];
            [[appearingView shouldNot] receive:@selector(setHidden:)];
            [[appearingView shouldNot] receive:@selector(appearWithAnimation)];
            
            //actual
            [appearingView appear];
        });
        
    });
    
    describe(@"-prepareForAnimatedAppearance", ^{
        
        it(@"should store the views frame, call the prep animation for phaseIn", ^{
            //setup
            [[theValue(appearingView.fullFrame) should] equal:theValue(CGRectZero)];
            __block BOOL iWasCalled = NO;
            FrameAnimationBlock mockAppearancePrepBlock = ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionBlock completed) {
                iWasCalled = YES;
            };
            
            //expected
            [[appearingView should] receive:@selector(appearancePrepBlock) andReturn:theValue(mockAppearancePrepBlock)];
            
            //actual
            [appearingView prepareForAnimatedAppearance];
            
            //assert
            [[theValue(appearingView.fullFrame) should] equal:theValue(initialFrame)];
            [[theValue(iWasCalled) should] beTrue];
        });
        
        it(@"should store the current clips to bounds and then set @clipsToBounds to YES", ^{
            //setup
            BOOL originalClipsToBounds = NO;
            appearingView.clipsToBounds = originalClipsToBounds;
            
            //expected
            [[appearingView should] receive:@selector(setOriginalClipsToBounds:) withArguments:theValue(originalClipsToBounds)];
            [[appearingView should] receive:@selector(setClipsToBounds:) withArguments:theValue(YES)];
            
            //actual
            [appearingView prepareForAnimatedAppearance];
        });
        
    });
    
    describe(@"-appearWithAnimation", ^{
        
        pending(@"should animate the view based on animationType and animationDuration", ^{
            //setup
            appearingView.animationDuration = 12.0f;
            
            //expected
            [[UIView should] receive:@selector(animateWithDuration:animations:completion:) withArguments:theValue(appearingView.animationDuration), any(), any()]; // any() <- just the block defined in the method itself
            
            //actual
            [appearingView appearWithAnimation];
        });
        
        it(@"should call the animation for phaseIn with self.fullFrame", ^{
            //setup
            CGRect expectedFrame = CGRectMake(1, 2, 3, 4);
            [[theValue(appearingView.fullFrame) should] equal:theValue(CGRectZero)];
            __block CGRect theFrame;
            FrameAnimationBlock mockAppearanceBlock = ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionBlock completed) {
                theFrame = frame;
            };
            
            //expected
            appearingView.fullFrame = expectedFrame;
            [[appearingView should] receive:@selector(appearanceBlock) andReturn:theValue(mockAppearanceBlock)];
            
            //actual
            [appearingView appearWithAnimation];
            
            //assert
            [[theValue(theFrame) should] equal:theValue(expectedFrame)];
        });
        
        pending(@"should notify the delegate and the notification center that it DID animate in, after it appearsWithAnimation", ^{
            //setup
            KWCaptureSpy *completionSpy = [UIView captureArgument:@selector(animateWithDuration:animations:completion:) atIndex:2];
            
            //expected
            [appearingView appearWithAnimation];
            void (^completionBlock)(BOOL finished) = completionSpy.argument;
            
            [[appearingView should] receive:@selector(notifyListenersDid:) withArguments:theValue(AnimationPhaseIn)];
            
            // actual
            completionBlock(YES);
        });
        
    });
    
});


describe(@"Disappearing", ^{
    
    __block ABAppearingView *appearingView;
    CGRect initialFrame = CGRectMake(0, 0, 100, 100);
    
    beforeEach(^{
        appearingView = [[ABAppearingView alloc] initWithFrame:initialFrame];
        appearingView.hidden = NO;
    });
    
    describe(@"-disappear", ^{
        
        it(@"should animate out", ^{
            //expected
            [[appearingView should] receive:@selector(disappearWithAnimation)];
            
            //actual
            [appearingView disappear];
        });
        
        it(@"should do nothing if appearingView is already invisible", ^{
            //setup
            appearingView.hidden = YES;
            
            //expected
            [[appearingView shouldNot] receive:@selector(disappearWithAnimation)];
            [[appearingView shouldNot] receive:@selector(setHidden:)];
            [[appearingView shouldNot] receive:@selector(resetView)];
            
            //actual
            [appearingView disappear];
        });
        
        it(@"should notify the delegate and the notification center that it is about to animate out", ^{
            // expected
            [[appearingView should] receive:@selector(notifyListenersWill:) withArguments:theValue(AnimationPhaseOut)];
            
            //actual
            [appearingView disappear];
        });
        
        it(@"should do nothing if the delegate responds NO to willDisappearWithAnimation", ^{
            //setup
            id delegateMock = [KWMock mockForProtocol:@protocol(ABAppearingViewDelagate)];
            [delegateMock stub:@selector(appearingView:willDisappearFromFrame:animationType:duration:options:) andReturn:theValue(NO)];
            appearingView.delegate = delegateMock;
            
            //expected
            [[appearingView shouldNot] receive:@selector(disappearWithAnimation)];
            [[appearingView shouldNot] receive:@selector(setHidden:)];
            [[appearingView shouldNot] receive:@selector(resetView)];
            
            //actual
            [appearingView disappear];
        });
        
    });
    
    describe(@"-disappearWithAnimation", ^{
        
        pending(@"should animate out, THEN become invisible, then return to its full frame", ^{
            //setup
            FrameAnimationBlock mockDisappearanceBlock = ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionBlock completed) {};
            KWCaptureSpy *completionSpy = [UIView captureArgument:@selector(animateWithDuration:animations:completion:) atIndex:2];
            
            //expected
            [[appearingView should] receive:@selector(disappearanceBlock) andReturn:theValue(mockDisappearanceBlock)];
            [[appearingView should] receive:@selector(setHidden:) withArguments:theValue(YES)];
            [[appearingView should] receive:@selector(resetView)];
            
            // actual
            [appearingView disappearWithAnimation];
            void (^completionBlock)(BOOL finished) = completionSpy.argument;
            completionBlock(YES);
            
        });
        
        
        pending(@"should notify the delegate and the notification center that it DID animate out, after it disappearsWithAnimation", ^{
            //setup
            KWCaptureSpy *completionSpy = [UIView captureArgument:@selector(animateWithDuration:animations:completion:) atIndex:2];
            
            //expected
            [appearingView disappearWithAnimation];
            void (^completionBlock)(BOOL finished) = completionSpy.argument;
            
            [[appearingView should] receive:@selector(notifyListenersDid:) withArguments:theValue(AnimationPhaseOut)];
            
            // actual
            completionBlock(YES);
        });
    });
    
    describe(@"-resetView", ^{
        
        it(@"should set the appearingViews frame to @fullFrame", ^{
            //setup
            CGRect expecetedFrame = CGRectMake(1, 2, 10, 20);
            appearingView.fullFrame = expecetedFrame;
            appearingView.frame = CGRectZero;
            
            // actual
            [appearingView resetView];
            
            //assertion
            [[theValue(appearingView.frame) should] equal:theValue(expecetedFrame)];
        });
        
        it(@"should set the @clipsToBounds prperty back to the original value", ^{
            //setup
            BOOL originalClipsToBounds = NO;
            appearingView.originalClipsToBounds = originalClipsToBounds;
            appearingView.clipsToBounds = YES;
            
            //actual
            [appearingView resetView];
            
            //assertion
            [[theValue(appearingView.clipsToBounds) should] equal:theValue(originalClipsToBounds)];
            
            // AGAIN
            
            //setup
            originalClipsToBounds = YES;
            appearingView.originalClipsToBounds = originalClipsToBounds;
            appearingView.clipsToBounds = YES;
            
            //actual
            [appearingView resetView];
            
            //assertion
            [[theValue(appearingView.clipsToBounds) should] equal:theValue(originalClipsToBounds)];
        });
        
        it(@"should call the RESET animation to reset the view to it's initial condition", ^{
            //setup
            __block BOOL resetWasCalled = NO;
            FrameAnimationBlock mockResetBlock = ^(UIView *view, CGRect frame, NSTimeInterval duration, CompletionBlock completed) {
                resetWasCalled = YES;
            };
            
            //expected
            [[appearingView should] receive:@selector(resetBlock) andReturn:mockResetBlock];
            
            //actual
            [appearingView resetView];
            
            //assertion
            [[theValue(resetWasCalled) should] beTrue];
        });
        
    });
    
});


SPEC_END
