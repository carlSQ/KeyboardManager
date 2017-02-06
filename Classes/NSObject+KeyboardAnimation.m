//
//  NSObject+KeyboardAnimation.m
//  KeyboardManager
//
//  Created by 沈强 on 2017/1/19.
//  Copyright © 2017年 沈强. All rights reserved.
//

#import "NSObject+KeyboardAnimation.h"
#import <objc/runtime.h>

static void *KeyboardAnimationWillStartBlockKey = @"kba_KeyboardAnimationWillStartBlockKey";

static void *KeyboardAnimationBlockKey = @"kba_KeyboardAnimationBlockKey";

static void *KeyboardAnimationCompleteBlockKey = @"kba_KeyboardAnimationCompleteBlockKey";

@implementation NSObject (KeyboardAnimation)

- (BOOL)kba_hasRegisterKeyboardNotification {
  
  return [objc_getAssociatedObject(self, _cmd) boolValue];
  
}

- (void)setKba_hasRegisterKeyboardNotification:(BOOL)hasRegister {
  objc_setAssociatedObject(self, @selector(kba_hasRegisterKeyboardNotification), @(hasRegister), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)kba_keyboardAnimationWithWillStart:(KeyboardAnimationWillStartBlock)willStart
                                 animation:(KeyboardAnimationBlock)animation
                         animationComplete:(KeyboardAnimationCompleteBlock)animationComplete {
  
  objc_setAssociatedObject(self, KeyboardAnimationWillStartBlockKey, willStart, OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, KeyboardAnimationBlockKey, animation, OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, KeyboardAnimationCompleteBlockKey, animationComplete, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)kba_registerKeyboardNotification {
  
  if ([self kba_hasRegisterKeyboardNotification]) {
    return;
  }
  self.kba_hasRegisterKeyboardNotification = YES;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kba_willShow:) name:UIKeyboardWillShowNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kba_willHidden:) name:UIKeyboardWillHideNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kba_willChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)kba_willShow:(NSNotification *)notification {
  [self kba_aniamation:notification show:YES];
}

- (void)kba_willHidden:(NSNotification *)notification  {
  [self kba_aniamation:notification show:NO];
}


- (void)kba_willChangeFrame:(NSNotification *)notification {
  [self kba_aniamation:notification show:YES];
}

- (void)kba_aniamation:(NSNotification *)notification show:(BOOL)show {
  
  NSDictionary *userInfo = notification.userInfo;
  CGRect startRect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  
  CGRect endRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  
  CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  
  UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
  
  KeyboardAnimationWillStartBlock willStart = objc_getAssociatedObject(self, KeyboardAnimationWillStartBlockKey);
  KeyboardAnimationBlock animation = objc_getAssociatedObject(self, KeyboardAnimationBlockKey);
  KeyboardAnimationCompleteBlock animationComplete = objc_getAssociatedObject(self, KeyboardAnimationCompleteBlockKey);
  
  if (willStart) {
    willStart(startRect, endRect, duration, show);
  }
  
  if (duration == 0 && animation) {
    
    animation(startRect, endRect, duration,show);
    
  } else {
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                       [UIView setAnimationCurve:animationCurve];
                       if (animation) {
                         animation(startRect, endRect, duration,show);
                       }
                     }
                     completion:animationComplete];
    
  }
  
}

- (void)kba_clear {
  self.kba_hasRegisterKeyboardNotification = NO;
  objc_setAssociatedObject(self, KeyboardAnimationWillStartBlockKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, KeyboardAnimationBlockKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, KeyboardAnimationCompleteBlockKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}


@end
