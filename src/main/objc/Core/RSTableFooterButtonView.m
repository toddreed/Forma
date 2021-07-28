//
// Forma
// RSTableFooterButtonView.m
//
// © Reaction Software Inc. and Todd Reed, 2021
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSTableFooterButtonView.h"


@implementation RSTableFooterButtonView

#pragma mark - UIView

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize targetSize = CGSizeMake(size.width, UILayoutFittingCompressedSize.height);
    CGSize fittingSize = [self systemLayoutSizeFittingSize:targetSize
                             withHorizontalFittingPriority:UILayoutPriorityRequired
                                   verticalFittingPriority:UILayoutPriorityFittingSizeLevel];
    fittingSize.height = ceil(fittingSize.height);
    return fittingSize;
}

#pragma mark - RSTableFooterButtonView

- (instancetype)initWithButton:(nonnull UIButton *)button
{
    NSParameterAssert(button != nil);

    self = [super initWithFrame:CGRectZero];
    self.translatesAutoresizingMaskIntoConstraints = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;

    _button = button;
    _button.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:_button];
    [NSLayoutConstraint activateConstraints:@[
        [_button.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [_button.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [_button.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
        [self.bottomAnchor constraintGreaterThanOrEqualToAnchor:_button.bottomAnchor constant:10],
        [_button.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.8]
    ]];
    return self;
}

@end
