//
//  GHUINavigationBar.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/29/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
  GHUINavigationButtonStyleDefault = 0,
  GHUINavigationButtonStyleClose,
  GHUINavigationButtonStyleBack,
  GHUINavigationButtonStyleDone,
  GHUINavigationButtonStyleTranslucentBlack,
  GHUINavigationButtonStyleNone,
  GHUINavigationButtonStyleLabel
} GHUINavigationButtonStyle;

typedef enum {
  GHUINavigationPositionLeft = 0,
  GHUINavigationPositionRight = 1,
} GHUINavigationPosition;

@interface GHUINavigationBar : UIView

@property (retain, nonatomic) UIView *leftButton;
@property (retain, nonatomic) UIView *rightButton;
@property (retain, nonatomic) UIView *contentView;

@property (retain, nonatomic) UIColor *fillColor;
@property (retain, nonatomic) UIColor *fillColor2;
@property (retain, nonatomic) UIColor *topBorderColor;
@property (retain, nonatomic) UIColor *bottomBorderColor;
@property (assign, nonatomic) CGFloat borderWidth;
@property (assign, nonatomic) UIEdgeInsets insets;

/*!
 Set the content view to a UILabel with title.
 @param title
 @param animated
 */
- (void)setTitle:(NSString *)title animated:(BOOL)animated;

/*!
 @result Title label
 */
- (UILabel *)titleLabel;

/*!
 Set the content view.
 Content view must return a valid sizeThatFits: method.
 @param contentView
 @param animated
 */
- (void)setContentView:(UIView *)contentView animated:(BOOL)animated;

/*!
 Set right button.
 @param rightButton
 @param animated
 */
- (void)setRightButton:(UIView *)rightButton animated:(BOOL)animated;

/*!
 Set left button.
 @param leftButton
 @param animated
 */
- (void)setLeftButton:(UIView *)leftButton animated:(BOOL)animated;

@end
