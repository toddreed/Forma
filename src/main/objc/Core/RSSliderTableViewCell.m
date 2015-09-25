//
// RSSliderTableViewCell.m
//
// © Reaction Software Inc., 2013
//


#import "RSSliderTableViewCell.h"


@implementation RSSliderTableViewCell

#pragma mark RSSliderTableViewCell

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    _slider = [[UISlider alloc] initWithFrame:CGRectZero];
    _slider.continuous = NO;
    [self.contentView addSubview:_slider];

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize labelSize = [self.textLabel sizeThatFits:CGSizeZero];
    CGRect contentBounds = self.contentView.bounds;
    CGRect sliderFrame = _slider.frame;
    
    sliderFrame.size = [_slider sizeThatFits:CGSizeZero];
    sliderFrame.origin.x = self.textLabel.frame.origin.x + labelSize.width + 10;
    sliderFrame.origin.y = contentBounds.origin.y+(contentBounds.size.height-sliderFrame.size.height)/2;
    sliderFrame.size.width = contentBounds.size.width - sliderFrame.origin.x - self.textLabel.frame.origin.x;
    _slider.frame = sliderFrame;
}

@end
