//
// Forma
// RSTableHeaderImageView.h
//
// © Reaction Software Inc. and Todd Reed, 2021
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <UIKit/UIKit.h>

/// RSTableHeaderImageView is a view that contains an image. RSTableHeaderImageView is intended
/// to be used as a table header view for RSFormViewController, typically to display a logo
/// image.
@interface RSTableHeaderImageView : UIView

@property (nonatomic, readonly, nonnull) UIImage *image;

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
- (nonnull instancetype)initWithImage:(nonnull UIImage *)image NS_DESIGNATED_INITIALIZER;

@end
