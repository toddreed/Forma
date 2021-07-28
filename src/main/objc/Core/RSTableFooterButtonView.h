//
// Forma
// RSTableFooterButtonView.h
//
// © Reaction Software Inc. and Todd Reed, 2021
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <UIKit/UIKit.h>


/// RSTableFooterButtonView is a view that contains a button. RSTableFooterButtonView is
/// intended to be used as a table footer view for RSFormViewController to contain a form
/// “submit” button.
@interface RSTableFooterButtonView : UIView

@property (nonatomic, readonly, nonnull) UIButton *button;

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithButton:(nonnull UIButton *)button NS_DESIGNATED_INITIALIZER;

@end

