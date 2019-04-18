//
// RSTextFieldTableViewCell.m
//
// © Reaction Software Inc., 2013
//

#import <tgmath.h>

#import "Symbolset/RSSymbolsetView.h"

#import "RSTextFieldTableViewCell.h"

static const CGFloat kHorizontalSpacing = 10;
static const CGFloat kDescriptionLabelTopPadding = 8.0f;

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
    const UIEdgeInsets insets = self.layoutMargins;
    const CGSize titleLabelSizeConstraint = CGSizeMake(size.width-insets.left-insets.right, CGFLOAT_MAX);
    const CGSize titleLabelSize = [_titleLabel sizeThatFits:titleLabelSizeConstraint];

    if (_descriptionLabel.text == nil)
    {
        return CGSizeMake(size.width, titleLabelSize.height+insets.top+insets.bottom);
    }
    else
    {
        const CGSize descriptionLableSizeConstraint = CGSizeMake(size.width - insets.left - insets.right - _iconView.frame.size.width - kHorizontalSpacing, CGFLOAT_MAX);
        CGSize descriptionLabelSize = [_descriptionLabel sizeThatFits:descriptionLableSizeConstraint];
        return CGSizeMake(size.width, ceil(titleLabelSize.height + insets.top+insets.bottom + descriptionLabelSize.height + kDescriptionLabelTopPadding));
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    const CGRect bounds = self.contentView.bounds;
    const UIEdgeInsets insets = self.layoutMargins;

    const CGRect titleLabelFrame = self.titleLabel.frame;
    const CGSize titleLabelSize = [self.titleLabel sizeThatFits:bounds.size];

    CGRect textFieldFrame = _textField.frame;

    if (titleLabelSize.width > bounds.size.width/2)
    {
        // The text field will be place below the title label
        // TODO:
    }
    else
    {
        // the text field will be place next to the title label

        self.titleLabel.frame = (CGRect) { CGPointMake(insets.left, insets.top), titleLabelSize };
        if (titleLabelSize.height == 0)
        {
            textFieldFrame.origin = (CGPoint){ insets.left, insets.top };
            textFieldFrame.size.height = _textField.intrinsicContentSize.height;
            textFieldFrame.size.width = bounds.size.width - insets.left - insets.right;
        }
        else
        {
            textFieldFrame.origin.x = insets.left + titleLabelSize.width + kHorizontalSpacing;
            textFieldFrame.origin.y = insets.top;
            textFieldFrame.size.width = bounds.size.width - insets.left - insets.right - titleLabelSize.width - kHorizontalSpacing;
            textFieldFrame.size.height = titleLabelSize.height;
        }
        _textField.frame = textFieldFrame;

    }
    CGRect iconFrame = _iconView.frame;

    iconFrame.origin = CGPointMake(insets.left, textFieldFrame.origin.y + textFieldFrame.size.height + kDescriptionLabelTopPadding);
    _iconView.frame = iconFrame;

    CGPoint descriptionLabelOrigin = CGPointMake(insets.left + iconFrame.size.width + kHorizontalSpacing, iconFrame.origin.y);
    CGSize size = CGSizeMake(bounds.size.width - insets.left -  insets.right - iconFrame.size.width - kHorizontalSpacing,
                             bounds.size.height - insets.top - insets.bottom - titleLabelFrame.size.height - kDescriptionLabelTopPadding);
    _descriptionLabel.frame = (CGRect){ descriptionLabelOrigin, size };
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
    _titleLabel.textColor = [UIColor grayColor];
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
    _descriptionLabel.textColor = [UIColor grayColor];
    _descriptionLabel.textAlignment = NSTextAlignmentLeft;
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.hidden = YES;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;

    [self.contentView addSubview:_descriptionLabel];

    RSSymbolsetView *cautionView = [[RSSymbolsetView alloc] initWithSymbol:RSSymbolAlert size:24];
    cautionView.strokeColor = [UIColor grayColor];
    _iconView = cautionView;
    _iconView.hidden = YES;
    [self.contentView addSubview:_iconView];
}

#pragma mark RSPropertyEditorView

@synthesize titleLabel = _titleLabel;

@end
