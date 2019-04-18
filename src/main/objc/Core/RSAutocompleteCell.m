//
// RSAutocompleteCell.m
//
// © Reaction Software Inc., 2013
//

#import <UITheme/RSUITheme.h>

#import "RSAutocompleteCell.h"

@implementation RSAutocompleteCell

#pragma mark - UIView

- (nonnull instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    self.contentView.backgroundColor = [UIColor colorWithRed:.929411765f green:.933333333f blue:.949019608f alpha:1.0f];

    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _textLabel.font = [UIFont systemFontOfSize:17];
    _textLabel.textAlignment = NSTextAlignmentCenter;

    _textLabel.textColor = [UIColor blackColor];

    self.contentView.layer.cornerRadius = 5.0f;

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
    size.width += 30.0f;
    size.height += 16.0f;
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

@end
