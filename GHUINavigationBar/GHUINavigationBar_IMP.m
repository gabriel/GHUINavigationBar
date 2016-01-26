//
//  GHUINavigationBar.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUINavigationBar_IMP.h"

#import <GHKit/GHCGUtils.h>

@interface GHUINavigationBar ()
@property (nonatomic) UILabel *titleLabel;
@property CGSize defaultContentViewSize;
@end

@implementation GHUINavigationBar

- (void)viewInit {
  _borderWidth = 0.5;
  _insets = UIEdgeInsetsMake(20, 0, 0, 0);
}

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self viewInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    [self viewInit];
  }
  return self;
}

- (CGRect)rectForLeftButton:(CGSize)size {
  if (!_leftButton) return CGRectZero;

  // Remove insets from height
  size.height -= _insets.top;

  CGRect leftCenter = GHCGRectCenterInSize(_leftButton.frame.size, size);
  return CGRectMake(5, leftCenter.origin.y + _insets.top, _leftButton.frame.size.width, _leftButton.frame.size.height);
}

- (CGRect)rectForRightButton:(CGSize)size {
  if (!_rightButton) return CGRectZero;

  // Remove insets from height
  size.height -= _insets.top;

  CGRect rightCenter = GHCGRectCenterInSize(_rightButton.frame.size, size);
  return CGRectMake(size.width - _rightButton.frame.size.width - 5, rightCenter.origin.y + _insets.top, _rightButton.frame.size.width, _rightButton.frame.size.height);
}

