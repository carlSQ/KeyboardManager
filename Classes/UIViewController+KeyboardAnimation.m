//
//  UIViewController+KeyboardManager.m
//  LPDCrowdsource
//
//  Created by 沈强 on 16/6/2.
//  Copyright © 2016年 elm. All rights reserved.
//

#import "UIViewController+KeyboardAnimation.h"
#import <objc/runtime.h>

@implementation UIViewController (KeyboardAnimation)

+ (void)load {
  
  SEL interceptedSelectors[] = {
    @selector(viewWillDisappear:),
    @selector(viewWillAppear:)
  };
  
  for (NSUInteger index = 0; index < sizeof(interceptedSelectors) / sizeof(SEL); ++index) {
    SEL originalSelector = interceptedSelectors[index];
    SEL swizzledSelector = NSSelectorFromString([@"kba_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
}

- (void)kba_viewWillAppear:(BOOL)animated {
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardAnimation_viewWillAppear" object:self];
  
  [self kba_registerKeyboardNotification];

  [self kba_viewWillAppear:animated];
}

- (void)kba_viewWillDisappear:(BOOL)animated {
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardAnimation_viewWillDisappear" object:self];
  
  [self kba_clear];
  
  [self kba_viewWillDisappear:animated];

}

@end
