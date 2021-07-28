//
// Forma
// RSTableHeaderImageView.m
//
// © Reaction Software Inc. and Todd Reed, 2021
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSTableHeaderImageView.h"


@implementation RSTableHeaderImageView

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

#pragma mark - RSTableHeaderImageView

- (instancetype)initWithImage:(nonnull UIImage *)image
{
    NSParameterAssert(image != nil);

    self = [super initWithFrame:CGRectZero];
    self.translatesAutoresizingMaskIntoConstraints = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;

    _image = image;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

    imageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:imageView];
    [NSLayoutConstraint activateConstraints:@[
        [imageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [imageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:20],
        [self.bottomAnchor constraintGreaterThanOrEqualToAnchor:imageView.bottomAnchor constant:20]
    ]];
    return self;
}

@end
