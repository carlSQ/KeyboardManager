//
//  UIView+KeyboardAnimation.m
//  KeyboardManager
//
//  Created by 沈强 on 2017/1/19.
//  Copyright © 2017年 沈强. All rights reserved.
//

#import "UIView+KeyboardAnimation.h"
#import "NSObject+KeyboardAnimation.h"
#import <objc/runtime.h>

@implementation UIView (KeyboardAnimation)

+ (void)load {

  SEL originalSelector = NSSelectorFromString(@"dealloc");
  SEL swizzledSelector = NSSelectorFromString([@"kba_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
  Method originalMethod = class_getInstanceMethod(self, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
  
}

- (void)setViewWillAppearObserver:(id<NSObject>)viewWillAppearObserver {
  objc_setAssociatedObject(self, @selector(viewWillAppearObserver), viewWillAppearObserver, OBJC_ASSOCIATION_ASSIGN);
}

- (id<NSObject>)viewWillAppearObserver {
  return objc_getAssociatedObject(self, _cmd);
}

- (id<NSObject>)viewWillDisappearObserver {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setViewWillDisappearObserver:(id<NSObject>)viewWillDisappearObserver {
  objc_setAssociatedObject(self, @selector(viewWillDisappearObserver), viewWillDisappearObserver, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)viewController {
  
  UIResponder *nextResponder = [self nextResponder];
  
  do {
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
      
      return (UIViewController *)nextResponder;
      
    }
    
    nextResponder = [nextResponder nextResponder];
    
  } while (nextResponder);
  
  return nil;
  
}

- (void)kba_keyboardAnimationWithWillStart:(KeyboardAnimationWillStartBlock)willStart
                                 animation:(KeyboardAnimationBlock)animation
                         animationComplete:(KeyboardAnimationCompleteBlock)animationComplete {
  
  static dispatch_once_t token;
  
  dispatch_once(&token, ^{
   
#define KBA_REGISTER_ACTION \
    [self kba_registerKeyboardNotification];\
    [super kba_keyboardAnimationWithWillStart:willStart\
                                    animation:animation\
                            animationComplete:animationComplete];
    
  KBA_REGISTER_ACTION
    
  self.viewWillAppearObserver =  [[NSNotificationCenter defaultCenter] addObserverForName:@"keyboardAnimation_viewWillAppear"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                    if (note.object != [self viewController]) {
                                                      return;
                                                    }
                                                    KBA_REGISTER_ACTION
                                                    
    }];
    
   self.viewWillDisappearObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"keyboardAnimation_viewWillDisappear"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                    if (note.object != [self viewController]) {
                                                      return;
                                                    }
                                                    [self kba_clear];
    }];
  });
}

- (void)kba_dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self.viewWillAppearObserver];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self.viewWillDisappearObserver];
  
}

@end
