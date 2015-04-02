//
// QTextFieldTableViewCell.m
//
// © Reaction Software Inc., 2013
//

#import "Symbolset/TRSymbolsetView.h"

#import "QTextFieldTableViewCell.h"

const CGFloat kDescriptionLabelTopMargin = 38.0f;
const CGFloat kIconLeftMargin = 11.0f;
const CGFloat kDescriptionLabelLeftMargin = 40.0f;
const CGFloat kDescriptionLabelRightMargin = 10.0f;
const CGFloat kDescriptionLabelBottomMargin = 8.0f;
const CGFloat kDescriptionLabelFontSize = 13.0f;

@implementation QTextFieldTableViewCell

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin = (CGPoint){ 10, 11 };
    self.textLabel.frame = textLabelFrame;

    CGSize labelSize = [self.textLabel sizeThatFits:CGSizeZero];
    CGRect contentBounds = self.contentView.bounds;
    CGRect textFieldFrame = textField.frame;

    if (labelSize.height == 0.0f)
    {
        textFieldFrame.origin= (CGPoint){ 10, 11 };
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
    textField.frame = textFieldFrame;

    CGPoint descriptionLabelOrigin = (CGPoint){ kDescriptionLabelLeftMargin, kDescriptionLabelTopMargin };
    CGRect bounds = self.contentView.bounds;
    CGSize size = (CGSize) { bounds.size.width-kDescriptionLabelLeftMargin-kDescriptionLabelRightMargin, bounds.size.height-kDescriptionLabelTopMargin-kDescriptionLabelBottomMargin };
    descriptionLabel.frame = (CGRect){ descriptionLabelOrigin, size };

    CGRect iconFrame = iconView.frame;
    iconFrame.origin = (CGPoint) { kIconLeftMargin, descriptionLabelOrigin.y };
    iconView.frame = iconFrame;
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.adjustsFontSizeToFitWidth = YES;
        textField.clearsOnBeginEditing = NO;
        textField.font = [UIFont systemFontOfSize:17.0];
        textField.minimumFontSize = 10.0;
        textField.textAlignment = NSTextAlignmentRight;
        textField.textColor = [UIColor colorWithRed:70.0f/255.0f green:96.0f/255.0f blue:133.0f/255.0f alpha:1.0f];

        [self.contentView addSubview:textField];
        
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        descriptionLabel.font = [UIFont systemFontOfSize:kDescriptionLabelFontSize];
        descriptionLabel.textColor = [UIColor grayColor];
        descriptionLabel.textAlignment = NSTextAlignmentLeft;
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.hidden = YES;
        descriptionLabel.numberOfLines = 0;
        [self.contentView addSubview:descriptionLabel];

        TRSymbolsetView *cautionView = [[TRSymbolsetView alloc] initWithSymbol:TRSymbolAlert size:24];
        cautionView.strokeColor = [UIColor grayColor];
        iconView = cautionView;
        iconView.hidden = YES;
        [self.contentView addSubview:iconView];
    }
    return self;
}

#pragma mark - QTextFieldTableViewCell

@synthesize textField;
@synthesize descriptionLabel;
@synthesize iconView;

@end