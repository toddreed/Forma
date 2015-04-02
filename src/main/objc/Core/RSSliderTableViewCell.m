//
// RSSliderTableViewCell.m
//
// © Reaction Software Inc., 2013
//


#import "RSSliderTableViewCell.h"


@implementation RSSliderTableViewCell

#pragma mark RSSliderTableViewCell

@synthesize slider;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        slider = [[UISlider alloc] initWithFrame:CGRectZero];
        slider.continuous = NO;
        [self.contentView addSubview:slider];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize labelSize = [self.textLabel sizeThatFits:CGSizeZero];
    CGRect contentBounds = self.contentView.bounds;
    CGRect sliderFrame = slider.frame;
    
    sliderFrame.size = [slider sizeThatFits:CGSizeZero];
    sliderFrame.origin.x = self.textLabel.frame.origin.x + labelSize.width + 10;
    sliderFrame.origin.y = contentBounds.origin.y+(contentBounds.size.height-sliderFrame.size.height)/2;
    sliderFrame.size.width = contentBounds.size.width - sliderFrame.origin.x - self.textLabel.frame.origin.x;
    slider.frame = sliderFrame;
}

@end
