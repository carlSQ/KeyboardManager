# CSSLayout

[![CI Status](http://img.shields.io/travis/carlSQ/CSSLayout.svg?style=flat)](https://travis-ci.org/carlSQ/KeyboardManager)
[![Version](https://img.shields.io/cocoapods/v/KeyboardManager.svg?style=flat)](http://cocoapods.org/pods/KeyboardManager)
[![License](https://img.shields.io/cocoapods/l/KeyboardManager.svg?style=flat)](http://cocoapods.org/pods/KeyboardManager)
[![Platform](https://img.shields.io/cocoapods/p/KeyboardManager.svg?style=flat)](http://cocoapods.org/pods/KeyboardManager)


## Example

To run the example project, clone the repo.


## Installation

KeyboardManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KeyboardManager"
```

## Usage


###  KeyboardManager in UIViewCintroller

You should call in viewWillAppear method

``` objc

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

```

### KeyboardManager in UIView

You should call before UIViewCintroller viewWillAppear method 

``` objc

[view kba_keyboardAnimationWithWillStart:nil
                               animation:^(CGRect startKeyboardRect, CGRect endKeyboardRect, NSTimeInterval duration, BOOL isShowing) {
                                   ...
                                }
                       animationComplete:nil];

```

## License
KeyboardManager is available under the MIT license. See the LICENSE file for more info.
