//
//  LRNContainerView.m
//  LottieReactNative
//
//  Created by Leland Richardson on 12/12/16.
//  Copyright © 2016 Airbnb. All rights reserved.
//

#import "LRNContainerView.h"

// import NS/UIView+React.h
#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR

#if __has_include(<React/UIView+React.h>)
#import <React/UIView+React.h>
#elif __has_include("UIView+React.h")
#import "UIView+React.h"
#else
#import "React/UIView+React.h"
#endif

#else

#if __has_include(<React/UIView+React.h>)
#import <React/NSView+React.h>
#elif __has_include("NSView+React.h")
#import "NSView+React.h"
#else
#import "React/NSView+React.h"
#endif

#endif

@implementation LRNContainerView {
  LOTAnimationView *_animationView;
}

- (void)reactSetFrame:(CGRect)frame
{
  [super reactSetFrame:frame];
  if (_animationView != nil) {
    [_animationView reactSetFrame:frame];
  }
}

- (void)setProgress:(CGFloat)progress {
  _progress = progress;
  if (_animationView != nil) {
    _animationView.animationProgress = _progress;
  }
}

- (void)setSpeed:(CGFloat)speed {
  _speed = speed;
  if (_animationView != nil) {
    _animationView.animationSpeed = _speed;
  }
}

- (void)setLoop:(BOOL)loop {
  _loop = loop;
  if (_animationView != nil) {
    _animationView.loopAnimation = _loop;
  }
}

- (void)setResizeMode:(NSString *)resizeMode {
  if ([resizeMode isEqualToString:@"cover"]) {
    [_animationView setContentMode:LOTViewContentModeScaleAspectFill];
  } else if ([resizeMode isEqualToString:@"contain"]) {
    [_animationView setContentMode:LOTViewContentModeScaleAspectFill];
  } else if ([resizeMode isEqualToString:@"center"]) {
    [_animationView setContentMode:LOTViewContentModeCenter];
  }
}

- (void)setSourceJson:(NSString *)jsonString {
  NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:kNilOptions
                                                         error:nil];
  [self replaceAnimationView:[LOTAnimationView animationFromJSON:json]];
}

- (void)setSourceName:(NSString *)name {
  [self replaceAnimationView:[LOTAnimationView animationNamed:name]];
}

- (void)play {
  if (_animationView != nil) {
    [_animationView play];
  }
}

- (void)play:(nullable LOTAnimationCompletionBlock)completion {
  if (_animationView != nil) {
    if (completion != nil) {
      [_animationView playWithCompletion:completion];
    } else {
      [_animationView play];
    }
  }
}

- (void)playFromFrame:(NSNumber *)startFrame
              toFrame:(NSNumber *)endFrame
       withCompletion:(nullable LOTAnimationCompletionBlock)completion {
  if (_animationView != nil) {
    [_animationView playFromFrame:startFrame
                          toFrame:endFrame withCompletion:completion];
  }
}

- (void)reset {
  if (_animationView != nil) {
    _animationView.animationProgress = 0;
    [_animationView pause];
  }
}

# pragma mark Private

- (void)replaceAnimationView:(LOTAnimationView *)next {
  LOTViewContentMode contentMode = LOTViewContentModeScaleAspectFit;
  if (_animationView != nil) {
    contentMode = _animationView.contentMode;
    [_animationView removeFromSuperview];
  }
  _animationView = next;
  [self addSubview: next];
  [_animationView reactSetFrame:self.frame];
  [_animationView setContentMode:contentMode];
  [self applyProperties];
}

- (void)applyProperties {
  _animationView.animationProgress = _progress;
  _animationView.animationSpeed = _speed;
  _animationView.loopAnimation = _loop;
}

@end
