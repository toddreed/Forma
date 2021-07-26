//
// Forma
// RSTextFieldTableViewCell.m
//
// © Reaction Software Inc. and Todd Reed, 2019
//
// Licensed under the MIT license. See LICENSE.md file in the project
// root or https://github.com/toddreed/Forma for full license
// information.
//

#import <tgmath.h>

#import "RSTextFieldTableViewCell.h"
#import "RSFormLibrary.h"
#import "RSBaseTableViewCell.h"


static const CGFloat kDefaultHorizontalSpacing = 10;
static const CGFloat kDefaultDescriptionLabelTopPadding = 8;
static const CGFloat kDefaultIconWidth = 21;


@interface RSTextFieldTableViewCell ()

@property (nonatomic, strong, nonnull) UILabel *titleLabel;
@property (nonatomic, strong, nonnull) UITextField *textField;
@property (nonatomic, strong, nonnull) UILabel *errorMessageLabel;
@property (nonatomic, strong, nonnull) UIImageView *errorImageView;

@end


@implementation RSTextFieldTableViewCell

#pragma mark - UIView

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self)
    {
        [self commonTextFieldTableViewCellInitialization];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    const CGFloat minimumHeight = RSBaseTableViewCell.minimumHeight;
    const UIEdgeInsets margins = self.layoutMargins;
    const CGFloat layoutWidth = size.width - margins.left - margins.right;

    UIFontMetrics *defaultFontMetrics = UIFontMetrics.defaultMetrics;

    const CGFloat errorLabelTopPadding = ceil([defaultFontMetrics scaledValueForValue:kDefaultDescriptionLabelTopPadding]);
    const CGFloat horizontalSpacing = ceil([defaultFontMetrics scaledValueForValue:kDefaultHorizontalSpacing]);
    const CGFloat iconWidth = ceil([defaultFontMetrics scaledValueForValue:kDefaultIconWidth]);

    // Layout the text field as if it were centered vertically in a minimum height cell…

    const CGSize textFieldSize = [_textField sizeThatFits:CGSizeMake(layoutWidth, CGFLOAT_MAX)];
    const CGFloat topSpacing = ceil((minimumHeight-textFieldSize.height)/2);
    const CGFloat bottomSpacing = minimumHeight-textFieldSize.height-topSpacing;
    const CGSize titleLabelSizeConstraint = CGSizeMake(layoutWidth, CGFLOAT_MAX);
    const CGSize titleLabelSize = [_titleLabel sizeThatFits:titleLabelSizeConstraint];

    if (_includeErrorInLayout)
    {
        const CGSize errorMessageLabelSizeConstraint = CGSizeMake(layoutWidth - iconWidth - horizontalSpacing, CGFLOAT_MAX);
        CGSize errorMessageLabelSize = [_errorMessageLabel sizeThatFits:errorMessageLabelSizeConstraint];
        return CGSizeMake(size.width, ceil(topSpacing + titleLabelSize.height + margins.bottom + errorMessageLabelSize.height + errorLabelTopPadding));
    }
    else
    {
        return CGSizeMake(size.width, ceil(MAX(minimumHeight, topSpacing+titleLabelSize.height+bottomSpacing)));
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    UIFontMetrics *defaultFontMetrics = UIFontMetrics.defaultMetrics;

    const CGFloat errorMessageLabelTopPadding = ceil([defaultFontMetrics scaledValueForValue:kDefaultDescriptionLabelTopPadding]);
    const CGFloat horizontalSpacing = ceil([defaultFontMetrics scaledValueForValue:kDefaultHorizontalSpacing]);

    const CGRect bounds = self.contentView.bounds;
    const CGFloat minimumHeight = RSBaseTableViewCell.minimumHeight;
    const UIEdgeInsets margins = self.layoutMargins;
    const CGFloat layoutWidth = bounds.size.width - margins.left - margins.right;

    // Layout the text field as if it were centered vertically in a minimum height cell…

    const CGSize textFieldSize = [_textField sizeThatFits:CGSizeMake(layoutWidth, CGFLOAT_MAX)];
    const CGFloat topLayoutY = ceil((minimumHeight-textFieldSize.height)/2);

    const CGSize titleLabelSize = [self.titleLabel sizeThatFits:bounds.size];
    const CGRect titleLabelFrame = (CGRect) { CGPointMake(margins.left, topLayoutY), titleLabelSize };
    _titleLabel.frame = titleLabelFrame;

    CGRect textFieldFrame = _textField.frame;

    textFieldFrame.origin.x = margins.left + titleLabelSize.width + horizontalSpacing;
    textFieldFrame.origin.y = topLayoutY;
    textFieldFrame.size.width = bounds.size.width - margins.left - margins.right - titleLabelSize.width - horizontalSpacing;
    textFieldFrame.size.height = textFieldSize.height;
    _textField.frame = textFieldFrame;

    if (_includeErrorInLayout)
    {
        const CGFloat iconWidth = ceil([defaultFontMetrics scaledValueForValue:kDefaultIconWidth]);

        CGRect iconImageViewFrame;

        iconImageViewFrame.origin = CGPointMake(margins.left, titleLabelFrame.origin.y + titleLabelFrame.size.height + errorMessageLabelTopPadding);
        iconImageViewFrame.size = CGSizeMake(iconWidth, iconWidth);
        _errorImageView.frame = iconImageViewFrame;

        const CGSize errorMessageLableSizeConstraint = CGSizeMake(layoutWidth - iconWidth - horizontalSpacing, CGFLOAT_MAX);
        const CGSize errorMessageLabelSizeThatFits = [_errorMessageLabel sizeThatFits:errorMessageLableSizeConstraint];

        CGPoint errorMessageLabelOrigin = CGPointMake(margins.left + iconWidth + horizontalSpacing, iconImageViewFrame.origin.y);
        CGSize size = CGSizeMake(layoutWidth - iconWidth - horizontalSpacing, ceil(errorMessageLabelSizeThatFits.height));
        _errorMessageLabel.frame = (CGRect){ errorMessageLabelOrigin, size };
    }
}

#pragma mark - UITableViewCell

#pragma mark - RSTextFieldTableViewCell

- (nonnull instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    [self commonTextFieldTableViewCellInitialization];
    return self;
}

- (void)commonTextFieldTableViewCellInitialization
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.adjustsFontForContentSizeCategory = YES;
    _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;

    [self.contentView addSubview:_titleLabel];

    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    _textField.adjustsFontForContentSizeCategory = YES;
    _textField.adjustsFontSizeToFitWidth = YES;
    _textField.clearsOnBeginEditing = NO;
    _textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _textField.minimumFontSize = 10.0;
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.textColor = [UIColor colorWithRed:70.0f/255.0f green:96.0f/255.0f blue:133.0f/255.0f alpha:1.0f];
    [self.contentView addSubview:_textField];

    _errorMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _errorMessageLabel.adjustsFontForContentSizeCategory = YES;
    _errorMessageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    _errorMessageLabel.textColor = [UIColor darkTextColor];
    _errorMessageLabel.textAlignment = NSTextAlignmentLeft;
    _errorMessageLabel.backgroundColor = [UIColor clearColor];
    _errorMessageLabel.hidden = YES;
    _errorMessageLabel.numberOfLines = 0;
    _errorMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;

    [self.contentView addSubview:_errorMessageLabel];

    UIImage *image = [UIImage systemImageNamed:@"exclamationmark.triangle.fill"];
    _errorImageView = [[UIImageView alloc] initWithImage:image];
    _errorImageView.image = image;
    _errorImageView.hidden = YES;
    _errorImageView.tintColor = UIColor.systemRedColor;
    [self.contentView addSubview:_errorImageView];
}

- (void)setIncludeErrorInLayout:(BOOL)includeDescriptionInLayout
{
    if (includeDescriptionInLayout && !_includeErrorInLayout)
    {
        _includeErrorInLayout = includeDescriptionInLayout;
        [self setNeedsLayout];
    }
    else if (!includeDescriptionInLayout && _includeErrorInLayout)
    {
        _includeErrorInLayout = includeDescriptionInLayout;
        [self setNeedsLayout];
    }
}

- (void)setShowError:(BOOL)showError
{
    _showError = showError;
    _errorImageView.hidden = !showError;
    _errorMessageLabel.hidden = !showError;
}

#pragma RSPropertyEditorView

@synthesize titleLabel = _titleLabel;

@end
