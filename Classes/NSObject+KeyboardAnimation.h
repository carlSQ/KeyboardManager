//
//  NSObject+KeyboardAnimation.h
//  KeyboardManager
//
//  Created by 沈强 on 2017/1/19.
//  Copyright © 2017年 沈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^KeyboardAnimationWillStartBlock)(CGRect startKeyboardRect, CGRect endKeyboardRect, NSTimeInterval duration, BOOL willShow);

typedef void(^KeyboardAnimationBlock)(CGRect startKeyboardRect, CGRect endKeyboardRect, NSTimeInterval duration, BOOL isShowing);

typedef void(^KeyboardAnimationCompleteBlock)(BOOL finished);

@interface NSObject (KeyboardAnimation)

- (void)kba_registerKeyboardNotification;

- (void)kba_keyboardAnimationWithWillStart:(KeyboardAnimationWillStartBlock)willStart
                                 animation:(KeyboardAnimationBlock)animation
                         animationComplete:(KeyboardAnimationCompleteBlock)animationComplete;


- (void)kba_clear;

@end
