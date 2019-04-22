//
// RSTextFieldTableViewCell.m
//
// © Reaction Software Inc., 2013
//

#import <tgmath.h>

#import "RSTextFieldTableViewCell.h"
#import "RSObjectEditor.h"
#import "RSBaseTableViewCell.h"


static const CGFloat kDefaultHorizontalSpacing = 10;
static const CGFloat kDefaultDescriptionLabelTopPadding = 8;
static const CGFloat kDefaultIconWidth = 21;


@interface RSTextFieldTableViewCell ()

@property (nonatomic, strong, nonnull) UILabel *titleLabel;
@property (nonatomic, strong, nonnull) UITextField *textField;
@property (nonatomic, strong, nonnull) UILabel *descriptionLabel;
@property (nonatomic, strong, nonnull) UIImageView *iconImageView;

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

    const CGFloat descriptionLabelTopPadding = ceil([defaultFontMetrics scaledValueForValue:kDefaultDescriptionLabelTopPadding]);
    const CGFloat horizontalSpacing = ceil([defaultFontMetrics scaledValueForValue:kDefaultHorizontalSpacing]);
    const CGFloat iconWidth = ceil([defaultFontMetrics scaledValueForValue:kDefaultIconWidth]);

    // Layout the text field as if it were centered vertically in a minimum height cell…

    const CGSize textFieldSize = [_textField sizeThatFits:CGSizeMake(layoutWidth, CGFLOAT_MAX)];
    const CGFloat topLayoutY = ceil((minimumHeight-textFieldSize.height)/2);
    const CGSize titleLabelSizeConstraint = CGSizeMake(layoutWidth, CGFLOAT_MAX);
    const CGSize titleLabelSize = [_titleLabel sizeThatFits:titleLabelSizeConstraint];

    if (_includeDescriptionInLayout)
    {
        const CGSize descriptionLableSizeConstraint = CGSizeMake(layoutWidth - iconWidth - horizontalSpacing, CGFLOAT_MAX);
        CGSize descriptionLabelSize = [_descriptionLabel sizeThatFits:descriptionLableSizeConstraint];
        return CGSizeMake(size.width, ceil(topLayoutY + titleLabelSize.height + margins.bottom + descriptionLabelSize.height + descriptionLabelTopPadding));
    }
    else
    {
        return CGSizeMake(size.width, ceil(MAX(minimumHeight, topLayoutY+titleLabelSize.height+margins.bottom)));
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    UIFontMetrics *defaultFontMetrics = UIFontMetrics.defaultMetrics;

    const CGFloat descriptionLabelTopPadding = ceil([defaultFontMetrics scaledValueForValue:kDefaultDescriptionLabelTopPadding]);
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

    if (_includeDescriptionInLayout)
    {
        const CGFloat iconWidth = ceil([defaultFontMetrics scaledValueForValue:kDefaultIconWidth]);

        CGRect iconImageViewFrame;

        iconImageViewFrame.origin = CGPointMake(margins.left, titleLabelFrame.origin.y + titleLabelFrame.size.height + descriptionLabelTopPadding);
        iconImageViewFrame.size = CGSizeMake(iconWidth, iconWidth);
        _iconImageView.frame = iconImageViewFrame;

        const CGSize descriptionLableSizeConstraint = CGSizeMake(layoutWidth - iconWidth - horizontalSpacing, CGFLOAT_MAX);
        const CGSize descriptionLabelSizeThatFits = [_descriptionLabel sizeThatFits:descriptionLableSizeConstraint];

        CGPoint descriptionLabelOrigin = CGPointMake(margins.left + iconWidth + horizontalSpacing, iconImageViewFrame.origin.y);
        CGSize size = CGSizeMake(layoutWidth - iconWidth - horizontalSpacing, ceil(descriptionLabelSizeThatFits.height));
        _descriptionLabel.frame = (CGRect){ descriptionLabelOrigin, size };
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

    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _descriptionLabel.adjustsFontForContentSizeCategory = YES;
    _descriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    _descriptionLabel.textColor = [UIColor darkTextColor];
    _descriptionLabel.textAlignment = NSTextAlignmentLeft;
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.hidden = YES;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;

    [self.contentView addSubview:_descriptionLabel];

    UIImage *image = [UIImage imageNamed:@"Error" inBundle:RSObjectEditor.bundle compatibleWithTraitCollection:nil];
    _iconImageView = [[UIImageView alloc] initWithImage:image];
    _iconImageView.image = image;
    _iconImageView.hidden = YES;
    [self.contentView addSubview:_iconImageView];
}

- (void)setIncludeDescriptionInLayout:(BOOL)includeDescriptionInLayout
{
    if (includeDescriptionInLayout && !_includeDescriptionInLayout)
    {
        _includeDescriptionInLayout = includeDescriptionInLayout;
        [self setNeedsLayout];
    }
    else if (!includeDescriptionInLayout && _includeDescriptionInLayout)
    {
        _includeDescriptionInLayout = includeDescriptionInLayout;
        [self setNeedsLayout];
    }
}

- (void)setShowDescription:(BOOL)showDescription
{
    _showDescription = showDescription;
    _iconImageView.hidden = !showDescription;
    _descriptionLabel.hidden = !showDescription;
}

#pragma mark RSPropertyEditorView

@synthesize titleLabel = _titleLabel;

@end
