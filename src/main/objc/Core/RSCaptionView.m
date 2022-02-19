//
//  RSCaptionView.m
//  Forma
//
//  Created by Todd Reed on 2022-02-18.
//  Copyright © 2022 Reaction Software Inc. All rights reserved.
//

#import "RSCaptionView.h"
#import "RSCaption.h"


@implementation RSCaptionView
{
    UIImageView *_iconImageView;
    UILabel *_textLabel;
    UIStackView *_stackView;
}

- (nonnull instancetype)initWithCaption:(nonnull RSCaption *)caption
{
    self = [super initWithFrame:CGRectZero];

    UIImage *iconImage;
    UIColor *iconColor;
    UIColor *textColor = UIColor.secondaryLabelColor;

    switch (caption.type)
    {
        case RSCaptionTypePlain:
            break;

        case RSCaptionTypeInstructional:
            iconImage = [UIImage systemImageNamed:@"info.circle"];
            iconColor = UIColor.secondaryLabelColor;
            break;

        case RSCaptionTypeInformational:
            iconImage = [UIImage systemImageNamed:@"info.circle"];
            iconColor = UIColor.systemBlueColor;
            break;

        case RSCaptionTypeWarning:
            iconImage = [UIImage systemImageNamed:@"exclamationmark.triangle.fill"];
            iconColor = UIColor.systemYellowColor;
            break;

        case RSCaptionTypeError:
            iconImage = [UIImage systemImageNamed:@"exclamationmark.triangle.fill"];
            iconColor = UIColor.systemRedColor;
            textColor = UIColor.systemRedColor;
            break;
    }

    _iconImageView = [[UIImageView alloc] initWithImage:iconImage];
    _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _iconImageView.tintColor = iconColor;
    _iconImageView.preferredSymbolConfiguration = [UIImageSymbolConfiguration configurationWithTextStyle:UIFontTextStyleBody];
    [_iconImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_iconImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    _textLabel = [[UILabel alloc] init];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _textLabel.text = caption.text;
    _textLabel.adjustsFontForContentSizeCategory = YES;
    _textLabel.numberOfLines = 0;
    _textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    _textLabel.textColor = textColor;

    _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[_iconImageView, _textLabel]];
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    _stackView.axis = UILayoutConstraintAxisHorizontal;
    _stackView.alignment = UIStackViewAlignmentTop;
    _stackView.distribution = UIStackViewDistributionFill;
    _stackView.spacing = 10;

    [self addSubview:_stackView];

    [NSLayoutConstraint activateConstraints:@[
        [_stackView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [_stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
    ]];

    return self;
}

#pragma mark - UIView

- (CGSize)intrinsicContentSize
{
    return _stackView.intrinsicContentSize;
}

@end
