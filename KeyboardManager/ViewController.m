//
//  ViewController.m
//  KeyboardManager
//
//  Created by 沈强 on 2017/1/18.
//  Copyright © 2017年 沈强. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+KeyboardAnimation.h"
#import "UIView+KeyboardAnimation.h"

@interface ViewController ()<UITextViewDelegate>

@property(nonatomic, strong) UIView *inputBackgroundView;

@property(nonatomic, strong) UITextView *inputCommentView;

@property(nonatomic, strong) UIButton *showKeyboardView;

@end

@implementation ViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
    
  _inputBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 64)];
                                                                  
  _inputBackgroundView.backgroundColor = [UIColor greenColor];
                                                                  
  [self.view addSubview:_inputBackgroundView];
  
  _inputCommentView = [[UITextView alloc ] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 44)];
  _inputCommentView.delegate = self;
  _inputCommentView.backgroundColor = [UIColor whiteColor];
  _inputCommentView.secureTextEntry = YES;
  
  [_inputBackgroundView addSubview:_inputCommentView];
  
  [_inputBackgroundView kba_keyboardAnimationWithWillStart:nil
                                                 animation:^(CGRect startKeyboardRect, CGRect endKeyboardRect, NSTimeInterval duration, BOOL isShowing) {
    if (isShowing) {
      self.view.backgroundColor = [UIColor grayColor];
    } else {
      self.view.backgroundColor = [UIColor whiteColor];
    }
  }
                                         animationComplete:nil];
  
  _showKeyboardView = [UIButton buttonWithType:UIButtonTypeCustom];
  _showKeyboardView.backgroundColor = [UIColor redColor];
  [_showKeyboardView setTitle:@"showKeyboard" forState:UIControlStateNormal];
  _showKeyboardView.frame = CGRectMake(0, 0, 100, 40);
  _showKeyboardView.center = self.view.center;
  [self.view addSubview:_showKeyboardView];
  
  [_showKeyboardView addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  
  [self kba_keyboardAnimationWithWillStart:^(CGRect startKeyboardRect, CGRect keyboardRect, NSTimeInterval duration, BOOL willShow) {
    
  }                              animation:^(CGRect startKeyboardRect, CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
    
    if (isShowing) {
      _inputBackgroundView.frame = CGRectMake(0, keyboardRect.origin.y-64, [UIScreen mainScreen].bounds.size.width, 64);
    } else {
      _inputBackgroundView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 64);
    }
    
  }
                         animationComplete:^(BOOL finished) {
    
  }];
  
}

- (void)show {
  [_inputCommentView becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
  
  [super didReceiveMemoryWarning];
  
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
  
  if ([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  
  return YES;
  
}


@end
