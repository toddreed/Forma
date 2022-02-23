//
// Forma
// RSSelectionSectionHeaderView.m
//
// © Reaction Software Inc. and Todd Reed, 2022
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import "RSSelectionSectionHeaderView.h"

@implementation RSSelectionSectionHeaderView
{
    UILabel *_label;
    UIImageView *_imageView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];

    _label = [[UILabel alloc] init];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    _label.adjustsFontForContentSizeCategory = YES;
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.textColor = UIColor.secondaryLabelColor;

    _imageView = [[UIImageView alloc] init];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_imageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_label, _imageView]];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.alignment = UIStackViewAlignmentTop;
    stackView.spacing = 16;

    UIView *contentView = self.contentView;

    [contentView addSubview:stackView];

    UILayoutGuide *contentMarginsGuide = contentView.layoutMarginsGuide;

    [NSLayoutConstraint activateConstraints:@[
        [stackView.leadingAnchor constraintEqualToAnchor:contentMarginsGuide.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:contentMarginsGuide.trailingAnchor],
        [stackView.topAnchor constraintEqualToAnchor:contentMarginsGuide.topAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:contentMarginsGuide.bottomAnchor]
    ]];
    return self;
}

@end
