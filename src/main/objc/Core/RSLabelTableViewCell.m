//
//  RSLabelTableViewCell.m
//  Forma
//
//  Created by Todd Reed on 2019-04-17.
//  Copyright © 2019 Reaction Software Inc. All rights reserved.
//

#import <tgmath.h>

#import "RSLabelTableViewCell.h"
#import "RSBaseTableViewCell.h"


typedef struct RSLabelTableViewCellLayout
{
    bool valid;
    CGSize sizeThatFits;
    CGRect titleLabelFrame;
    CGRect valueLabelFrame;
} RSLabelTableViewCellLayout;

static const CGFloat kDefaultHorizontalSpacing = 10;


@interface RSLabelTableViewCell ()

@property (nonatomic, strong, nonnull) UILabel *titleLabel;
@property (nonatomic, strong, nonnull) UILabel *valueLabel;

@end


@implementation RSLabelTableViewCell
{
    RSLabelTableViewCellLayout _cachedLayout;
}

#pragma mark - NSObject

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (nonnull instancetype)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [self commonLabelTableViewCellInitialization];
    return self;
}

#pragma mark - UIView

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self)
    {
        [self commonLabelTableViewCellInitialization];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    bool cachedLayoutValid = _cachedLayout.valid && _cachedLayout.sizeThatFits.width == size.width;
    if (!cachedLayoutValid)
        [self computeSubviewLayout:&_cachedLayout forWidth:size.width];

    return _cachedLayout.sizeThatFits;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect bounds = self.bounds;
    bool cachedLayoutValid = _cachedLayout.valid && _cachedLayout.sizeThatFits.width == bounds.size.width;
    if (!cachedLayoutValid)
        [self computeSubviewLayout:&_cachedLayout forWidth:bounds.size.width];

    _titleLabel.frame = _cachedLayout.titleLabelFrame;
    _valueLabel.frame = _cachedLayout.valueLabelFrame;
}

#pragma mark - UITableViewCell

#pragma mark - RSLabelTableViewCell

- (void)computeSubviewLayout:(RSLabelTableViewCellLayout *)layout forWidth:(CGFloat)width
{
    UIFontMetrics *defaultFontMetrics = UIFontMetrics.defaultMetrics;

    const CGFloat horizontalSpaceAllocatedForTitleLabel = 0.66f;

    const CGFloat horizontalSpacing = ceil([defaultFontMetrics scaledValueForValue:kDefaultHorizontalSpacing]);
    const CGFloat minimumHeight = RSBaseTableViewCell.minimumHeight;
    const UIEdgeInsets margins = self.layoutMargins;
    const CGFloat layoutWidth = width - margins.left - margins.right;
    const CGFloat titleLabelWidth = ceil(horizontalSpaceAllocatedForTitleLabel*(layoutWidth-horizontalSpacing));
    const CGFloat valueLabelWidth = layoutWidth-titleLabelWidth-horizontalSpacing;

    // Layout the label as if it were centered vertically in the minimum height cell…

    const CGSize valueLabelSize = [_valueLabel sizeThatFits:CGSizeMake(valueLabelWidth, CGFLOAT_MAX)];
    const CGFloat topSpacing = ceil((minimumHeight-valueLabelSize.height)/2);
    const CGFloat bottomSpacing = minimumHeight-valueLabelSize.height-topSpacing;
    const CGSize titleLabelSizeConstraint = CGSizeMake(titleLabelWidth, CGFLOAT_MAX);
    const CGSize titleLabelSize = [_titleLabel sizeThatFits:titleLabelSizeConstraint];

    layout->titleLabelFrame = CGRectMake(margins.left, topSpacing, titleLabelWidth, titleLabelSize.height);
    layout->valueLabelFrame = CGRectMake(margins.left + titleLabelWidth + horizontalSpacing, topSpacing, valueLabelWidth, valueLabelSize.height);
    layout->sizeThatFits = CGSizeMake(width, ceil(MAX(minimumHeight, topSpacing+titleLabelSize.height+bottomSpacing)));
    layout->valid = true;
}

- (void)commonLabelTableViewCellInitialization
{
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(contentSizeCategoryDidChangeNotification:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.adjustsFontForContentSizeCategory = YES;
    _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;

    [self.contentView addSubview:_titleLabel];

    _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _valueLabel.adjustsFontForContentSizeCategory = YES;
    _valueLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _valueLabel.textAlignment = NSTextAlignmentRight;
    _valueLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_valueLabel];
}

- (void)contentSizeCategoryDidChangeNotification:(NSNotification *)notfication
{
    _cachedLayout.valid = false;
}

#pragma RSPropertyEditorView

@synthesize titleLabel = _titleLabel;

@end
