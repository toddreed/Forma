//
// RSAutocompleteCell.m
//
// © Reaction Software Inc., 2013
//

#import "UITheme/RSUITheme.h"

#import "RSAutocompleteCell.h"

@implementation RSAutocompleteCell

#pragma mark - UIView

- (nonnull instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _textLabel.font = [[self class] font];
    _textLabel.textAlignment = NSTextAlignmentCenter;

    id<RSUITheme> theme = [RSUITheme currentTheme];
    _textLabel.backgroundColor = theme.backgroundColor;
    _textLabel.textColor = theme.selectedForegroundColor;

    _textLabel.layer.borderColor = theme.borderColor.CGColor;
    _textLabel.layer.borderWidth = 1.0f;
    _textLabel.layer.cornerRadius = 3.0f;

    [self.contentView addSubview:self.textLabel];

    return self;
}

#pragma mark - RSAutocompleteCell

+ (nonnull UIFont *)font
{
    id<RSUITheme> theme = [RSUITheme currentTheme];
    return [theme fontOfSize:16.0f];
}

+ (CGSize)preferredSizeForString:(nonnull NSString *)string
{
    UIFont *font = [[self class] font];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGSize size = [string sizeWithAttributes:attributes];
    size.width += 16.0f;
    size.height += 4.0f;
    return size;
}

@end