- (CGRect)rectForContentView:(CGSize)size {
  if (GHCGSizeIsEqual(size, CGSizeZero)) return CGRectZero;

  // Remove insets from height
  size.height -= _insets.top;

  CGRect leftRect = [self rectForLeftButton:size];
  CGRect rightRect = [self rectForRightButton:size];

  CGFloat maxContentWidth = (size.width - (leftRect.size.width + rightRect.size.width + 20));
  CGSize contentSize = [_contentView sizeThatFits:CGSizeMake(maxContentWidth, size.height)];
  if (contentSize.width > maxContentWidth) contentSize.width = maxContentWidth;
  if (GHCGSizeIsZero(contentSize)) contentSize = _defaultContentViewSize;
  // Let the content center adjust up a tiny bit
  CGRect contentCenter = GHCGRectCenterInSize(contentSize, CGSizeMake(size.width, size.height - 1));
  contentCenter.origin.y += _insets.top;

  // If content view width is more than the max, then left align.
  // If the left position of the content will overlap the left button, then also left align.
  // If the right position of the content will overlap the right button, then right align.
  // If the right position content centered content will overlap the right button, then fill exactly between left and right.
  // Otherwise center it.
  if (contentCenter.origin.x > maxContentWidth || contentCenter.origin.x < leftRect.size.width + 10) {
    return CGRectMake(leftRect.origin.x + leftRect.size.width + 5, contentCenter.origin.y, maxContentWidth, contentSize.height);
  } else if (!_leftButton && _rightButton && contentCenter.origin.x + contentCenter.size.width > (rightRect.origin.x - 10)) {
    return CGRectMake(rightRect.origin.x - maxContentWidth - 10, contentCenter.origin.y, maxContentWidth, contentSize.height);
  } else if (_leftButton && _rightButton && contentCenter.origin.x + contentCenter.size.width > (rightRect.origin.x - 10)) {
    return CGRectMake(leftRect.origin.x + leftRect.size.width + 5, contentCenter.origin.y, maxContentWidth, contentSize.height);
  } else {
    return CGRectMake(contentCenter.origin.x, contentCenter.origin.y, contentSize.width, contentSize.height);
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _leftButton.frame = [self rectForLeftButton:self.frame.size];
  _rightButton.frame = [self rectForRightButton:self.frame.size];
  _contentView.frame = [self rectForContentView:self.frame.size];
}

- (CGSize)sizeThatFits:(CGSize)size {
  return CGSizeMake(size.width, 44 + _insets.top);
}

- (UILabel *)titleLabel {
  if (!_titleLabel) {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.minimumScaleFactor = 0.25;
    _titleLabel.numberOfLines = 1;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.shadowColor = [UIColor darkGrayColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.opaque = NO;
    _titleLabel.contentMode = UIViewContentModeCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.userInteractionEnabled = NO;
  }
  return _titleLabel;
}

- (void)setTitle:(NSString *)title animated:(BOOL)animated {
  // For animated title transitions, we need to create a new titleLabel
  // so we can crossfade it with the old one
  //  if (animated) {
  //    UILabel *titleLabel = [self.titleLabel gh_copy];
  //    [_titleLabel release];
  //    _titleLabel = titleLabel;
  //  }
  self.titleLabel.text = title;
  [self.titleLabel sizeToFit];
  [self setContentView:self.titleLabel animated:animated];
}

- (void)setContentView:(UIView *)contentView {
  [self setContentView:contentView animated:NO];
}

- (void)setContentView:(UIView *)contentView animated:(BOOL)animated {
  if (contentView) {
    contentView.contentMode = UIViewContentModeCenter;
  }

  if (animated) {
    UIView *oldContentView = _contentView;
    _contentView = contentView;
    if (_contentView) {
      _contentView.alpha = 0.0;
      _defaultContentViewSize = _contentView.frame.size;
      _contentView.frame = [self rectForContentView:self.frame.size];
      [self addSubview:_contentView];
    }
    [UIView animateWithDuration:0.5 animations:^{
      oldContentView.alpha = 0.0;
      _contentView.alpha = 1.0;
    } completion:^(BOOL finished) {
      [oldContentView removeFromSuperview];
      oldContentView.alpha = 1.0;
    }];
  } else {
    CGPoint contentViewOrigin = CGPointZero;
    if (_contentView) contentViewOrigin = _contentView.frame.origin;
    [_contentView removeFromSuperview];
    _contentView = nil;
    if (contentView) {
      _contentView = contentView;
      _defaultContentViewSize = contentView.frame.size;
      _contentView.frame = CGRectMake(contentViewOrigin.x, contentViewOrigin.y, contentView.frame.size.width, contentView.frame.size.height);
      [self addSubview:_contentView];
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
  }
}

- (void)setLeftButton:(UIView *)leftButton {
  [self setLeftButton:leftButton animated:NO];
}

- (void)setLeftButton:(UIView *)leftButton animated:(BOOL)animated {
  if (animated) {
    UIView *oldLeftButton = _leftButton;
    CGFloat startAlpha = leftButton.alpha;
    _leftButton = leftButton;
    if (_leftButton) {
      _leftButton.alpha = 0.0;
      _leftButton.frame = [self rectForLeftButton:self.frame.size];
      [self addSubview:_leftButton];
    }
    [UIView animateWithDuration:0.5 animations:^{
      oldLeftButton.alpha = 0.0;
      _leftButton.alpha = startAlpha;
    } completion:^(BOOL finished) {
      [oldLeftButton removeFromSuperview];
      oldLeftButton.alpha = 1.0;
    }];
  } else {
    [_leftButton removeFromSuperview];
    _leftButton = nil;
    if (leftButton) {
      _leftButton = leftButton;
      [self addSubview:_leftButton];
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
  }
}

- (void)setRightButton:(UIView *)rightButton {
  [self setRightButton:rightButton animated:NO];
}

- (void)setRightButton:(UIView *)rightButton animated:(BOOL)animated {
  if (animated) {
    UIView *oldRightButton = _rightButton;
    CGFloat startAlpha = rightButton.alpha;
    _rightButton = rightButton;
    if (_rightButton) {
      _rightButton.alpha = 0.0;
      _rightButton.frame = [self rectForRightButton:self.frame.size];
      [self addSubview:_rightButton];
    }
    [UIView animateWithDuration:0.5 animations:^{
      oldRightButton.alpha = 0.0;
      _rightButton.alpha = startAlpha;
    } completion:^(BOOL finished) {
      [oldRightButton removeFromSuperview];
      oldRightButton.alpha = 1.0;
    }];
  } else {
    [_rightButton removeFromSuperview];
    _rightButton = nil;
    if (rightButton) {
      _rightButton = rightButton;
      [self addSubview:_rightButton];
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
  }
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  if (_fillColor) {
    GHCGContextDrawShading(context, _fillColor.CGColor, _fillColor2.CGColor, NULL, NULL, CGPointZero, CGPointMake(0, self.frame.size.height), GHUIShadingTypeLinear, NO, NO);
  }
  if (_topBorderColor) {
    // Border is actually halved since the top half is cut off (this is on purpose).
    GHCGContextDrawLine(context, 0, 0, self.frame.size.width, 0, _topBorderColor.CGColor, _borderWidth * 2);
  }
  if (_bottomBorderColor) {
    // Border is actually halved since the bottom half is cut off (this is on purpose).
    GHCGContextDrawLine(context, 0, self.frame.size.height, self.frame.size.width, self.frame.size.height, _bottomBorderColor.CGColor, _borderWidth * 2);
  }
  [super drawRect:rect];
}

@end
