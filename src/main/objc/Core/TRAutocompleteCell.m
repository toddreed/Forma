//
// TRAutocompleteCell.m
//
// © Reaction Software Inc., 2013
//

#import "UITheme/TRUITheme.h"

#import "TRAutocompleteCell.h"

@implementation TRAutocompleteCell

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _textLabel.font = [[self class] font];
        _textLabel.textAlignment = NSTextAlignmentCenter;

        id<TRUITheme> theme = [TRUITheme currentTheme];
        _textLabel.backgroundColor = [theme backgroundColorWithAlpha:1.0f];
        _textLabel.textColor = [theme selectedForegroundColorWithAlpha:1.0f];

        _textLabel.layer.borderColor = [theme borderColorWithAlpha:1.0f].CGColor;
        _textLabel.layer.borderWidth = 1.0f;
        _textLabel.layer.cornerRadius = 4.0f;

        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

#pragma mark - TRAutocompleteCell

+ (UIFont *)font
{
    id<TRUITheme> theme = [TRUITheme currentTheme];
    return [theme defaultFontOfSize:16.0];
}

+ (CGSize)preferredSizeForString:(NSString *)string
{
    UIFont *font = [[self class] font];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGSize size = [string sizeWithAttributes:attributes];
    size.width += 16.0f;
    size.height += 4.0f;
    return size;
}

@end
