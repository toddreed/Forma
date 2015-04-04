//
// RSTextFieldTableViewCell.m
//
// © Reaction Software Inc., 2013
//

#import "Symbolset/RSSymbolsetView.h"

#import "RSTextFieldTableViewCell.h"

const CGFloat kDescriptionLabelTopMargin = 38.0f;
const CGFloat kIconLeftMargin = 20.0f;
const CGFloat kDescriptionLabelLeftMargin = 40.0f;
const CGFloat kDescriptionLabelRightMargin = 20.0f;
const CGFloat kDescriptionLabelBottomMargin = 8.0f;
const CGFloat kDescriptionLabelFontSize = 13.0f;

@implementation RSTextFieldTableViewCell

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin = (CGPoint){ self.indentationWidth, 11 };
    self.textLabel.frame = textLabelFrame;

    CGSize labelSize = [self.textLabel sizeThatFits:CGSizeZero];
    CGRect contentBounds = self.contentView.bounds;
    CGRect textFieldFrame = _textField.frame;

    if (labelSize.height == 0.0f)
    {
        textFieldFrame.origin= (CGPoint){ self.indentationWidth, 11 };
        textFieldFrame.size.height = contentBounds.size.height - 20;
        textFieldFrame.size.width = contentBounds.size.width - 20;
    }
    else
    {
        textFieldFrame.size.height = labelSize.height;
        textFieldFrame.origin.x = textLabelFrame.origin.x + labelSize.width + 10;
        textFieldFrame.origin.y = textLabelFrame.origin.y;
        textFieldFrame.size.width = contentBounds.size.width - textFieldFrame.origin.x - textLabelFrame.origin.x;
    }
    _textField.frame = textFieldFrame;

    CGPoint descriptionLabelOrigin = (CGPoint){ kDescriptionLabelLeftMargin, kDescriptionLabelTopMargin };
    CGRect bounds = self.contentView.bounds;
    CGSize size = (CGSize) { bounds.size.width-kDescriptionLabelLeftMargin-kDescriptionLabelRightMargin, bounds.size.height-kDescriptionLabelTopMargin-kDescriptionLabelBottomMargin };
    _descriptionLabel.frame = (CGRect){ descriptionLabelOrigin, size };

    CGRect iconFrame = _iconView.frame;
    iconFrame.origin = (CGPoint) { kIconLeftMargin, descriptionLabelOrigin.y };
    _iconView.frame = iconFrame;
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        self.indentationWidth = 20.0f;

        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.adjustsFontSizeToFitWidth = YES;
        _textField.clearsOnBeginEditing = NO;
        _textField.font = [UIFont systemFontOfSize:17.0];
        _textField.minimumFontSize = 10.0;
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.textColor = [UIColor colorWithRed:70.0f/255.0f green:96.0f/255.0f blue:133.0f/255.0f alpha:1.0f];

        [self.contentView addSubview:_textField];
        
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descriptionLabel.font = [UIFont systemFontOfSize:kDescriptionLabelFontSize];
        _descriptionLabel.textColor = [UIColor grayColor];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.hidden = YES;
        _descriptionLabel.numberOfLines = 0;
        [self.contentView addSubview:_descriptionLabel];

        RSSymbolsetView *cautionView = [[RSSymbolsetView alloc] initWithSymbol:RSSymbolAlert size:24];
        cautionView.strokeColor = [UIColor grayColor];
        _iconView = cautionView;
        _iconView.hidden = YES;
        [self.contentView addSubview:_iconView];
    }
    return self;
}

#pragma mark - RSTextFieldTableViewCell

@end
