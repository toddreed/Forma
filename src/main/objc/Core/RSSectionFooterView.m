//
//  RSSectionFooterView.m
//  Forma
//
//  Created by Todd Reed on 2022-02-18.
//  Copyright © 2022 Reaction Software Inc. All rights reserved.
//

#import "RSSectionFooterView.h"

@implementation RSSectionFooterView
{
    UILabel *_label;
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

    UIView *contentView = self.contentView;

    [contentView addSubview:_label];

    UILayoutGuide *contentMarginsGuide = contentView.layoutMarginsGuide;

    [NSLayoutConstraint activateConstraints:@[
        [_label.leadingAnchor constraintEqualToAnchor:contentMarginsGuide.leadingAnchor],
        [_label.trailingAnchor constraintEqualToAnchor:contentMarginsGuide.trailingAnchor],
        [_label.topAnchor constraintEqualToAnchor:contentMarginsGuide.topAnchor],
        [_label.bottomAnchor constraintEqualToAnchor:contentMarginsGuide.bottomAnchor]
    ]];
    return self;
}

@end
